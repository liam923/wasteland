//
//  Log.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import os

public class Log {
    private static let subsystem = "com.william-stevenson.Wasteland.dev"

    public enum Category: String {
        case firebase = "Firebase"
    }

    private static let firebase = OSLog(subsystem: Log.subsystem, category: "firebase")

    private init() {}

    static func debug(_ message: String, category: Category) {
        debug(message, category: category.rawValue)
    }
    
    static func debug(_ message: String, category: String) {
        log(message: message, category: category, type: .debug)
    }
    
    static func info(_ message: String, category: Category) {
        info(message, category: category.rawValue)
    }
    
    static func info(_ message: String, category: String) {
        log(message: message, category: category, type: .info)
    }
    
    static func error(_ message: String, category: Category) {
        error(message, category: category.rawValue)
    }
    
    static func error(_ message: String, category: String) {
        log(message: message, category: category, type: .error)
    }
    
    static func fault(_ message: String, category: Category) {
        fault(message, category: category.rawValue)
    }
    
    static func fault(_ message: String, category: String) {
        log(message: message, category: category, type: .fault)
    }
    
    private static func log(message: String, category: String, type: OSLogType) {
        os_log("%s{public}s", log: OSLog(subsystem: subsystem, category: category), type: type, message)
    }
}
