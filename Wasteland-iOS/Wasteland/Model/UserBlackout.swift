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
protocol UserBlackout: Blackout {
    /// The blacked-out user's location history during the blackout.
    var locationHistory: [(location: CLLocationCoordinate2D, time: Date)] { get }
}
