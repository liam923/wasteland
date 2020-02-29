//
//  Blackout.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/6/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit
import Combine

/// An object representing a time a user is blacked out.
protocol Blackout: ObservableObject, Refreshable {
    associatedtype GAccount: Account
    
    /// The time of the first blackout report.
    var startTime: Date { get }
    /// The time at which the blackout will end.
    var endTime: Date { get }
    /// A list of the users who reported the blackout, when they reported it, and where they were when they reported it.
    var reports: [(reporter: GAccount,  time: Date, location: CLLocationCoordinate2D)] { get }
    /// A list of the users who dissented to the blackout report, when they dissented, and where they were when they dissented.
    var dissents: [(reporter: GAccount, time: Date)] { get }
    /// The user reported as blacked out.
    var blackoutUser: GAccount { get }
}
