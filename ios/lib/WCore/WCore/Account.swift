//
//  Account.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import FirebaseAuth

/// A person/account on the app.
public class Account: Identifiable, ObservableObject {
    private static var existingAccounts = [Pointer<Account>]()

    /// package private
    static func make(id: String) -> Account {
        if let account = existingAccounts.first(where: { $0.obj?.id == id })?.obj {
            return account
        } else {
            if let user = App.core.user {
                if user.id == id {
                    existingAccounts.append(Pointer(user))
                    return user
                } else if let friend = user.friends.filter({$0.id == id}).first {
                    existingAccounts.append(Pointer(friend))
                    return friend
                }
            }
        }
        let newAccount = Account(id: id)
        existingAccounts.append(Pointer(newAccount))
        return newAccount
    }

    /// package private
    public static func makeAsFriend(id: String) -> Friend {
        if let account = existingAccounts.first(where: { $0.obj?.id == id })?.obj {
            if let friend = account as? Friend {
                return friend
            } else {
                existingAccounts.removeAll { $0.obj === account }
            }
        }

        let newFriend = Friend(id: id)
        existingAccounts.append(Pointer(newFriend))
        return newFriend
    }

    /// The unique, unchanging identifier of the person.
    public private(set) var id: String {
        willSet {
            self.objectWillChange.send()
        }
    }
    /// The display name of the user.
    public var displayName: String? {
        willSet {
            self.objectWillChange.send()
        }
        didSet {
            self.didSetDisplayName()
        }
    }
    /// The url to the user's profile photo.
    public var photoURL: URL? {
        willSet {
            self.objectWillChange.send()
        }
        didSet {
            self.didSetPhotoURL()
        }
    }

    /// create a dummy temp account
    init() {
        self.id = ""
    }

    init(id: String, displayName: String? = nil, photoURL: URL? = nil) {
        self.id = id
        self.displayName = displayName
        self.photoURL = photoURL

        Account.existingAccounts.append(Pointer(self))
    }

    func didSetDisplayName() {

    }

    func didSetPhotoURL() {

    }
}
