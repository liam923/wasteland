//
//  AppUser.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import MapKit

/// A user of the app who is currently signed in.
public protocol AppUser: Friend {
    associatedtype GAccount: Account
    associatedtype GFriend: Friend
    
    /// The user's account settings.
    var userSettings: UserSettings { get }
    /// The ids of users who have outstanding friend requests from this user.
    var sentFriendRequests: Set<String> { get }
    /// The ids of users who have sent outstanding friend requests to this user.
    var receivedFriendRequests: Set<String> { get }
    /// The ids of users who have invited this user to their current drinking session.
    var receivedDrinkingSessionInvites: Set<String> { get }
    
    /// Update the user's current location.
    /// - Parameters:
    ///   -  location: the user's location; nil causes the location to be removed
    ///   -  completion: a callback for after succeeding or failing to update location
    ///   -  error: nil if location is successfully updated.
    ///   Expected errors: `NetworkingError`
    func recordLocation(location: CLLocationCoordinate2D?, completion: (_ error: WError?) -> Void)
    
    /// Update the user's settings.
    /// - Parameters:
    ///   -  settings: the user's new settings
    ///   -  completion: a callback for after succeeding or failing to update settings
    ///   -  error: nil if settings are successfully updated.
    ///   Expected errors: `NetworkingError`
    func set(settings: UserSettings, completion: (_ error: WError?) -> Void)
    
    /// Open a new drinking session.
    /// You may not perform this action if already in a drinking session.
    /// - Parameters:
    ///   - completion: a callback for after succeeding or failing to open
    ///   -  drinkingSession: the opened drinking session; nil if opening failed
    ///   -  error: nil if the session is successfully opened.
    ///   Expected errors: `NetworkingError`, `RedundantError` (user is already in a drinking session)
    func openDrinkingSession(completion: (_ drinkingSession: GDrinkingSession?, _ error: WError?) -> Void)
    
    /// Send a friend request to the given user.
    /// The user must not already be a friend in order to perform this action.
    /// - Parameters:
    ///   -  id: the id of the user to send a friend request
    ///   -  completion: a callback for when the sending succeeds or fails
    ///   -  error: nil if the sending is successful.
    ///   Expected errors: `NetworkingError`, `NonExistentError` (the user does not exist),
    ///   `RedundantError` (the user is already a friend or a friend request already exists)
    func sendFriendRequest(toUserWithId id: String, completion: (_ error: WError?) -> Void)
    
    /// Reply to a friend request from the given user.
    /// There must be an outstanding friend request from the given user to perform this action.
    /// - Parameters:
    ///   -  id: the id of the user whose friend request is being replied to
    ///   -  accept: whether the request is being accepted or denied
    ///   -  completion: a callback for when sending the reply succeeds or fails
    ///   -  error: nil if sending the reply is successful.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistent` (there is no outstanding friend request from a user with the given id)
    func respondToFriendRequest(fromUserWithId id: String, accept: Bool, completion: (_ error: WError?) -> Void)
    
    /// Remove the given user to from the user's friendlist.
    /// - Parameters:
    ///   -  id: the id of the user to unfriend
    ///   -  completion: a callback for when the unfriending succeeds or fails
    ///   -  error: nil if the unfriending is successful.
    ///   Expected errors: `NetworkingError`, `NonExistentError` (the user does not have a friend with the given id)
    func unfriend(userWithId id: String, completion: (_ error: WError?) -> Void)
    
    /// Toggle the given friend between a best friend or not a best friend.
    /// - Parameters:
    ///   -
    ///   -  user: the id of the friend to toggle
    ///   -  isBestfriend: whether the friend should be a best friend or not
    ///   -  completion: a callback for when the toggling succeeds or fails
    ///   -  error: nil if the toggling is successful.
    ///   Expected errors: `NetworkingError`, `NonExistentError` (the user does not have a friend with the given id)
    func toggleBestfriend(userWithId id: String, isBestfriend: Bool, completion: (_ error: WError?) -> Void)
    
    /// Report the given user as blacked out.
    /// This action will fail if their settings restrict you from reporting them as blacked out.
    /// - Parameters:
    ///   -  id: the id of the user to report as blacked out
    ///   -  completion: a callback for when the report is sent or fails to send
    ///   -  blackout: the blackout object resulting from this report; nil if an error occurs
    ///   -  error: nil if the blackout is successfully reported.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistentError` (there is no user with the given id that the user has permission to report as blacked out)
    func reportBlackout(ofUserWithId id: String, completion: (_ blackout: GBlackout?, _ error: WError?) -> Void)
    
    /// Sign out this user.
    func signOut() throws
}

// MARK: Default Implementations

extension AppUser {
    /// Send a friend request to the given user.
    /// The user must not already be a friend in order to perform this action.
    /// - Parameters:
    ///   -  user: the user to send a friend request
    ///   -  completion: a callback for when the sending succeeds or fails
    ///   -  error: nil if the sending is successful.
    ///   Expected errors: `NetworkingError`, `NonExistentError` (the user does not exist),
    ///   `RedundantError` (the user is already a friend or a friend request already exists)
    func sendFriendRequest(to user: GAccount, completion: (_ error: WError?) -> Void) {
        return sendFriendRequest(toUserWithId: user.id, completion: completion)
    }
    
    /// Reply to a friend request from the given user.
    /// There must be an outstanding friend request from the given user to perform this action.
    /// - Parameters:
    ///   -  user: the user whose friend request is being replied to
    ///   -  accept: whether the request is being accepted or denied
    ///   -  completion: a callback for when sending the reply succeeds or fails
    ///   -  error: nil if sending the reply is successful.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistent` (there is no outstanding friend request from the user)
    func respondToFriendRequest(from user: GAccount, accept: Bool, completion: (_ error: WError?) -> Void) {
        return respondToFriendRequest(fromUserWithId: user.id, accept: accept, completion: completion)
    }
    
    /// Remove the given user to from the user's friendlist.
    /// - Parameters:
    ///   -  user: the user to unfriend
    ///   -  completion: a callback for when the unfriending succeeds or fails
    ///   -  error: nil if the unfriending is successful.
    ///   Expected errors: `NetworkingError`, `NonExistentError` (the given user is not a friend)
    func unfriend(user: GFriend, completion: (_ error: WError?) -> Void) {
        return unfriend(userWithId: user.id, completion: completion)
    }
    
    /// Toggle the given friend between a best friend or not a best friend.
    /// - Parameters:
    ///   -  user: the friend to toggle
    ///   -  isBestfriend: whether the friend should be a best friend or not
    ///   -  completion: a callback for when the toggling succeeds or fails
    ///   -  error: nil if the toggling is successful.
    ///   Expected errors: `NetworkingError`, `NonExistentError` (the given user is not a friend)
    func toggleBestfriend(user: GFriend, isBestfriend: Bool, completion: (_ error: WError?) -> Void) {
        return toggleBestfriend(userWithId: user.id, isBestfriend: isBestfriend, completion: completion)
    }
    
    /// Report the given user as blacked out.
    /// This action will fail if their settings restrict you from reporting them as blacked out.
    /// - Parameters:
    ///   -  user: the user to report as blacked out
    ///   -  completion: a callback for when the report is sent or fails to send
    ///   -  blackout: the blackout object resulting from this report; nil if an error occurs
    ///   -  error: nil if the blackout is successfully reported.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistentError` (there is no user matching the input where the user has permission to report as
    ///   blacked out)
    func reportBlackout(ofUser user: GAccount,
                        completion: (_ blackout: GBlackout?, _ error: WError?) -> Void) {
        return reportBlackout(ofUserWithId: user.id, completion: completion)
    }
}
