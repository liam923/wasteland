//
//  FApp.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

/// An implementation of App using firebase.
public final class FApp: FObservableObject, App {
    // MARK: Singleton
    
    public static let core: FApp = FApp()
    private override init() { }
    
    // MARK: Object management
    
    /// A map of user ids to corresponding account objects that should refresh on their own.
    private var weakRegisteredAccounts = FWeakDict<String, FAccount>()
    /// A map of user ids to corresponding friend objects that should refresh on their own.
    private var weakRegisteredFriends = FWeakDict<String, FFriend>()
    /// A map of drinking session ids to drinking session objects that should refresh on their own.
    private var weakRegisteredDrinkingSessions = FWeakDict<String, FDrinkingSession>()
    /// A map of blackout ids to blackout objects that should refresh on their own.
    private var weakRegisteredBlackouts = FWeakDict<String, FBlackout>()
    
    /// A map of user ids to corresponding friend objects whose refreshing in managed.
    private var strongRegisteredFriends = [String: FFriend]()
    /// A map of drinking session ids to drinking session objects whose refreshing in managed.
    private var strongRegisteredDrinkingSessions = [String: FDrinkingSession]()
    /// A map of blackout ids to blackout objects whose refreshing in managed.
    private var strongRegisteredBlackouts = [String: FBlackout]()
    
    /// Get an account object for the user with the given id.
    /// - Parameter id: the id of the user to get
    /// - Returns: an account object associated with the user with the given id that will refresh automatically
    func account(withId id: String) -> FAccount {
        if let account = weakRegisteredAccounts[id] {
            return account
        } else {
            let account = FAccount(id: id, autoRefresh: true)
            weakRegisteredAccounts[id] = account
            return account
        }
    }
    
    /// Get a friend object for the user with the given id who is a friend of the app user.
    /// - Parameter id: the id of the friend to get
    /// - Returns: a friend object associated with the user with the given id that will refresh automatically
    func friend(withId id: String) -> FFriend {
        if let friend = weakRegisteredFriends[id] {
            return friend
        } else if let friend = strongRegisteredFriends[id] {
            return friend
        } else {
            let friend = FFriend(id: id, autoRefresh: true)
            weakRegisteredFriends[id] = friend
            return friend
        }
    }
    
    /// Get a drinking session object for the drinking session with the given id.
    /// - Parameter id: the id of the drinking session to get
    /// - Returns: a drinking session object associated with the drinking session with the given id that will refresh
    /// automatically
    func drinkingSession(withId id: String) -> FDrinkingSession {
        if let drinkingSession = weakRegisteredDrinkingSessions[id] {
            return drinkingSession
        } else if let drinkingSession = strongRegisteredDrinkingSessions[id] {
            return drinkingSession
        } else {
            let drinkingSession = FDrinkingSession(id: id, autoRefresh: true)
            weakRegisteredDrinkingSessions[id] = drinkingSession
            return drinkingSession
        }
    }
    
    /// Get a blackout object for the blackout with the given id.
    /// - Parameter id: the id of the blackout to get
    /// - Returns: a blackout object associated with the blackout with the given id that will refresh automatically
    func blackout(withId id: String) -> FBlackout {
        if let blackout = weakRegisteredBlackouts[id] {
            return blackout
        } else if let blackout = strongRegisteredBlackouts[id] {
            return blackout
        } else {
            let blackout = FBlackout(id: id, autoRefresh: true)
            weakRegisteredBlackouts[id] = blackout
            return blackout
        }
    }
    
    /// Update the FApp with the user's friendlist in order to continue listening to the user's friends and their
    /// drinking sessions.
    /// - Parameter friends: the user ids of the app user's friends
    func setListeners(forFriendlist friends: Set<String>) {
        
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
