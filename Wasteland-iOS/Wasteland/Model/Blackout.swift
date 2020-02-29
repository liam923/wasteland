//
//  Blackout.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An object representing a time a user is blacked out.
class Blackout: Identifiable {
    /// A unique identifier for this object.
    @Published var id: String
    /// The time of the first blackout report.
    @Published private(set) var startTime: Date
    /// The time at which the blackout will end.
    @Published private(set) var endTime: Date
    /// A list of the users who reported the blackout, when they reported it, and where they were when they reported it.
    @Published private(set) var reports: [(reporter: Account, time: Date, location: CLLocationCoordinate2D)]
    /// A list of the users who dissented to the blackout report, when they dissented, and where they were when they dissented.
    @Published private(set) var dissents: [(reporter: Account, time: Date)]
    /// The user reported as blacked out.
    @Published private(set) var blackoutUser: Account
    
    /// package private
    init(id:String,
         startTime: Date,
         endTime: Date,
         reports: [(reporter: Account, time: Date, location: CLLocationCoordinate2D)],
         dissents: [(reporter: Account, time: Date)],
         blackoutUser: Account) {
        
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.reports = reports
        self.dissents = dissents
        self.blackoutUser = blackoutUser
    }
}
