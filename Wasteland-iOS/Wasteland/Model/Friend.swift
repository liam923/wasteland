//
//  Friend.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// A person on the user's friend list.
class Friend: Account {
    /// The person's current location.
    @Published var location: CLLocationCoordinate2D?
    /// The time the person's location was last updated.
    @Published private(set) var locationAsOf: Date?
    /// The person's current drinking session, if they have one.
    @Published private(set) var currentDrinkingSession: DrinkingSession?
    /// The person's current blackout, if they have one.
    @Published private(set) var currentBlackout: Blackout?
    
    /// package private
    init(id: String,
         displayName: String,
         photoURL: URL? = nil,
         location: CLLocationCoordinate2D? = nil,
         currentDrinkingSession: DrinkingSession? = nil,
         currentBlackout: Blackout? = nil) {
             
        self.location = location
        self.currentDrinkingSession = currentDrinkingSession
        self.currentBlackout = currentBlackout
        
        super.init(id: id, displayName: displayName, photoURL: photoURL)
    }
    
    /// Report this user as blacked out.
    /// - Parameter completion: a completion handler that takes the blackout object connected to this report
    func reportBlackout(completion: (Blackout?, Error?) -> Void) {
        
    }
    
    /// Fetch all drinking sessions belonging to the user between the given times.
    /// - Parameters:
    ///   - from: the beginning of the interval to fetch from
    ///   - to: the ending of the interval to fetch from
    ///   - completion: a completion handler that takes a list of the drinking sessions within the given interval
    func fetchHistoricDrinkingSessions(from: Date, to: Date, completion: ([DrinkingSession], Error) -> Void) {
        
    }
    
    /// Fetch all blackouts belonging to the user between the given times.
    /// - Parameters:
    ///   - from: the beginning of the interval to fetch from
    ///   - to: the ending of the interval to fetch from
    ///   - completion: a completion handler that takes a list of the blackouts within the given interval
    func fetchHistoricBlackouts(from: Date, to: Date, completion: ([Blackout], Error) -> Void) {
        
    }
}
