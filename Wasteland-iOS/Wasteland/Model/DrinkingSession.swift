//
//  MutableDrinkingSession.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An session of drinking
class DrinkingSession: MutableRefreshable, Identifiable {
    private(set) var active = true
    
    /// A unique identifier for this object.
    @Published var id: String
    /// The time that the drinking session began at.
    @Published var openTime: Date
    /// The location the drinking session was opened at.
    @Published var openLocation: CLLocationCoordinate2D
    /// The time the drinking session closed or is scheduled to close.
    @Published var closeTime: Date
    /// The location the drinking session was closed at. (nil if still open)
    @Published var closeLocation: CLLocationCoordinate2D?
    /// The list of drinks had within the drinking session.
    @Published var drinks: [Drink]
    
    private init(id: String, openTime: Date, openLocation: CLLocationCoordinate2D, closeTime: Date, closeLocation: CLLocationCoordinate2D?, drinks: [Drink.Builder]) {
        self.id = id
        self.openTime = openTime
        self.openLocation = openLocation
        self.closeTime = closeTime
        self.closeLocation = closeLocation
        self.drinks = []
        for drink in drinks {
            add(drink: drink)
        }
    }
    
    class Builder {
        private let id: String
        private let openTime: Date
        private let openLocation: CLLocationCoordinate2D
        private let closeTime: Date
        private let closeLocation: CLLocationCoordinate2D?
        private let drinks: [Drink.Builder]
        
        init(openTime: Date, openLocation: CLLocationCoordinate2D, closeTime: Date, closeLocation: CLLocationCoordinate2D?, drinks: [Drink.Builder]) {
            self.id = UUID().uuidString
            self.openTime = openTime
            self.openLocation = openLocation
            self.closeTime = closeTime
            self.closeLocation = closeLocation
            self.drinks = drinks
        }
        
        /// private
        func build() -> DrinkingSession {
            return DrinkingSession(id: id, openTime: openTime, openLocation: openLocation, closeTime: closeTime, closeLocation: closeLocation, drinks: drinks)
        }
        
    }
    
    /// Constructs the given drink and adds it to this drinking session.
    /// - Parameter drink: the drink to add
    /// - Returns: the constructed drink
    @discardableResult
    func add(drink: Drink.Builder) -> Drink {
        let d = drink.build()
        drinks.insert(d, at: drinks.insertionIndexOf(d) { $0.time < $1.time })
        return d
    }
    
    func sendChanges(completion: ((Error?) -> Void)?) {
        
    }
}

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
