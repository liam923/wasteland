//
//  Drink.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// A drink had by someone.
class Drink: MutableRefreshable, Identifiable {
    private(set) var active = true
    /// A unique identifier for this object.
    @Published var id: String
    /// The type of drink. (nil if unknown)
    @Published var type: DrinkType?
    /// The location the drink was had.
    @Published var location: CLLocationCoordinate2D
    /// The time the drink was had.
    @Published var time: Date
    /// `true` iff the time and location were inferred rather than explicitely set / recorded.
    @Published var inferredSpacetime: Bool
    
    private init(id: String, type: DrinkType? = nil, location: CLLocationCoordinate2D, time: Date, inferredSpacetime: Bool) {
        self.id = id
        self.type = type
        self.location = location
        self.time = time
        self.inferredSpacetime = inferredSpacetime
    }
    
    class Builder {
        private let type: DrinkType?
        private let location: CLLocationCoordinate2D
        private let time: Date
        private let inferredSpacetime: Bool
        
        init(type: DrinkType? = nil, location: CLLocationCoordinate2D, time: Date, inferredSpacetime: Bool) {
            self.type = type
            self.location = location
            self.time = time
            self.inferredSpacetime = inferredSpacetime
        }
        
        /// package private
        func build() -> Drink {
            return Drink(id: UUID().uuidString, type: type, location: location, time: time, inferredSpacetime: inferredSpacetime)
        }
    }
    
    func sendChanges(completion: ((Error?) -> Void)?) {
        
    }
}
