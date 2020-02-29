//
//  FIRUserBlackout.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit

class FIRUserBlackout: FIRBlackout, UserBlackout {
    private(set) var locationHistory: [(location: CLLocationCoordinate2D, time: Date)]
    
    init(startTime: Date,
         endTime: Date,
         reports: [(reporter: FIRAccount, time: Date, location: CLLocationCoordinate2D)],
         dissents: [(reporter: FIRAccount, time: Date)],
         blackoutUser: FIRAccount,
         locationHistory: [(location: CLLocationCoordinate2D, time: Date)]) {
        
        self.locationHistory = locationHistory
        super.init(startTime: startTime, endTime: endTime, reports: reports, dissents: dissents, blackoutUser: blackoutUser)
    }
}
