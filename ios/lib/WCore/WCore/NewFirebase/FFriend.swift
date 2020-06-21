//
//  FFriend.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import MapKit

/// An implementation of Friend using firebase.
public class FFriend: FObservableObject, Friend {
    private let superAccount: FAccount
    
    public let location: CLLocationCoordinate2D? = nil
    public let locationAsOf: Date? = nil
    public let currentDrinkingSession: FDrinkingSession? = nil
    public let currentBlackout: FBlackout? = nil
    public let bestFriends: Bool = false
    
    /// Initialize a new FFriend object corresponding to the user with the given id.
    /// If auto-refresh is set to `true`, then this object will listen for changes from the database.
    /// - Parameters:
    ///   - id: the user id of the friend
    ///   - autoRefresh: whether or not this object should refresh on its own
    init(id: String, autoRefresh: Bool = false) {
        self.superAccount = FAccount(id: id, autoRefresh: autoRefresh)
        super.init()
        self.receive(from: superAccount)
        
        // TODO: auto refresh
    }
    
    /// Update the fields of this class based on the given DTO.
    /// - Parameter model: the DTO to update the class based on;
    /// `nil` is interpreted as the object having been deleted
    func set(fromModel model: FUserDTO?) {
        
    }
    
    public func fetchHistoricDrinkingSessions(from: Date,
                                              to: Date,
                                              completion: ([FDrinkingSession]?, WError?) -> Void) { }
    
    public func fetchHistoricBlackouts(from: Date, to: Date, completion: ([FBlackout]?, WError?) -> Void) { }
    
    // MARK: Account Encapsulation
    
    public var id: String { return superAccount.id }
    public var displayName: String? { return superAccount.displayName }
    public var photoURL: URL? { return superAccount.photoURL }
}
