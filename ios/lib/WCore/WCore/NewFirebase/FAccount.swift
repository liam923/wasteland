//
//  FAccount.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// An implementation of Account using firebase.
public class FAccount: FObservableObject, Account {
    public let id: String
    public let displayName: String? = nil
    public let photoURL: URL? = nil
    
    /// Initialize a new FAccount object corresponding to the user with the given id.
    /// If auto-refresh is set to `true`, then this object will listen for changes from the database.
    /// - Parameters:
    ///   - id: the user id of the account
    ///   - autoRefresh: whether or not this object should refresh on its own
    init(id: String, autoRefresh: Bool = false) {
        self.id = id
        
        // TODO: auto refresh
    }
}
