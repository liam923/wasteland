//
//  MutableRefreshable.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// An object that can be mutaded and refreshed.
protocol MutableRefreshable {
    /// `true` iff the object is continuously updating; this will be paused from when the object is mutated until changes are sent
    var active: Bool { get }
    
    /// Send any changes made to the object and continue refreshing
    /// - Parameter completion: completion handler
    func sendChanges(completion: ((Error?) -> Void)?)
}
