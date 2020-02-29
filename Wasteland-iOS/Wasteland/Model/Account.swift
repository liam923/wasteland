//
//  Account.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// A person/account on the app.
class Account: Identifiable {
    /// The unique, unchanging identifier of the person.
    @Published private(set) var id: String
    /// The display name of the user.
    @Published var displayName: String
    /// The url to the user's profile photo.
    @Published var photoURL: URL?
    
    /// package private
    init(id: String, displayName: String, photoURL: URL? = nil) {
        self.id = id
        self.displayName = displayName
        self.photoURL = photoURL
    }
}
