//
//  Blackout.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/6/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An object representing a time a user is blacked out.
protocol Blackout {
    /// The time of the first blackout report.
    var startTime: Date { get }
    /// The time at which the blackout will end.
    var endTime: Date { get }
    /// A list of the users who reported the blackout, when they reported it, and where they were when they reported it.
    var reports: [(reporter: Account,  time: Date, location: CLLocationCoordinate2D)] { get }
    /// A list of the users who dissented to the blackout report, when they dissented, and where they were when they dissented.
    var dissents: [(reporter: Account, time: Date)] { get }
    /// The user reported as blacked out.
    var blackoutUser: Account { get }
}
