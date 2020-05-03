//
//  FIRApp.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn
import Combine
import FirebaseFirestore
import FirebaseCore

/// Manages the state of the app
public class FIRApp: ObservableObject {
    private static var configured = false
    /// The universal app model
    public static let core = FIRApp()

    lazy var db = Firestore.firestore()

    private init() { }

    public func configure(test: Bool = false) {
        if !FIRApp.configured {
            FirebaseApp.configure()

            if test {
                let settings = Firestore.firestore().settings
                settings.host = "localhost:8080"
                settings.isPersistenceEnabled = false
                settings.isSSLEnabled = false
                Firestore.firestore().settings = settings
            }

            GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
            GIDSignIn.sharedInstance()?.delegate = SignInDelegate.shared

            FIRApp.core.updateCurrentUser()
        }
        
        FIRApp.configured = true
    }

    private var userCancellable: AnyCancellable?
    /// The user currently signed in
    public fileprivate(set) var user: FIRAppUser? {
        willSet {
            self.userCancellable?.cancel()
            self.userCancellable = newValue?.objectWillChange.sink { self.objectWillChange.send() }
        }
    }

    public func findUser(searchQuery: String, completion: (FIRAccount?, Error?) -> Void) {

    }

    // MARK: Sign In

    func updateCurrentUser() {
        if let user = Auth.auth().currentUser {
            self.user = FIRAppUser(user: user)
            Log.info("Signed in user: \(user.uid)", category: .firebase)
        } else {
            self.user = nil
            Log.debug("Set logged in user to nil", category: .firebase)
        }
    }

    public func signOut() throws {
        try Auth.auth().signOut()
        self.updateCurrentUser()
    }
}
