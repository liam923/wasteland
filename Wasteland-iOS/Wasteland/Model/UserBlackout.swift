//
//  UserBlackout.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

/// An object representing a time the logged user is blacked out.
class UserBlackout: Blackout {
    /// The blacked-out user's location history during the blackout.
    @Published private(set) var locationHistory: [(location: CLLocationCoordinate2D, time: Date)]
    
    /// package private
    init(id:String,
         startTime: Date,
         endTime: Date,
         reports: [(reporter: Account, time: Date, location: CLLocationCoordinate2D)],
         dissents: [(reporter: Account, time: Date)],
         blackoutUser: Account,
         locationHistory: [(location: CLLocationCoordinate2D, time: Date)]) {
        
        self.locationHistory = locationHistory
        super.init(id: id, startTime: startTime, endTime: endTime, reports: reports, dissents: dissents, blackoutUser: blackoutUser)
    }
}
