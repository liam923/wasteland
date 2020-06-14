//
//  DatabaseSchema.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import MapKit
import CodableFirebase
import Firebase
import FirebaseFirestoreSwift

// MARK: DTOs

/// A document holding user information that is visible to the user's friends.
struct FUserDTO: Codable {
    /// The last reported location of the user, or nil if there is no recently reported location.
    public var location: Field<GeoPoint?>
}

/// A document representing a drinking session.
struct FDrinkingSessionDTO: Codable {
    /// The time at which this drinking session was opened.
    public var openTime: Field<Timestamp>
    /// The time at which this drinking session closed or will close.
    public var closeTime: Field<Timestamp>
    /// A map of ids of users to drinks had by that user in this drinking session.
    public var drinks: Field<[String: [FDrinkDTO]]>
    /// The ids of users who are currently in this drinking session.
    public var currentMembers: Field<[String]>
    /// The ids of users who were in this drinking session at any time.
    public var historicMembers: Field<[String]>
    /// Invitations for people to join this drinking session that have been sent.
    public var invites: Field<[FInviteDTO]>
}

/// A document representing a drink
struct FDrinkDTO: Codable {
    /// The time at which the drink was had, if known.
    public var time: Field<Date?>
    /// The location at which the drink was had, if known.
    public var location: Field<GeoPoint?>
    /// The type of drink had, if known.
    public var type: Field<FDrinkTypeDTO?>
}

/// An invite sent from one user to another.
struct FInviteDTO: Codable {
    /// The id of the user who sent this invite.
    public var from: Field<String>
    /// The id of the user who received this invite.
    public var to: Field<String>
}

/// An enumeration of different types of drinks.
enum FDrinkTypeDTO: String, Codable {
    case beer
    case wine
    case shot
    
    var drinkType: DrinkType {
        switch self {
        case .beer:
            return .beer
        case .wine:
            return .wine
        case .shot:
            return .shot
        }
    }
    
    static func from(drinkType: DrinkType) -> FDrinkTypeDTO {
        switch drinkType {
        case .beer:
            return .beer
        case .wine:
            return .wine
        case .shot:
            return .shot
        }
    }
}

/// A document storing information on a user's friends.
struct FFriendshipsDTO: Codable {
    /// The ids of the user's friends.
    var friendships: Field<[String]>
}

/// A document storing a user's settings
struct FUserSettingsDTO: Decodable {
    /// A list of groups of people who can report the user as blacked out.
    var allowBlackoutReportsFrom: Field<[FGroupDTO]>
    /// A list of user ids of people who are blacklisted from reporting the user as blacked out.
    var blackoutReportsBlacklist: Field<[String]>
    /// A list of groups of people whose blackouts trigger a notification for the user.
    var blackoutNotificationsFrom: Field<[FGroupDTO]>
    /// A list of groups of people whose drinks trigger a notification for the user.
    var drinkNotificationsFrom: Field<[FGroupDTO]>
}

/// An object that represents a group of people.
struct FGroupDTO: Codable, Hashable {
    var group: UserSettings.Group
    
    enum CodingKeys: String, CodingKey {
        case groupType
        case radius
        case friendsOnly
    }
    
    enum GroupType: String, Codable {
        case friends
        case drinkingSession
        case bestFriends
    }
    
    init(group: UserSettings.Group) {
        self.group = group
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let group = try values.decode(GroupType.self, forKey: .groupType)
        
        switch group {
        case .friends:
            let radius = try values.decode(Double.self, forKey: .radius)
            self.group = .friends(inRadius: radius)
        case .drinkingSession:
            let friendsOnly = try values.decode(Bool.self, forKey: .friendsOnly)
            self.group = .drinkingSessionMembers(friendsOnly: friendsOnly)
        case .bestFriends:
            self.group = .bestFriends
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self.group {
        case let .friends(inRadius: radius):
            try container.encode(GroupType.friends, forKey: .groupType)
            try container.encode(radius, forKey: .radius)
        case let .drinkingSessionMembers(friendsOnly: friendsOnly):
            try container.encode(GroupType.drinkingSession, forKey: .groupType)
            try container.encode(friendsOnly, forKey: .friendsOnly)
        case .bestFriends:
            try container.encode(GroupType.bestFriends, forKey: .groupType)
        }
    }
}

/// A structure that represents a codable field that is optional whether or not it is encoded.
struct Field<FieldType: Codable>: Codable {
    /// The field in question, as an optional. If `nil`, it will not be coded.
    /// If not `nil`, it will be encoded, even if there is the underlying object is an optional that is `nil`.
    var optionalValue: FieldType?
    
    /// The value of the field. If the field has not been set but this value is retrieved, an error will occur.
    var value: FieldType {
        get { return self.optionalValue! }
        set { self.optionalValue = newValue }
    }
    
    /// Initialize with the field not yet set.
    init() {
        self.optionalValue = nil
    }
    
    /// Initialize with the field set to the given value.
    /// - Parameter value: the initial value of the field
    init(_ value: FieldType) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(try container.decode(FieldType.self))
    }

    func encode(to encoder: Encoder) throws {
        if let value = self.optionalValue {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
}

extension Field: Equatable, Hashable where FieldType: Hashable {
    static func == (lhs: Field<FieldType>, rhs: Field<FieldType>) -> Bool {
        return lhs.optionalValue == rhs.optionalValue
    }
}

// MARK: CodableFirebase

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

// MARK: Convenience functions

extension CLLocationCoordinate2D {
    var geopoint: GeoPoint {
        return GeoPoint(coordinate: self)
    }

    init(point: GeoPoint) {
        self.init(latitude: point.latitude, longitude: point.longitude)
    }

    init?(point: GeoPoint?) {
        if let point = point {
            self.init(point: point)
        } else {
            return nil
        }
    }
}

extension GeoPoint {
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(point: self)
    }

    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    convenience init?(coordinate: CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            self.init(coordinate: coordinate)
        } else {
            return nil
        }
    }
}

extension Date {
    var timestamp: Timestamp {
        return Timestamp(date: self)
    }
}
