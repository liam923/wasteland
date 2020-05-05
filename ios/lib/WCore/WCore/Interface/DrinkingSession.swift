//
//  DrinkingSession.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An object representing a drinking session.
public protocol DrinkingSession: ObservableObject, HashedIdentifiable where ID == String {
    /// The time at which this drinking session was opened.
    var openTime: Date { get }
    /// The time at which this drinking session closed or will close.
    /// The time will be extended whenever a new drink is added to it.
    var closeTime: Date { get }
    /// A map of ids of users to drinks had by that user in this drinking session.
    var drinks: [String: [Drink]] { get }
    /// The ids of users who are currently in this drinking session.
    var currentMembers: Set<String> { get }
    /// The ids of users who were in this drinking session at any time.
    var historicMembers: Set<String> { get }
    /// Invitations for people to join this drinking session that have been sent.
    var invites: Set<Invite> { get }
    
    /// Record a drink had by the active user in this drinking session.
    /// - Parameters:
    ///   - type: the type of drink had
    ///   - time: the time at which the drink was had
    ///   - location: the location at which the drink was had.
    ///   Expected errors: `NetworkingError`
    func addDrink(type: DrinkType?, time: Date?, location: CLLocationCoordinate2D?)
    
    /// Delete a drink had by the active user in this drinking session.
    /// - Parameter id: the id of the drink to delete.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistentError` (no drink with the given id exists in the drinking session)
    func removeDrink(withID id: String)
    
    /// Invite a user to join the drinking session.
    /// You must be a member of the drinking session to perform this action.
    /// - Parameters:
    ///   - toUserWithId: the id of the user to send the invite to
    ///   - completion: a callback for after the invite is sent or fails to send
    ///   - error: nil if the invite is sent successfully.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistentError` (there is no friend with the given id),
    ///   `RedundantError` (the user is already in the drinking session)
    func sendInvite(toUserWithId id: String, completion: (_ error: WError?) -> Void)
    
    /// Un-invite a user to join the drinking session.
    /// You must have already invited the user to the drinking session to perform this action.
    /// - Parameters:
    ///   - toUserWithId: the id of the user to send the invite to
    ///   - completion: a callback for after the invite is sent or fails to send
    ///   - error: nil if the invite is sent successfully.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistentError` (there is no outstanding invite to the given user)
    func revokeInvite(toUserWithId id: String, completion: (_ error: WError?) -> Void)
    
    /// Accept or decline an invite to join this drinking session.
    /// You must have received an invite to perform this action.
    /// - Parameters:
    ///   -  completion: a callback for after the drinking session is joined or is failed to join
    ///   -  error: nil if the drinking session is joined successfully.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistent` (there is no outstanding invite to join this drinking session)
    func replyToInvite(accept: Bool, completion: (_ error: WError?) -> Void)
    
    /// Leave the drinking session.
    /// Doing so makes you no longer a current member.
    /// You must be a current member to perform this action.
    /// - Parameters:
    ///   -  purgeHistory: your history of being in this session will be forgotten iff this is true
    ///   -  completion: a callback for after the drinking session is successfully left or failed to leave
    ///   -  error: nil if the drinking session is left successfully.
    ///   Expected errors: `NetworkingError`,
    ///   `RedundantError` (the user is not currently in this drinking session)
    func leave(purgeHistory: Bool, completion: (_ error: WError?) -> Void)
    
    /// Purge the history of you within this drinking session.
    /// You must have already been a member of this drinking session to perform this action.
    /// - Parameters:
    ///   -  completion: a callback for after the history is reased or is failed to erase
    ///   -  error: nil if the history is erased successfully.
    ///   Expected errors: `NetworkingError`
    func purgeHistory(completion: (_ error: WError?) -> Void)
}

// MARK: Default Implementations

public extension DrinkingSession {
    /// Delete a drink had by the active user in this drinking session.
    /// - Parameter drink: the drink to delete.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistentError` (the given drink does not exist in the drinking session)
    func removeDrink(_ drink: Drink) {
        return removeDrink(withID: drink.id)
    }
}

// MARK: Helper Types

/// A drink had by someone.
public struct Drink: HashedIdentifiable {
    public let id: String
    /// The time at which the drink was had, if recorded.
    public let time: Date?
    /// The location where the drink was had, if recorded.
    public let location: CLLocationCoordinate2D?
    /// What kind of drink the drink was.
    public let type: DrinkType?
}

/// A type of drink.
public enum DrinkType {
    case beer
    case wine
    case shot
}

/// An invite sent from one user to another.
public struct Invite: HashedIdentifiable {
    public var id: String
    /// The id of the user who sent this invite.
    public var from: String
    /// The id of the user who received this invite.
    public var to: String
}
