//
//  Drink.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/4/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// A drink had by someone.
protocol Drink: ObservableObject, Refreshable {
    associatedtype GDrinkingSession: DrinkingSession
    
    /// The type of drink. (nil if unknown)
    var type: DrinkType? { get }
    /// The location the drink was had.
    var location: CLLocationCoordinate2D { get }
    /// The time the drink was had.
    var time: Date { get }
    /// `true` iff the time and location were inferred rather than explicitely set / recorded.
    var inferredSpacetime: Bool { get }
    /// The drinking session this drink is connected to.
    var drinkingSession: GDrinkingSession! { get }
}
