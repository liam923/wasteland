//
//  FBlackout.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// An implementation of Blackout using firebase.
public class FBlackout: Blackout {
    public let id: String = ""
    public let startTime: Date = Date()
    public let endTime: Date = Date()
    public let reports: [Report<FAccount>] = []
    public let dissents: [Report<FAccount>] = []
    public let blackoutUser: FAccount = FAccount()
    
    public func report(confirm: Bool, completion: (WError?) -> Void) { }
}
