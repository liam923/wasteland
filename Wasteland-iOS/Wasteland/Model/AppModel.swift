//
//  AppModel.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import UIKit

/// Manages the state of the app
class AppModel: ObservableObject {
    /// The universal app model
    static let shared = AppModel()
    private init() {}
    
    /// The user currently signed in
    @Published private(set) var user: AppUser?
    
    /// Present a login page and attempt to login a user.
    /// - Parameter handler: the view controller presenting the login screen
    /// - Parameter completion: completion handler
    func login(handler: UIViewController, completion: (Error?) -> Void) {
        
    }
    
    func findUser(searchQuery: String, completion: (Account?, Error?) -> Void) {
        
    }
}
