//
//  FIRAppUser.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRAppUser: FIRRefreshable, AppUser {
    static private(set) var current: FIRAppUser?
    
    static func login(handler: UIViewController, completion: (Error?) -> Void) {
        
    }
    
    private(set) var id: String
    var displayName: String
    var photoURL: URL?
    var currentDrinkingSession: FIRMutableDrinkingSession?
    var currentBlackout: FIRUserBlackout?
    var location: CLLocationCoordinate2D?
    private(set) var locationAsOf: Date?
    private(set) var friends: [FIRFriend]
    private(set) var sentFriendRequests: [FIRAccount]
    private(set) var receivedFriendRequests: [FIRAccount]
    
    init(id: String,
         displayName: String,
         photoURL: URL? = nil,
         location: CLLocationCoordinate2D? = nil,
         friends: [FIRFriend],
         sentFriendRequests: [FIRAccount],
         receivedFriendRequests: [FIRAccount],
         currentDrinkingSession: FIRMutableDrinkingSession? = nil,
         currentBlackout: FIRUserBlackout? = nil) {
        
        self.id = id
        self.displayName = displayName
        self.photoURL = photoURL
        self.location = location
        self.currentDrinkingSession = currentDrinkingSession
        self.currentBlackout = currentBlackout
        self.friends = friends
        self.sentFriendRequests = sentFriendRequests
        self.receivedFriendRequests = receivedFriendRequests
    }
    
    func logout(completion: (Error?) -> Void) {
        
    }
    
    func sendFriendRequest(_ user: FIRAccount, completion: ((Error?) -> Void)?) {
        
    }
    
    func replyToFriendRequest(_ user: FIRAccount, accepted: Bool, completion: ((Error?) -> Void)?) {
        
    }
    
    func reportBlackout(completion: (FIRUserBlackout?, Error?) -> Void) {
        
    }
    
    func fetchHistoricDrinkingSessions(from: Date, to: Date, completion: ([FIRMutableDrinkingSession], Error) -> Void) {
        
    }
    
    func record(location: CLLocationCoordinate2D, completion: ((Error?) -> Void)?) {
        
    }
}
