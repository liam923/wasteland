//
//  UserSettings.swift
//  WCore
//
//  Created by Liam Stevenson on 5/4/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// An object that manages user settings.
public struct UserSettings {
    /// The display name of the user.
    public var displayName: String?
    /// The url to the user's profile photo.
    public var photoURL: URL?
    /// The groups of people who are allowed to report the user as blacked out.
    /// Note: Regardless, any friend or current member's of the user's drinking session can see the blackout.
    public var allowBlackoutReportsFrom: Set<Group>
    /// The set of users who explicitly cannot report the user as blacked out, regardless of `allowBlackoutReportsFrom`.
    public var blackoutReportsBlacklist: Set<String>
    /// The groups of people for which the user should receive "blackout notifications" of.
    /// A "blackout notification" is a notification relating to a user being blacked out.
    public var blackoutNotificationsFrom: Set<Group>
    /// The groups of people for which the user should receive "drink notifications" of.
    /// A "drink notification" is a notification regarding the consumption of a drink or opening of a drinking session.
    public var drinkNotificationsFrom: Set<Group>
    
    /// An enumeration representing different groups of people based on their relation to the user.
    public enum Group: Hashable {
        /// All friends within `inRadius` (in kilometers) of the user based on the most recent location of each.
        /// If one or both does not have a current location, they are not considered within the radius.
        /// If `inRadius` is `nil`, all friends are considered to be in the group.
        case friends(inRadius: Double)
        /// Current members of the user's current drinking session, if they are in one.
        /// If `friendsOnly` is true, only those members who are friends of the user.
        case drinkingSessionMembers(friendsOnly: Bool)
        /// Users who are a best friend of the user.
        case bestFriends
    }
}
