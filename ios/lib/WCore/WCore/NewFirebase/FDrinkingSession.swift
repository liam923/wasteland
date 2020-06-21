//
//  FDrinkingSession.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import MapKit

/// An implementation of DrinkingSession using firebase.
public class FDrinkingSession: FObservableObject, DrinkingSession {
    public let id: String
    public let openTime: Date = Date()
    public let closeTime: Date = Date()
    public let drinks: [String: [Drink]] = [:]
    public let currentMembers: Set<String> = Set()
    public let historicMembers: Set<String> = Set()
    public let invites: Set<Invite> = Set()
    
    init(id: String) {
        self.id = id
    }
    
    public func addDrink(type: DrinkType?, time: Date?, location: CLLocationCoordinate2D?) { }
    
    public func removeDrink(withID id: String) { }
    
    public func sendInvite(toUserWithId id: String, completion: (WError?) -> Void) { }
    
    public func revokeInvite(toUserWithId id: String, completion: (WError?) -> Void) { }
    
    public func replyToInvite(accept: Bool, completion: (WError?) -> Void) { }
    
    public func leave(purgeHistory: Bool, completion: (WError?) -> Void) { }
    
    public func purgeHistory(completion: (WError?) -> Void) { }
}
