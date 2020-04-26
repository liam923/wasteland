//
//  Log.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import os

class Log {
    private static let subsystem = "com.william-stevenson.Wasteland.dev"
    
    static let firebase = OSLog(subsystem: Log.subsystem, category: "firebase")
    
    private init() {}
}
