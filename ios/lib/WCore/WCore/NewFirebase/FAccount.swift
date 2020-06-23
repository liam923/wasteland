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
    public internal(set) var deleted: Bool = false
    
    /// Initialize a new FAccount object corresponding to the user with the given id.
    /// If auto-refresh is set to `true`, then this object will listen for changes from the database.
    /// - Parameters:
    ///   - id: the user id of the account
    ///   - autoRefresh: whether or not this object should refresh on its own
    init(id: String, autoRefresh: Bool = false) {
        self.id = id
        self.autoRefresh = autoRefresh
        super.init()
        
        self.updateAutoRefresh()
    }
    
    // MARK: Auto Refresh
    
    /// Whether or not this object should auto refresh.
    var autoRefresh: Bool {
        didSet {
            self.updateAutoRefresh()
        }
    }
    
    /// Update class to start/continue/stop auto refreshing, based on the autoRefresh property.
    private func updateAutoRefresh() {
        // TODO
    }
}
