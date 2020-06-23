//
//  FQuery.swift
//  WCore
//
//  Created by Liam Stevenson on 6/21/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import CodableFirebase
import FirebaseFirestore

class FQuery<Model: Codable> {
    typealias Listener = (_ data: [(model: Model, id: String)], _ query: UUID) -> Void

    let uuid = UUID()
    let query: Query
    private let className: String?
    private var unsubsubscribers = [ListenerRegistration]()

    init(query: Query, className: String? = nil, listener: Listener? = nil) {
        self.query = query
        self.className = className
        if let listener = listener {
            self.add(listener: listener)
        }
    }

    func add(listener: @escaping Listener) {
        self.unsubsubscribers.append(self.query.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                Log.debug("Error refreshing \(self.className ?? ""): \(error!.localizedDescription)",
                    category: .firebase)
                return
            }

            listener(snapshot.documents
                .map { (try? FirestoreDecoder().decode(Model.self, from: $0.data()), $0.documentID) }
                .map { $0.0 == nil ? nil : $0 as? (Model, String) }
                .filter { $0 != nil }
                .map { $0! }, self.uuid)
        })
    }

    deinit {
        for unsubscriber in self.unsubsubscribers {
            unsubscriber.remove()
        }
    }
}
