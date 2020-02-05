//
// Created by Liam Stevenson on 2/4/20.
// Copyright (c) 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// A person/account on the app.
protocol Account {
    /// The unique, unchanging identifier of the person.
    var id: String { get }
    /// The display name of the user.
    var displayName: String { get }
    /// The url to the user's profile photo.
    var photoURL: URL? { get }
}
