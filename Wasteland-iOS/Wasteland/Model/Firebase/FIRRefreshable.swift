//
//  FIRRefreshable.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

class FIRRefreshable: Refreshable {
    var active: Bool = false {
        didSet {
            if active {
                lastActive = nil
                didSetActive()
            } else {
                lastActive = Date()
                didSetInactive()
            }
        }
    }
    var lastActive: Date?
    
    func didSetActive() {}
    func didSetInactive() {}
}
