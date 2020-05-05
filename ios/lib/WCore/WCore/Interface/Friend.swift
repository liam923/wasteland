//
//  Friend.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// A user of the app who is a friend of the signed in user.
public protocol Friend: Account {
    associatedtype GBlackout: Blackout
    associatedtype GDrinkingSession: DrinkingSession
    
    /// The user's current location.
    var location: CLLocationCoordinate2D? { get }
    /// The time the user's location was last updated.
    var locationAsOf: Date? { get }
    /// The user's current drinking session, if they have one.
    var currentDrinkingSession: GDrinkingSession? { get }
    /// The person's current blackout, if they have one.
    var currentBlackout: GBlackout? { get }
    /// If true, this user is considered a best friend, which is related to a multitude of features.
    var bestFriends: Bool { get }

    /// Fetch all drinking sessions belonging to the user between the given times.
    /// - Parameters:
    ///   - from: the beginning of the interval to fetch from
    ///   - to: the ending of the interval to fetch from
    ///   - completion: a callback for when the drinking sessions are fetched or are failed to be fetched
    ///   - drinkingSessions: the fetched drinking sessions; nil if an error occurs
    ///   - error: nil if the drinking sessions are successfully fetched
    func fetchHistoricDrinkingSessions(from: Date,
                                       to: Date,
                                       completion: (_ drinkingSessions: [GDrinkingSession]?, _ error: WError?) -> Void)

    /// Fetch all blackouts belonging to the user between the given times.
    /// - Parameters:
    ///   - from: the beginning of the interval to fetch from
    ///   - to: the ending of the interval to fetch from
    ///   - completion: a callback for when the blackouts are fetched or are failed to be fetched
    ///   - blackouts: the fetched blackouts; nil if an error occurs
    ///   - error: nil if the blackouts are successfully fetched
    func fetchHistoricBlackouts(from: Date, to: Date, completion: (_ blackouts: [GBlackout]?, _ error: WError?) -> Void)
}
