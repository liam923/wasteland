//
//  AppModel.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import os
import Combine
import FirebaseFirestore

/// Manages the state of the app
public class AppModel: ObservableObject {
    /// The universal app model
    public static let model = AppModel()
    
    let db = Firestore.firestore()
    
    private init() { }
    
    private var userCancellable: AnyCancellable?
    /// The user currently signed in
    public fileprivate(set) var user: AppUser? {
        willSet {
            self.userCancellable?.cancel()
            self.userCancellable = newValue?.objectWillChange.sink { self.objectWillChange.send() }
        }
    }
    
    public func findUser(searchQuery: String, completion: (Account?, Error?) -> Void) {
        
    }
    
    // MARK: Sign In
    
    public func updateCurrentUser() {
        if let user = Auth.auth().currentUser {
            self.user = AppUser(user: user)
            os_log("Signed in user: %s", log: Log.firebase, user.uid)
        } else {
            self.user = nil
            os_log("Set logged in user to nil", log: Log.firebase)
        }
    }
    
}
