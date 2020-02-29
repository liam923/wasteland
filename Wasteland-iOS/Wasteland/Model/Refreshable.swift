//
//  Refreshable.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// An object that can be refreshed.
protocol Refreshable {
    /// Controls whether the object is being actively refreshed.
    var active: Bool { get set }
    /// The last time the object was active (`nil` if the object is currently active or was never active).
    var lastActive: Date? { get }
}
