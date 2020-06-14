//
//  App.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// Manages the state of the app.
public protocol App: ObservableObject {
    associatedtype GAppUser: AppUser
    associatedtype GAccount: Account
    
    /// The singleton instance of the app.
    static var core: Self { get }
    
    /// Configure the app. This should be called on startup.
    /// - Parameter test: whether or not this is a test instance
    func configure(test: Bool)

    /// The user currently signed in.
    var user: GAppUser? { get }

    /// Searches for a user based on the given query.
    /// - Parameters:
    ///   - searchQuery: the query to search by
    ///   - completion: a callback for when the search completes or fails
    ///   - users: the users found in the search; nil if the search fails
    ///   - error: nil if the search succeeds.
    ///   Expected errors: `NetworkingError`
    func findUser(searchQuery: String, completion: (_ users: [GAccount]?, _ error: WError?) -> Void)
    
    /// Fetches the user with the given id.
    /// The users returned are redundant - there is always at most one instance of an Account/Friend/AppUser.
    /// - Parameters:
    ///   - withId: the id of the user to fetch
    ///   - completion: a callback for when the fetch succeeds or fails
    ///   - user: the fetched user; nil if the fetch fails
    ///   - error: nil if the user is fetched successfully.
    ///   Expected errors: `NetworkingError`, `NonExistentError` (the user does not exist)
    func fetchUser(withId: String, completion: (_ user: GAccount?, _ error: WError?) -> Void)
}

// MARK: Default Implementations

extension App {
    /// Configure the app. This should be called on startup.
    /// - Parameter test: whether or not this is a test instance
    func configure(test: Bool = false) {
        return configure(test: test)
    }
}
