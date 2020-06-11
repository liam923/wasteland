//
//  FFriend.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An implementation of Friend using firebase.
public class FFriend: Friend {
    // TODO: sink change events
    private let superAccount: FAccount = FAccount()
    
    public let location: CLLocationCoordinate2D? = nil
    public let locationAsOf: Date? = nil
    public let currentDrinkingSession: FDrinkingSession? = nil
    public let currentBlackout: FBlackout? = nil
    public let bestFriends: Bool = false
    
    public func fetchHistoricDrinkingSessions(from: Date,
                                              to: Date,
                                              completion: ([FDrinkingSession]?, WError?) -> Void) { }
    
    public func fetchHistoricBlackouts(from: Date, to: Date, completion: ([FBlackout]?, WError?) -> Void) { }
    
    // MARK: Account Encapsulation
    
    public var id: String { return superAccount.id }
    public var displayName: String? { return superAccount.displayName }
    public var photoURL: URL? { return superAccount.photoURL }
}
