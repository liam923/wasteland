//
//  FIRDrinkingSession.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRImmutableDrinkingSession: FIRRefreshable, DrinkingSession {
    private(set) var openTime: Date
    private(set) var openLocation: CLLocationCoordinate2D
    private(set) var closeTime: Date
    private(set) var closeLocation: CLLocationCoordinate2D?
    private(set) var drinks: [FIRImmutableDrink]
    
    init(openTime: Date, openLocation: CLLocationCoordinate2D, closeTime: Date, closeLocation: CLLocationCoordinate2D?, drinks: [FIRImmutableDrink]) {
        self.openTime = openTime
        self.openLocation = openLocation
        self.closeTime = closeTime
        self.closeLocation = closeLocation
        self.drinks = drinks
    }
}
