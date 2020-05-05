//
//  Status.swift
//  Wasteland
//
//  Created by Liam Stevenson on 3/22/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// A status of a locally object with relation to a remote one.
public enum Status {
    /// The object has been created locally but not yet stored remotely or it has been locally mutated.
    case untied
    /// The object is in sync with a remote object.
    case tied
}
