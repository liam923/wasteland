//
//  Document.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/20/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class Document<Model: Codable> {
    typealias Listener = (Model) -> Void
    typealias DeleteCallback = () -> Void

    var active: Bool {
        didSet {
            if oldValue && !self.active {
                self.deactivateListeners()
            } else if !oldValue && self.active {
                self.activateListeners()
            }
        }
    }

    let documentReference: DocumentReference
    private let className: String
    private var deleteCallbacks: [DeleteCallback]
    private var unsubsubscribers = [ListenerRegistration]()
    private var listeners: [FIRDocumentSnapshotBlock]

    init(document: DocumentReference,
         className: String,
         listener: Listener? = nil,
         deleteCallback: DeleteCallback? = nil,
         active: Bool = true) {
        self.active = active
        self.documentReference = document
        self.className = className
        self.deleteCallbacks = []
        self.listeners = []

        if let listener = listener {
            self.add(listener: listener)
        }
        if let deleteCallback = deleteCallback {
            self.add(deleteCallback: deleteCallback)
        }
    }

    func add(listener: @escaping Listener) {
        let block: FIRDocumentSnapshotBlock = { (snapshot, error) in
            guard error == nil else {
                Log.error("Error refreshing \(self.className): \(error!.localizedDescription)", category: .firebase)
                return
            }

            guard snapshot?.exists ?? false else {
                for deleteCallback in self.deleteCallbacks {
                    deleteCallback()
                }
                return
            }

            if let data = snapshot?.data() {
                if let model = try? FirestoreDecoder().decode(Model.self, from: data) {
                    listener(model)
                } else {
                    Log.debug("Malformed \(self.className) object: \(data)", category: .firebase)
                }
            } else {
                Log.debug("Missing \(self.className) object", category: .firebase)
            }
        }
        self.listeners.append(block)

        if self.active {
            self.unsubsubscribers.append(self.documentReference.addSnapshotListener(block))
        }
    }

    func add(deleteCallback: @escaping DeleteCallback) {
        self.deleteCallbacks.append(deleteCallback)
    }

    func upload(data: Model, updatedFields: [String]? = nil, completion: ((Error?) -> Void)? = nil) {
        var data = (try? FirestoreEncoder().encode(data)) ?? [:]
        if let updatedFields = updatedFields {
            data = data.filter { updatedFields.contains($0.key) }
        }

        self.documentReference.setData(data, merge: true) { (error) in
            if let error = error {
                Log.error("Error updating \(self.className): \(error.localizedDescription)", category: .firebase)
            }
            completion?(error)
        }
    }

    func upload(data: Model, updatedFields: [String]? = nil, inTransaction transaction: Transaction) {
        var data = (try? FirestoreEncoder().encode(data)) ?? [:]
        if let updatedFields = updatedFields {
            data = data.filter { updatedFields.contains($0.key) }
        }

        transaction.setData(data, forDocument: self.documentReference, merge: true)
    }

    func delete(completion: ((Error?) -> Void)? = nil) {
        documentReference.delete { error in
            if error != nil {
                for deleteCallback in self.deleteCallbacks {
                    deleteCallback()
                }
            }
            completion?(error)
        }
    }

    private func deactivateListeners() {
        for unsubscriber in self.unsubsubscribers {
            unsubscriber.remove()
        }
        self.unsubsubscribers = []
    }

    private func activateListeners() {
        self.unsubsubscribers = self.listeners.map { self.documentReference.addSnapshotListener($0) }
    }

    deinit {
        self.deactivateListeners()
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization
            .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
