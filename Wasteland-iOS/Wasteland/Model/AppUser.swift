//
//  AppUser.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// The account of the current user.
class AppUser: Friend {
    @Published private(set) var friends: [Friend]
    @Published private(set) var sentFriendRequests: [Account]
    @Published private(set) var receivedFriendRequests: [Account]
    
    /// package private
    init(id: String,
         displayName: String,
         photoURL: URL? = nil,
         location: CLLocationCoordinate2D? = nil,
         friends: [Friend],
         sentFriendRequests: [Account],
         receivedFriendRequests: [Account],
         currentDrinkingSession: DrinkingSession? = nil,
         currentBlackout: UserBlackout? = nil) {
        
        self.friends = friends
        self.sentFriendRequests = sentFriendRequests
        self.receivedFriendRequests = receivedFriendRequests
        
        super.init(id: id, displayName: displayName, photoURL: photoURL, location: location, currentDrinkingSession: currentDrinkingSession, currentBlackout: currentBlackout)
    }
    
    /// Logout the current user.
    /// - Parameter completion: completion handler
    func logout(completion: (Error?) -> Void) {
        
    }
    
    /// Send a friend request to the given user.
    /// - Parameters:
    ///   - user: the user to send the friend request to
    ///   - completion: completion handler
    func sendFriendRequest(_ user: Account, completion: ((Error?) -> Void)?) {
        
    }
    
    /// Reply to a friend request from a given user.
    /// - Parameters:
    ///   - user: the user whose friend request is being replied to
    ///   - accepted: true if the request is accepted, false if denied
    ///   - completion: completion handler
    func replyToFriendRequest(_ user: Account, accepted: Bool, completion: ((Error?) -> Void)?) {
        
    }
    
    /// Record the user's location.
    /// - Parameters:
    ///   - location: the current location of the user
    ///   - completion: completion handler
    func record(location: CLLocationCoordinate2D, completion: ((Error?) -> Void)?) {
        
    }
    
    /// Constructs the given drinking session and adds it to this user.
    /// - Parameter drinkingSession: the drinking session to construct
    /// - Returns: the constructed drinking session
    func add(drinkingSession: DrinkingSession.Builder) -> DrinkingSession {
        return drinkingSession.build()
    }
}
