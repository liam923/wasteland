//
//  FApp.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// An implementation of App using firebase.
public final class FApp: App {
    // MARK: Singleton
    
    public static let core: FApp = FApp()
    private init() { }
    
    public func configure(test: Bool) { }
    
    // MARK: User Management

    public var user: FAppUser?

    public func findUser(searchQuery: String, completion: (_ users: [FAccount]?, _ error: WError?) -> Void) { }
    
    public func fetchUser(withId: String, completion: (_ user: FAccount?, _ error: WError?) -> Void) { }
}
