//
//  Blackout.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An object representing a time a user is blacked out.
public protocol Blackout: ObservableObject, HashedIdentifiable where ID == String {
    associatedtype GAccount: Account
    
    /// The time of the first blackout report.
    var startTime: Date { get }
    /// The time at which the blackout will end.
    var endTime: Date { get }
    /// A list of blackout reports.
    var reports: [Report<GAccount>] { get }
    /// A list of dissenting blackout reports.
    var dissents: [Report<GAccount>] { get }
    /// The user reported as blacked out.
    var blackoutUser: GAccount { get }
}

public struct Report<GAccount: Account>: HashedIdentifiable {
    /// A unique identifier for this report.
    public var id: String
    /// The person who made the report.
    public var reporter: GAccount
    /// When the report was made.
    public var time: Date
    /// Where the report was made.
    public var location: CLLocationCoordinate2D
}
