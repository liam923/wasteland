//
//  Account.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// A user of the app.
public protocol Account: ObservableObject, HashedIdentifiable where ID == String {
    /// The display name of the user.
    var displayName: String? { get }
    /// The url to the user's profile photo.
    var photoURL: URL? { get }
    /// Whether or not this user has been deleted.
    var deleted: Bool { get }
}
