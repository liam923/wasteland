//
//  FAppUser.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An implementation of AppUser using firebase.
public class FAppUser: AppUser {
    public typealias GAccount = FAccount
    public typealias GFriend = FFriend
    
    // TODO: sink change events
    private let superFriend: FFriend = FFriend()
    
    public let userSettings: UserSettings = UserSettings(allowBlackoutReportsFrom: Set(),
                                                         blackoutReportsBlacklist: Set(),
                                                         blackoutNotificationsFrom: Set(),
                                                         drinkNotificationsFrom: Set())
    public let sentFriendRequests: Set<String> = Set()
    public let receivedFriendRequests: Set<String> = Set()
    public let receivedDrinkingSessionInvites: Set<String> = Set()
    
    public func sendFriendRequest(toUserWithId id: String, completion: (WError?) -> Void) { }
    
    public func respondToFriendRequest(fromUserWithId id: String, accept: Bool, completion: (WError?) -> Void) { }
    
    public func unfriend(userWithId id: String, completion: (WError?) -> Void) { }
    
    public func reportBlackout(ofUserWithId id: String, completion: (FBlackout?, WError?) -> Void) { }
    
    public func toggleBestfriend(userWithId id: String, isBestfriend: Bool, completion: (WError?) -> Void) { }
    
    public func recordLocation(location: CLLocationCoordinate2D?, completion: (WError?) -> Void) { }
    
    public func openDrinkingSession(completion: (FDrinkingSession?, WError?) -> Void) { }
    
    public func set(settings: UserSettings, completion: (WError?) -> Void) { }
    
    public func signOut() throws { }
    
    // MARK: Friend Encapsulation
    
    public var id: String { return superFriend.id }
    public var displayName: String? { return superFriend.displayName }
    public var photoURL: URL? { return superFriend.photoURL }
    public var location: CLLocationCoordinate2D? { return superFriend.location }
    public var locationAsOf: Date? { return superFriend.locationAsOf }
    public var currentDrinkingSession: FDrinkingSession? { return superFriend.currentDrinkingSession }
    public var currentBlackout: FBlackout? { return superFriend.currentBlackout }
    public var bestFriends: Bool { return superFriend.bestFriends }
    
    public func fetchHistoricDrinkingSessions(from: Date,
                                              to: Date,
                                              completion: ([FDrinkingSession]?, WError?) -> Void) {
        return superFriend.fetchHistoricDrinkingSessions(from: from, to: to, completion: completion)
    }
    
    public func fetchHistoricBlackouts(from: Date, to: Date, completion: ([FBlackout]?, WError?) -> Void) {
        return superFriend.fetchHistoricBlackouts(from: from, to: to, completion: completion)
    }
}