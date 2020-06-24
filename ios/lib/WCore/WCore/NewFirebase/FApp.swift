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
    
    let db = Firestore.firestore()
    
    /// A map of user ids to corresponding account objects for all account objects.
    private var registeredAccounts = FWeakDict<String, FAccount>()
    /// A map of user ids to corresponding friend objects for all friend objects.
    private var registeredFriends = FWeakDict<String, FFriend>()
    /// A map of drinking session ids to drinking session objects for all drinking session objects.
    private var registeredDrinkingSessions = FWeakDict<String, FDrinkingSession>()
    /// A map of blackout ids to blackout objects for all blackout objects.
    private var registeredBlackouts = FWeakDict<String, FBlackout>()
    
    /// Get an account object for the user with the given id.
    /// - Parameter id: the id of the user to get
    /// - Returns: an account object associated with the user with the given id that will refresh automatically
    func account(withId id: String) -> FAccount {
        if let account = registeredAccounts[id] {
            return account
        } else {
            let account = FAccount(id: id, autoRefresh: true)
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
            let friend = FFriend(id: id, autoRefresh: true)
            registeredFriends[id] = friend
            return friend
        }
    }
    
    /// Get a drinking session object for the drinking session with the given id.
    /// - Parameter id: the id of the drinking session to get
    /// - Returns: a drinking session object associated with the drinking session with the given id that will refresh
    /// automatically
    func drinkingSession(withId id: String) -> FDrinkingSession {
        if let drinkingSession = registeredDrinkingSessions[id] {
            return drinkingSession
        } else {
            let drinkingSession = FDrinkingSession(id: id, autoRefresh: true)
            registeredDrinkingSessions[id] = drinkingSession
            return drinkingSession
        }
    }
    
    /// Get a blackout object for the blackout with the given id.
    /// - Parameter id: the id of the blackout to get
    /// - Returns: a blackout object associated with the blackout with the given id that will refresh automatically
    func blackout(withId id: String) -> FBlackout {
        if let blackout = registeredBlackouts[id] {
            return blackout
        } else {
            let blackout = FBlackout(id: id, autoRefresh: true)
            registeredBlackouts[id] = blackout
            return blackout
        }
    }
    
    private var friendQueriesManager: FArrayQueryManager<String>?
    
    // These are maps from object ids to query ids that currently return the object, making the object strongly
    // referenced. If the query ids become empty, then the object should begin auto refreshing (if it still exists).
    private var strongRegisteredFriendsQueries = [String: Set<UUID>]()
    private var strongRegisteredDrinkingSessionsQueries = [String: Set<UUID>]()
    private var strongRegisteredBlackoutsQueries = [String: Set<UUID>]()
    
    // These are maps from query ids to all objects fetched by the query, in order to ensure strong references to those
    // objects and keep them from being garbage collected.
    private var queryRegisteredFriends = [UUID: Set<FFriend>]()
    private var queryRegisteredDrinkingSessions = [UUID: Set<FDrinkingSession>]()
    private var queryRegisteredBlackouts = [UUID: Set<FBlackout>]()
    
    /// Update the FApp with the user's friendlist in order to continue listening to the user's friends and their
    /// drinking sessions.
    /// - Parameter friends: the user ids of the app user's friends
    func setListeners(forFriendlist friends: Set<String>) {
        friendQueriesManager?.setArray(friends)
    }
    
    private func makeFriendsQuery(cluster: Set<String>) -> FQuery<FUserDTO> {
        let query = self.db
            .collection(FUserDTO.collectionId)
            .whereField("id", in: [String](cluster))
        return FQuery<FUserDTO>(query: query, className: "FFriend") { (models, queryId) in
            var friends = Set<FFriend>()
            for (model, id) in models {
                // update or create friend for given model
                let friend = self.registeredFriends[id] ?? FFriend(id: id, autoRefresh: false)
                friend.autoRefresh = false
                friend.set(fromModel: model)
                
                friends.insert(friend)
                
                // update list of queries corresponding to friend object to include this query
                var queryIds = self.strongRegisteredFriendsQueries[id] ?? Set()
                queryIds.insert(queryId)
                self.strongRegisteredFriendsQueries[id] = queryIds
                
                // update list of friends corresponding to this query
                var registeredFriends = self.queryRegisteredFriends[queryId] ?? Set()
                registeredFriends.insert(friend)
                self.queryRegisteredFriends[queryId] = registeredFriends
            }
            
            let removedFriends = (self.queryRegisteredFriends[queryId] ?? Set())
                .subtracting(friends)
                .map { $0.id }
            self.queryRegisteredFriends[queryId] = friends
            for removedFriend in removedFriends {
                self.strongRegisteredFriendsQueries[removedFriend]?.remove(queryId)
                if self.strongRegisteredFriendsQueries[removedFriend]?.count == 0 {
                    self.strongRegisteredFriendsQueries.removeValue(forKey: removedFriend)
                    self.registeredFriends[removedFriend]?.autoRefresh = true
                }
            }
        }
    }
    
    private func makeDrinkingSessionsQuery(cluster: Set<String>) -> FQuery<FDrinkingSessionDTO> {
        let query = self.db
            .collection(FDrinkingSessionDTO.collectionId)
            .whereField("currentMembers", arrayContainsAny: [String](cluster))
        return FQuery<FDrinkingSessionDTO>(query: query, className: "FDrinkingSession") { (models, queryId) in
            var drinkingSessions = Set<FDrinkingSession>()
            for (model, id) in models {
                // update or create drinking session for given model
                let drinkingSession = self.registeredDrinkingSessions[id] ?? FDrinkingSession(id: id,
                                                                                              autoRefresh: false)
                drinkingSession.autoRefresh = false
                drinkingSession.set(fromModel: model)
                
                drinkingSessions.insert(drinkingSession)
                
                // update list of queries corresponding to drinking session object to include this query
                var queryIds = self.strongRegisteredDrinkingSessionsQueries[id] ?? Set()
                queryIds.insert(queryId)
                self.strongRegisteredDrinkingSessionsQueries[id] = queryIds
                
                // update list of drinking sessions corresponding to this query
                var registeredDrinkingSessions = self.queryRegisteredDrinkingSessions[queryId] ?? Set()
                registeredDrinkingSessions.insert(drinkingSession)
                self.queryRegisteredDrinkingSessions[queryId] = registeredDrinkingSessions
            }
            
            let removedDrinkingSessions = (self.queryRegisteredDrinkingSessions[queryId] ?? Set())
                .subtracting(drinkingSessions)
                .map { $0.id }
            self.queryRegisteredDrinkingSessions[queryId] = drinkingSessions
            for removedDrinkingSession in removedDrinkingSessions {
                self.strongRegisteredDrinkingSessionsQueries[removedDrinkingSession]?.remove(queryId)
                if self.strongRegisteredDrinkingSessionsQueries[removedDrinkingSession]?.count == 0 {
                    self.strongRegisteredDrinkingSessionsQueries.removeValue(forKey: removedDrinkingSession)
                    self.registeredDrinkingSessions[removedDrinkingSession]?.autoRefresh = true
                }
            }
        }
    }
    
    private func makeBlackoutsQuery(cluster: Set<String>) -> FQuery<FBlackoutDTO> {
        let query = self.db
            .collection(FBlackoutDTO.collectionId)
            .whereField("blackoutUser", in: [String](cluster))
        return FQuery<FBlackoutDTO>(query: query, className: "FBlackout") { (models, queryId) in
            var blackouts = Set<FBlackout>()
            for (model, id) in models {
                // update or create blackout for given model
                let blackout = self.registeredBlackouts[id] ?? FBlackout(id: id, autoRefresh: false)
                blackout.autoRefresh = false
                blackout.set(fromModel: model)
                
                blackouts.insert(blackout)
                
                // update list of queries corresponding to blackout object to include this query
                var queryIds = self.strongRegisteredBlackoutsQueries[id] ?? Set()
                queryIds.insert(queryId)
                self.strongRegisteredBlackoutsQueries[id] = queryIds
                
                // update list of blackouts corresponding to this query
                var registeredBlackouts = self.queryRegisteredBlackouts[queryId] ?? Set()
                registeredBlackouts.insert(blackout)
                self.queryRegisteredBlackouts[queryId] = registeredBlackouts
            }
            
            let removedBlackouts = (self.queryRegisteredBlackouts[queryId] ?? Set())
                .subtracting(blackouts)
                .map { $0.id }
            self.queryRegisteredBlackouts[queryId] = blackouts
            for removedBlackout in removedBlackouts {
                self.strongRegisteredBlackoutsQueries[removedBlackout]?.remove(queryId)
                if self.strongRegisteredBlackoutsQueries[removedBlackout]?.count == 0 {
                    self.strongRegisteredBlackoutsQueries.removeValue(forKey: removedBlackout)
                    self.registeredBlackouts[removedBlackout]?.autoRefresh = true
                }
            }
        }
    }
    
    private func makeQueriesManager() -> FArrayQueryManager<String> {
        return FArrayQueryManager { cluster in
            return [self.makeFriendsQuery(cluster: cluster),
                    self.makeDrinkingSessionsQuery(cluster: cluster),
                    self.makeBlackoutsQuery(cluster: cluster)]
        }
    }
    
    // MARK: App conformance
    
    public private(set) var user: FAppUser? {
        didSet {
            if user == nil {
                friendQueriesManager = nil
            } else {
                friendQueriesManager = makeQueriesManager()
            }
        }
    }
    
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
