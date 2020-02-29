//
// Created by Liam Stevenson on 2/4/20.
// Copyright (c) 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// A person on the user's friend list.
protocol Friend: Account {
    associatedtype GBlackout: Blackout
    associatedtype GDrinkingSession: DrinkingSession
    
    /// The person's current location.
    var location: CLLocationCoordinate2D? { get }
    /// The time the person's location was last updated.
    var locationAsOf: Date? { get }
    /// The person's current drinking session, if they have one.
    var currentDrinkingSession: GDrinkingSession? { get }
    /// The person's current blackout, if they have one.
    var currentBlackout: GBlackout? { get }
    
    /// Report this user as blacked out.
    /// - Parameter completion: a completion handler that takes the blackout object connected to this report
    func reportBlackout(completion: (GBlackout?, Error?) -> Void)
    
    /// Fetch all drinking sessions belonging to the user between the given times.
    /// - Parameters:
    ///   - from: the beginning of the interval to fetch from
    ///   - to: the ending of the interval to fetch from
    ///   - completion: a completion handler that takes a list of the drinking sessions within the given interval
    func fetchHistoricDrinkingSessions(from: Date, to: Date, completion: ([GDrinkingSession], Error) -> Void)
}
