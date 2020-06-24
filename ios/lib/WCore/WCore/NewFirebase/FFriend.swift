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
    public internal(set) var deleted: Bool { // should only be set by encapsulating classes
        get {
            return superAccount.deleted
        }
        set {
            superAccount.deleted = newValue
        }
    }
    
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
        self.autoRefresh = autoRefresh
        super.init()
        self.receive(from: superAccount)
        
        self.updateAutoRefresh()
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
    
    // MARK: Auto Refresh
    
    private var document: FDocument<FUserDTO>?
    
    /// Whether or not this object should auto refresh.
    var autoRefresh: Bool {
        didSet {
            self.updateAutoRefresh()
        }
    }
    
    /// Update class to start/continue/stop auto refreshing, based on the autoRefresh property.
    private func updateAutoRefresh() {
        if self.autoRefresh {
            if self.document == nil {
                let documentReference = FApp.core.db.collection(FUserDTO.collectionId).document(self.id)
                self.document = FDocument(document: documentReference,
                                          className: "FFriend",
                                          listener: { [weak self] (model) in self?.set(fromModel: model) })
            }
        } else {
            self.document = nil
        }
    }
}
