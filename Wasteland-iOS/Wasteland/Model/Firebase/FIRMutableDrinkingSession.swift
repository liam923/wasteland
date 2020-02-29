//
//  FIRMutableDrinkingSession.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRMutableDrinkingSession: FIRRefreshable, MutableDrinkingSession {
    var openTime: Date
    var openLocation: CLLocationCoordinate2D
    var closeTime: Date
    var closeLocation: CLLocationCoordinate2D?
    var drinks: [FIRMutableDrink]
    
    init(openTime: Date, openLocation: CLLocationCoordinate2D, closeTime: Date, closeLocation: CLLocationCoordinate2D?, drinks: [FIRMutableDrink]) {
        self.openTime = openTime
        self.openLocation = openLocation
        self.closeTime = closeTime
        self.closeLocation = closeLocation
        self.drinks = drinks
    }
    
    func sendChanges(completion: ((Error?) -> Void)?) {
        
    }
}
