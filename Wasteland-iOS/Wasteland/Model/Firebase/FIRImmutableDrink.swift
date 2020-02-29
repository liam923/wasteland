//
//  FIRDrink.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRImmutableDrink: FIRRefreshable, Drink {
    private(set) var type: DrinkType?
    private(set) var location: CLLocationCoordinate2D
    private(set) var time: Date
    private(set) var inferredSpacetime: Bool
    
    init(type: DrinkType? = nil, location: CLLocationCoordinate2D, time: Date, inferredSpacetime: Bool) {
        self.type = type
        self.location = location
        self.time = time
        self.inferredSpacetime = inferredSpacetime
    }
}
