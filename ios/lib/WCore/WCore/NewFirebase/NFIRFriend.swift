//
//  NFIRFriend.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An implementation of Friend using firebase.
public class NFIRFriend: Friend {
    // TODO: sink change events
    private let superAccount: NFIRAccount = NFIRAccount()
    
    public let location: CLLocationCoordinate2D? = nil
    public let locationAsOf: Date? = nil
    public let currentDrinkingSession: NFIRDrinkingSession? = nil
    public let currentBlackout: NFIRBlackout? = nil
    public let bestFriends: Bool = false
    
    public func fetchHistoricDrinkingSessions(from: Date,
                                              to: Date,
                                              completion: ([NFIRDrinkingSession]?, WError?) -> Void) { }
    
    public func fetchHistoricBlackouts(from: Date, to: Date, completion: ([NFIRBlackout]?, WError?) -> Void) { }
    
    // MARK: Account Encapsulation
    
    public var id: String { return superAccount.id }
    public var displayName: String? { return superAccount.displayName }
    public var photoURL: URL? { return superAccount.photoURL }
}
