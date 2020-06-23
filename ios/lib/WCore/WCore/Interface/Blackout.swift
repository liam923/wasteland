//
//  Blackout.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

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
    /// Whether or not this blackout has been deleted.
    var deleted: Bool { get }
    
    /// Report confirmation of or dissention with the given blackout.
    /// This action will fail if their settings restrict you from reporting them as blacked out.
    /// - Parameters:
    ///   -  confirm: whether this report confirms or denies the blackout
    ///   -  completion: a callback for when the report is sent or fails to send
    ///   -  error: nil if the report is successfully sent.
    ///   Expected errors: `NetworkingError`,
    ///   `NonExistentError` (this blackout no longer exists or the user does not have permission to confirm/disagree)
    func report(confirm: Bool, completion: (_ error: WError?) -> Void)
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
