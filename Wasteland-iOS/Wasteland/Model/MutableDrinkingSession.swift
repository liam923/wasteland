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
protocol MutableDrinkingSession: DrinkingSession {
    associatedtype GMutableDrink: MutableDrink
    
    /// The time that the drinking session began at.
    var openTime: Date { get set }
    /// The location the drinking session was opened at.
    var openLocation: CLLocationCoordinate2D { get set }
    /// The time the drinking session closed or is scheduled to close.
    var closeTime: Date { get set }
    /// The location the drinking session was closed at. (nil if still open)
    var closeLocation: CLLocationCoordinate2D? { get set }
    /// The list of drinks had within the drinking session.
    var drinks: [GMutableDrink] { get set }
}
