//
//  FIRFriend.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRFriend: FIRAccount, Friend {
    private(set) var location: CLLocationCoordinate2D?
    private(set) var locationAsOf: Date?
    private(set) var currentDrinkingSession: FIRImmutableDrinkingSession?
    private(set) var currentBlackout: FIRBlackout?
    
    init(id: String,
         displayName: String,
         photoURL: URL? = nil,
         location: CLLocationCoordinate2D? = nil,
         currentDrinkingSession: FIRImmutableDrinkingSession? = nil,
         currentBlackout: FIRBlackout? = nil) {
        
        super.init(id: id, displayName: displayName, photoURL: photoURL)
        
        self.location = location
        self.currentDrinkingSession = currentDrinkingSession
        self.currentBlackout = currentBlackout
    }
    
    func reportBlackout(completion: (FIRBlackout?, Error?) -> Void) {
        
    }
    
    func fetchHistoricDrinkingSessions(from: Date, to: Date, completion: ([FIRImmutableDrinkingSession], Error) -> Void) {
        
    }
    
}
