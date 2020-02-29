//
//  FIRMutableDrink.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRMutableDrink: FIRRefreshable, MutableDrink {
    var type: DrinkType?
    var location: CLLocationCoordinate2D
    var time: Date
    var inferredSpacetime: Bool
    
    init(type: DrinkType? = nil, location: CLLocationCoordinate2D, time: Date, inferredSpacetime: Bool) {
        self.type = type
        self.location = location
        self.time = time
        self.inferredSpacetime = inferredSpacetime
    }
    
    func sendChanges(completion: ((Error?) -> Void)?) {
        
    }
}
