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
    public private(set) var deleted: Bool = false
    
    /// Initialize a new FDrinkingSession object corresponding to the given id.
    /// If auto-refresh is set to `true`, then this object will listen for changes from the database.
    /// - Parameters:
    ///   - id: the user id of the drinking session
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
    func set(fromModel model: FDrinkingSessionDTO?) {
        
    }
    
    public func addDrink(type: DrinkType?, time: Date?, location: CLLocationCoordinate2D?) { }
    
    public func removeDrink(withID id: String) { }
    
    public func sendInvite(toUserWithId id: String, completion: (WError?) -> Void) { }
    
    public func revokeInvite(toUserWithId id: String, completion: (WError?) -> Void) { }
    
    public func replyToInvite(accept: Bool, completion: (WError?) -> Void) { }
    
    public func leave(purgeHistory: Bool, completion: (WError?) -> Void) { }
    
    public func purgeHistory(completion: (WError?) -> Void) { }
    
    // MARK: Auto Refresh
    
    var document: FDocument<FDrinkingSessionDTO>?
    
    /// Whether or not this object should auto refresh.
    var autoRefresh: Bool {
        didSet {
            if self.autoRefresh != oldValue {
                self.updateAutoRefresh()
            }
        }
    }
    
    /// Update class to start/continue/stop auto refreshing, based on the autoRefresh property.
    private func updateAutoRefresh() {
        if self.autoRefresh {
            if self.document == nil {
                let documentReference = FApp.core.db.collection(FDrinkingSessionDTO.collectionId).document(self.id)
                self.document = FDocument(document: documentReference,
                                          className: "FDrinkingSession",
                                          listener: { [weak self] (model) in self?.set(fromModel: model) })
            }
        } else {
            self.document = nil
        }
    }
}
