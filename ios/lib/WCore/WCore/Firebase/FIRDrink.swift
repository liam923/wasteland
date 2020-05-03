//
//  FIRDrink.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit
import FirebaseFirestore

/// A drink had by someone.
public class FIRDrink: Identifiable, ObservableObject {
    /// A unique identifier for this object.
    public private(set) var id: String
    /// The type of drink. (nil if unknown)
    public var type: DrinkType? {
        get {
            return self._type
        }
        set {
            self.modifiedFields.insert("type")
            self.modified = true
            self._type = newValue
        }
    }
    var _type: DrinkType? { willSet { self.objectWillChange.send() } }
    /// The location the drink was had.
    public var location: CLLocationCoordinate2D {
        get {
            return _location
        }
        set {
            self.modifiedFields.insert("location")
            self.modified = true
            self._location = newValue
        }
    }
    var _location: CLLocationCoordinate2D { willSet { self.objectWillChange.send() } }
    /// The time the drink was had.
    public var time: Date {
        get {
            return _time
        }
        set {
            self.modifiedFields.insert("time")
            self.modified = true
            self._time = newValue
        }
    }
    var _time: Date { willSet { self.objectWillChange.send() } }
    /// `true` iff the time and location were inferred rather than explicitely set / recorded.
    public var inferredSpacetime: Bool {
        get {
            return _inferredSpacetime
        }
        set {
            self.modifiedFields.insert("inferredSpacetime")
            self.modified = true
            self._inferredSpacetime = newValue
        }
    }
    var _inferredSpacetime: Bool { willSet { self.objectWillChange.send() } }
    var modified = false {
        didSet {
            if modified {
                self.parent?.modifiedDrink()
            } else {
                self.modifiedFields.removeAll()
            }
        }
    }
    var modifiedFields = Set<String>()
    private var modelToSet: Model?

    private var document: Document<Model>

    weak var parent: FIRDrinkingSession?

    struct Model: Codable {
        let type: DrinkType?
        let location: GeoPoint
        let time: Timestamp
        let inferredSpacetime: Bool
    }

    private init(id: String? = nil,
                 type: DrinkType? = nil,
                 location: CLLocationCoordinate2D,
                 time: Date,
                 inferredSpacetime: Bool,
                 drinkingSessionDocument: DocumentReference) {
        if let id = id {
            self.document = Document(document: drinkingSessionDocument.collection("drinks")
                .document(id), className: "FIRDrink")
        } else {
            self.document = Document(document: drinkingSessionDocument.collection("drinks")
                .document(), className: "FIRDrink")
        }
        self.id = self.document.documentReference.documentID
        self._type = type
        self._location = location
        self._time = time
        self._inferredSpacetime = inferredSpacetime
        self.modified = false
    }

    /// Initialize from a model and do not automatically refresh from the database.
    init(document: DocumentReference, fromModel model: Model, modified: Bool) {
        self.document = Document(document: document, className: "FIRDrink")
        self.id = document.documentID
        self._type = model.type
        self._location = model.location.location
        self._time = model.time.dateValue()
        self._inferredSpacetime = model.inferredSpacetime
        self.modified = modified
    }

    public class Builder {
        private let id: String?
        private let type: DrinkType?
        private let location: CLLocationCoordinate2D
        private let time: Date
        private let inferredSpacetime: Bool
        private let drinkingSessionDocument: DocumentReference

        public init(id: String? = nil,
                    type: DrinkType? = nil,
                    location: CLLocationCoordinate2D,
                    time: Date,
                    inferredSpacetime: Bool,
                    drinkingSessionDocument: DocumentReference) {
            self.id = id
            self.type = type
            self.location = location
            self.time = time
            self.inferredSpacetime = inferredSpacetime
            self.drinkingSessionDocument = drinkingSessionDocument
        }

        init(id: String? = nil, model: Model, drinkingSessionDocument: DocumentReference) {
            self.id = id
            self.type = model.type
            self.location = model.location.location
            self.time = model.time.dateValue()
            self.inferredSpacetime = model.inferredSpacetime
            self.drinkingSessionDocument = drinkingSessionDocument
        }

        func build(drinkingSessionDocument: DocumentReference) -> FIRDrink {
            return FIRDrink(id: id,
                         type: type,
                         location: location,
                         time: time,
                         inferredSpacetime: inferredSpacetime,
                         drinkingSessionDocument: drinkingSessionDocument)
        }
    }

    func set(fromModel model: Model) {
        if !self.modified {
            self.modelToSet = nil

            self._type = model.type
            self._location = model.location.location
            self._time = model.time.dateValue()
            self._inferredSpacetime = model.inferredSpacetime
            self.modified = false
        } else {
            self.modelToSet = model
        }
    }

    func sendChanges(completion: ((Error?) -> Void)?) {
        let model = Model(type: self.type,
                          location: self.location.geopoint,
                          time: self.time.timestamp,
                          inferredSpacetime: self.inferredSpacetime)
        self.document.upload(data: model, updatedFields: [String](self.modifiedFields)) { error in
            if error == nil { self.modified = false }
            completion?(error)
        }
    }

    func sendChanges(inTransaction transaction: Transaction) {
        let model = Model(type: self.type,
                          location: self.location.geopoint,
                          time: self.time.timestamp,
                          inferredSpacetime: self.inferredSpacetime)
        self.document.upload(data: model, inTransaction: transaction)
    }

    func delete(completion: ((Error?) -> Void)?) {
        document.delete(completion: completion)
    }

    func delete(inTransaction transaction: Transaction) {
        transaction.deleteDocument(self.document.documentReference)
    }
}
