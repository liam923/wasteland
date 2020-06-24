//
//  FDocument.swift
//  WCore
//
//  Created by Liam Stevenson on 6/24/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import CodableFirebase
import FirebaseFirestore

class FDocument<Model: Codable> {
    typealias Listener = (Model?) -> Void

    var active: Bool {
        didSet {
            if oldValue && !self.active {
                self.deactivateListener()
            } else if !oldValue && self.active {
                self.activateListener()
            }
        }
    }

    let documentReference: DocumentReference
    private let className: String
    private var listeners: [Listener]
    private var listenerRegistration: ListenerRegistration?

    init(document: DocumentReference,
         className: String,
         listener: Listener? = nil,
         active: Bool = true) {
        self.active = active
        self.documentReference = document
        self.className = className
        self.listeners = []

        if let listener = listener {
            self.add(listener: listener)
        }
    }

    func add(listener: @escaping Listener) {
        self.listeners.append(listener)
        if self.listenerRegistration == nil {
            self.listenerRegistration = self.documentReference.addSnapshotListener(makeSnapshotListener())
        }
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
        documentReference.delete { [weak self] error in
            if error != nil {
                for listener in self?.listeners ?? [] {
                    listener(nil)
                }
            }
            completion?(error)
        }
    }

    private func deactivateListener() {
        self.listenerRegistration?.remove()
        self.listenerRegistration = nil
    }

    private func activateListener() {
        self.listenerRegistration = self.documentReference.addSnapshotListener(makeSnapshotListener())
    }
    
    private func makeSnapshotListener() -> FIRDocumentSnapshotBlock {
        return { [weak self] (snapshot, error) in
            let className = self?.className ?? ""
            guard error == nil else {
                Log.error("Error refreshing \(className): \(error!.localizedDescription)", category: .firebase)
                return
            }

            guard snapshot?.exists ?? false else {
                for listener in self?.listeners ?? [] {
                    listener(nil)
                }
                return
            }

            if let data = snapshot?.data() {
                if let model = try? FirestoreDecoder().decode(Model.self, from: data) {
                    for listener in self?.listeners ?? [] {
                        listener(model)
                    }
                } else {
                    Log.debug("Malformed \(className) object: \(data)", category: .firebase)
                }
            } else {
                Log.debug("Missing \(className) object", category: .firebase)
            }
        }
    }

    deinit {
        self.deactivateListener()
    }
}
