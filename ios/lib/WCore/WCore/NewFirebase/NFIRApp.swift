//
//  NFIRApp.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// An implementation of App using firebase.
public final class NFIRApp: App {
    // MARK: Singleton
    
    public static let core: NFIRApp = NFIRApp()
    private init() { }
    
    public func configure(test: Bool) { }
    
    // MARK: User Management

    public var user: NFIRAppUser?

    public func findUser(searchQuery: String, completion: (_ users: [NFIRAccount]?, _ error: WError?) -> Void) { }
    
    public func fetchUser(withId: String, completion: (_ user: NFIRAccount?, _ error: WError?) -> Void) { }
}
