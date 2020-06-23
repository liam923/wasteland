//
//  FBlackout.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// An implementation of Blackout using firebase.
public class FBlackout: FObservableObject, Blackout {
    public let id: String
    public let startTime: Date = Date()
    public let endTime: Date = Date()
    public let reports: [Report<FAccount>] = []
    public let dissents: [Report<FAccount>] = []
    public let blackoutUser: FAccount = FAccount(id: "")
    public internal(set) var deleted: Bool = false
    
    /// Initialize a new FBlackout object corresponding to the given id.
    /// If auto-refresh is set to `true`, then this object will listen for changes from the database.
    /// - Parameters:
    ///   - id: the user id of the blackout
    ///   - autoRefresh: whether or not this object should refresh on its own
    init(id: String, autoRefresh: Bool = false) {
        self.id = id
        self.autoRefresh = autoRefresh
        super.init()
        
        self.updateAutoRefresh()
    }
    
    /// Update the fields of this class based on the given DTO.
    /// - Parameter model: the DTO to update the class based on;
    /// `nil` is interpreted as the object having been deleted
    func set(fromModel model: FBlackoutDTO?) {
        
    }
    
    public func report(confirm: Bool, completion: (WError?) -> Void) { }
    
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
