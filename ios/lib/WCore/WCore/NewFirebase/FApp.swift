//
//  FApp.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Firebase
import GoogleSignIn

/// An implementation of App using firebase.
public final class FApp: App {
    // MARK: Singleton
    
    public static let core: FApp = FApp()
    private init() { }
    
    // MARK: Object management
    
    /// A map of user ids to corresponding account objects that should refresh.
    private var registeredAccounts = FWeakDict<String, FAccount>()
    /// A map of user ids to corresponding friend objects that should refresh.
    private var registeredFriends = FWeakDict<String, FFriend>()
    /// A map of drinking session ids to drinking session objects that should refresh.
    private var registeredDrinkingSessions = FWeakDict<String, FDrinkingSession>()
    
    /// Get an account object for the user with the given id.
    /// - Parameter id: the id of the user to get
    /// - Returns: an account object associated with the user with the given id that will refresh automatically
    func account(withId id: String) -> FAccount {
        if let account = registeredAccounts[id] {
            return account
        } else {
            let account = FAccount(id: id)
            registeredAccounts[id] = account
            return account
        }
    }
    
    /// Get a friend object for the user with the given id who is a friend of the app user.
    /// - Parameter id: the id of the friend to get
    /// - Returns: a friend object associated with the user with the given id that will refresh automatically
    func friend(withId id: String) -> FFriend {
        if let friend = registeredFriends[id] {
            return friend
        } else {
            let friend = FFriend(id: id)
            registeredFriends[id] = friend
            return friend
        }
    }
    
    func drinkingSession(withId id: String) -> FDrinkingSession {
        if let drinkingSession = registeredDrinkingSessions[id] {
            return drinkingSession
        } else {
            let drinkingSession = FDrinkingSession(id: id)
            registeredDrinkingSessions[id] = drinkingSession
            return drinkingSession
        }
    }
    
    // MARK: App conformance

    public private(set) var user: FAppUser?
    
    private static var configured = false
    public func configure(test: Bool) {
        if !FApp.configured {
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

            FApp.core.updateCurrentUser()
        }
        
        FApp.configured = true
    }

    public func findUser(searchQuery: String, completion: (_ users: [FAccount]?, _ error: WError?) -> Void) { }
    
    public func fetchUser(withId: String, completion: (_ user: FAccount?, _ error: WError?) -> Void) { }
    
    func updateCurrentUser() {
        if let user = Auth.auth().currentUser {
            self.user = FAppUser(id: user.uid)
            Log.info("Signed in user: \(user.uid)", category: .firebase)
        } else {
            self.user = nil
            Log.debug("Set logged in user to nil", category: .firebase)
        }
    }
}
