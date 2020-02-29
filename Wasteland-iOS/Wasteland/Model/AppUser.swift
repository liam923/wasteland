//
// Created by Liam Stevenson on 2/4/20.
// Copyright (c) 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit
import UIKit

/// The account of the current user.
protocol AppUser: Friend {
    /// The user currently signed in.
    static var current: AppUser? { get }
    
    /// Present a login page and attempt to login a user.
    /// - Parameter handler: the view controller presenting the login screen
    /// - Parameter completion: completion handler
    static func login(handler: UIViewController, completion: (Error?) -> Void)
    
    /// Logout the current user.
    /// - Parameter completion: completion handler
    func logout(completion: (Error?) -> Void)
    
    /// The user's current location.
    var location: CLLocationCoordinate2D { get set }
    /// The user's friend list.
    var friends: [Friend] { get }
    /// The list of user's who this user has friend requested.
    var sentFriendRequests: [Account] { get }
    /// The list of user's who friend requested this user.
    var receivedFriendRequests: [Account] { get }
    
    /// Send a friend request to the given user.
    /// - Parameters:
    ///   - user: the user to send the friend request to
    ///   - completion: completion handler
    func sendFriendRequest(_ user: Account, completion: ((Error?) -> Void)?)
    
    /// Reply to a friend request from a given user.
    /// - Parameters:
    ///   - user: the user whose friend request is being replied to
    ///   - accepted: true if the request is accepted, false if denied
    ///   - completion: completion handler
    func replyToFriendRequest(_ user: Account, accepted: Bool, completion: ((Error?) -> Void)?)
}