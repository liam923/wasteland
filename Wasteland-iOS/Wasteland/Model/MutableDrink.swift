//
//  MutableDrink.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// A drink had by someone.
protocol MutableDrink: Drink, MutableRefreshable {
    /// The type of drink. (nil if unknown)
    var type: DrinkType? { get set }
    /// The location the drink was had.
    var location: CLLocationCoordinate2D { get set }
    /// The time the drink was had.
    var time: Date { get set }
    /// `true` iff the time and location were inferred rather than explicitely set / recorded.
    var inferredSpacetime: Bool { get set }
}
