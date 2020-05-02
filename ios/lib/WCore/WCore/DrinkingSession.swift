//
//  MutableDrinkingSession.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit
import FirebaseFirestore
import CodableFirebase
import Combine

/// An session of drinking
public class DrinkingSession: Identifiable, ObservableObject {
    /// A unique identifier for this object.
    public private(set) var id: String
    /// The time that the drinking session began at.
    public var openTime: Date {
        get {
            return self._openTime
        }
        set {
            self.modifiedFields.insert("openTime")
            self.status = .untied
            self._openTime = newValue
        }
    }
    var _openTime: Date { willSet { self.objectWillChange.send() } }
    /// The location the drinking session was opened at.
    public var openLocation: CLLocationCoordinate2D {
        get {
            return self._openLocation
        }
        set {
            self.modifiedFields.insert("openLocation")
            self.status = .untied
            self._openLocation = newValue
        }
    }
    var _openLocation: CLLocationCoordinate2D { willSet { self.objectWillChange.send() } }
    /// The time the drinking session closed or is scheduled to close.
    public var closeTime: Date {
        get {
            return self._closeTime
        }
        set {
            self.modifiedFields.insert("closeTime")
            self.status = .untied
            self._closeTime = newValue
        }
    }
    var _closeTime: Date { willSet { self.objectWillChange.send() } }
    /// The location the drinking session was closed at. (If still open, this will be where the session was opened.)
    public var closeLocation: CLLocationCoordinate2D {
        get {
            return self._closeLocation
        }
        set {
            self.modifiedFields.insert("closeLocation")
            self.status = .untied
            self._closeLocation = newValue
        }
    }
    var _closeLocation: CLLocationCoordinate2D { willSet { self.objectWillChange.send() } }
    /// The owner of this drinking session.
    public private(set) var drinker: Account {
        didSet {
            self.modifiedFields.insert("drinkerID")
            self.status = .untied
        }
    }
    /// The list of drinks had within the drinking session.
    public var drinks: [Drink] { return self._drinks }
    var _drinks: [Drink] {
        willSet {
            for cancellable in drinksCancellables {
                cancellable?.cancel()
            }
            drinksCancellables = newValue.map {
                $0.objectWillChange.sink {
                    self.objectWillChange.send()
                }
            }
            self.objectWillChange.send()
        }
    }
    private var drinksCancellables: [AnyCancellable?] = []
    private var modifiedDrinks = false
    private var deletedDrinks = [Drink]()
    /// The status of this object.
    public internal(set) var status: Status {
        willSet { self.objectWillChange.send() }
        didSet {
            if self.status == .tied {
                modifiedFields.removeAll()
                self.deletedDrinks.removeAll()
                self.modifiedDrinks = false

                if let model = self.modelToSet {
                    self.set(fromModel: model)
                }
            }
            self.document.active = self.status == .tied
        }
    }
    /// Whether or not this object has been deleted. Set this to true to delete the object.
    public var deleted: Bool {
        get {
            return _deleted
        }
        set {
            self.status = .untied
            self._deleted = newValue
        }
    }
    private var _deleted: Bool { willSet { self.objectWillChange.send() } }

    private var modifiedFields = Set<String>()
    private var modelToSet: Model?

    private var document: Document<Model>
    private var drinkQuery: DocumentQuery<Drink.Model>?

    struct Model: Codable {
        let openTime: Timestamp
        let openLocation: GeoPoint
        let closeTime: Timestamp
        let closeLocation: GeoPoint
        let drinkerID: String
    }

    private init(openTime: Date,
                 openLocation: CLLocationCoordinate2D,
                 closeTime: Date,
                 closeLocation: CLLocationCoordinate2D,
                 drinker: Account,
                 drinks: [Drink.Builder]) {
        let document = Document<Model>(document: AppModel.model.db
            .collection("users")
            .document(drinker.id)
            .collection("sessions")
            .document(),
                                       className: "DrinkingSession")
        self.document = document
        self.id = document.documentReference.documentID
        self._openTime = openTime
        self._openLocation = openLocation
        self._closeTime = closeTime
        self._closeLocation = closeLocation
        self.drinker = drinker
        self._drinks = drinks.map { $0.build(drinkingSessionDocument: document.documentReference) }
        self._deleted = false
        self.status = .untied

        self.openTime = openTime
        self.openLocation = openLocation
        self.closeTime = closeTime
        self.closeLocation = closeLocation
        self.modifiedFields.insert("drinkerID")

        for drink in self.drinks {
            drink.parent = self
        }

        self.document.add(listener: { model in
            self.set(fromModel: model)
            self.status = .tied
        })
        self.document.add(deleteCallback: self.deleteCallback)
        self.drinkQuery = self.makeDrinkQuery()

        for drink in drinks {
            add(drink: drink)
        }
    }

    /// Initialize with a tie to an existing blackout and syncronize with the database.
    init(reference: DocumentReference) {
        self.id = reference.documentID
        self._openTime = Date()
        self._openLocation = CLLocationCoordinate2D()
        self._closeTime = Date()
        self._closeLocation = CLLocationCoordinate2D()
        self.drinker = Account()
        self._drinks = []
        self._deleted = false
        self.status = .untied

        self.document = Document(document: reference, className: "DrinkingSession")

        self.document.add(listener: { model in
            self.set(fromModel: model)
            self.status = .tied
        })
        self.document.add(deleteCallback: self.deleteCallback)
        self.drinkQuery = self.makeDrinkQuery()
    }

    /// Initialize from a model and do not automatically refresh from the database.
    init(id: String, fromModel model: Model, status: Status) {
        self.id = id
        self._openTime = model.openTime.dateValue()
        self._openLocation = CLLocationCoordinate2D(point: model.openLocation)
        self._closeTime = model.closeTime.dateValue()
        self._closeLocation = CLLocationCoordinate2D(point: model.closeLocation)
        self._drinks = []
        self.drinker = Account.make(id: model.drinkerID)
        self._deleted = false
        self.status = .tied

        self.document = Document(document: AppModel.model.db
            .collection("users")
            .document(model.drinkerID)
            .collection("sessions")
            .document(id),
                                 className: "DrinkingSession")
        self.drinkQuery = self.makeDrinkQuery()
    }

    public class Builder {
        private let openTime: Date
        private let openLocation: CLLocationCoordinate2D
        private let closeTime: Date
        private let closeLocation: CLLocationCoordinate2D
        private let drinker: Account
        private let drinks: [Drink.Builder]

        public init(openTime: Date,
                    openLocation: CLLocationCoordinate2D,
                    closeTime: Date,
                    closeLocation: CLLocationCoordinate2D?,
                    drinker: Account,
                    drinks: [Drink.Builder]) {
            self.openTime = openTime
            self.openLocation = openLocation
            self.closeTime = closeTime
            self.closeLocation = closeLocation ?? openLocation
            self.drinker = drinker
            self.drinks = drinks
        }

        func build() -> DrinkingSession {
            return DrinkingSession(openTime: openTime,
                                   openLocation: openLocation,
                                   closeTime: closeTime,
                                   closeLocation: closeLocation,
                                   drinker: drinker,
                                   drinks: drinks)
        }

    }

    private func makeDrinkQuery() -> DocumentQuery<Drink.Model> {
        return DocumentQuery(query: self.document.documentReference.collection("drinks"),
                             className: "Drinks",
                             listener: self.setDrinks)
    }

    /// Constructs the given drink and adds it to this drinking session.
    /// - Parameter drink: the drink to add
    /// - Returns: the constructed drink
    @discardableResult
    public func add(drink: Drink.Builder) -> Drink {
        let d = drink.build(drinkingSessionDocument: self.document.documentReference)
        d.parent = self
        _drinks.insert(d, at: drinks.insertionIndexOf(d) { $0.time < $1.time })
        self.modifiedDrink()
        return d
    }

    /// Removes a drink from this drinking session.
    /// - Parameter drink: the drink to remove
    public func remove(drink: Drink) {
        self._drinks = self._drinks.filter { $0.id != drink.id }
        self.deletedDrinks.append(drink)
        self.modifiedDrink()
    }

    /// Send all changes to this drinking session and all child drinks.
    /// - Parameter completion: callback for completion of sending
    public func sendChanges(completion: ((Error?) -> Void)?) {
        if !self.deleted {
            AppModel.model.db.runTransaction({ (transaction, _) -> Any? in
                let model = Model(openTime: self.openTime.timestamp,
                                  openLocation: self.openLocation.geopoint,
                                  closeTime: self.closeTime.timestamp,
                                  closeLocation: self.closeLocation.geopoint,
                                  drinkerID: self.drinker.id)
                self.document.upload(data: model,
                                     updatedFields: [String](self.modifiedFields),
                                     inTransaction: transaction)

                if self.modifiedDrinks {
                    for drink in self.drinks {
                        drink.sendChanges(inTransaction: transaction)
                    }
                    for drink in self.deletedDrinks {
                        drink.delete(inTransaction: transaction)
                    }
                }
                return nil
            }, completion: { (_, error) in
                if error == nil {
                    for drink in self.drinks {
                        drink.modified = false
                    }
                    self.status = .tied
                }
                completion?(error)
            })
        } else {
            self.document.delete(completion: completion)
        }
    }

    func set(fromModel model: Model) {
        if self.status == .tied {
            self.modelToSet = nil

            self._openTime = model.openTime.dateValue()
            self._openLocation = CLLocationCoordinate2D(point: model.openLocation)
            self._closeTime = model.closeTime.dateValue()
            self._closeLocation = CLLocationCoordinate2D(point: model.closeLocation)
            self._drinks = []
            self.drinker = Account.make(id: model.drinkerID)
            self.status = .tied
        } else {
            self.modelToSet = model
        }
    }

    private func setDrinks(fromModels arr: [(model: Drink.Model, id: String)]) {
        let newDrinks = Set<String>(arr.map { $0.id })
        self._drinks = self.drinks.filter { newDrinks.contains($0.id) }
        var oldDrinks = [String: Drink]()
        for drink in self.drinks {
            oldDrinks[drink.id] = drink
        }

        for (model, id) in arr {
            if let drink = oldDrinks[id] {
                drink.set(fromModel: model)
            } else {
                self.add(drink: Drink.Builder(id: id,
                                              model: model,
                                              drinkingSessionDocument: self.document.documentReference))
            }
        }
        self._drinks = self._drinks.sorted { $0.time < $1.time }
    }

    private func deleteCallback() {
        self.status = .tied
        self.deleted = true
    }

    func modifiedDrink() {
        self.status = .untied
        self.modifiedDrinks = true
    }
}

// copied from stack overflow
extension Array {
    fileprivate func insertionIndexOf(_ elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}
