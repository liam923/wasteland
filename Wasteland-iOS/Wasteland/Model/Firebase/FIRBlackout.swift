//
//  FIRBlackout.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRBlackout: FIRRefreshable, Blackout {
    private(set) var startTime: Date
    private(set) var endTime: Date
    private(set) var reports: [(reporter: FIRAccount, time: Date, location: CLLocationCoordinate2D)]
    private(set) var dissents: [(reporter: FIRAccount, time: Date)]
    private(set) var blackoutUser: FIRAccount
    
    init(startTime: Date,
         endTime: Date,
         reports: [(reporter: FIRAccount, time: Date, location: CLLocationCoordinate2D)],
         dissents: [(reporter: FIRAccount, time: Date)],
         blackoutUser: FIRAccount) {
        
        self.startTime = startTime
        self.endTime = endTime
        self.reports = reports
        self.dissents = dissents
        self.blackoutUser = blackoutUser
    }
}
