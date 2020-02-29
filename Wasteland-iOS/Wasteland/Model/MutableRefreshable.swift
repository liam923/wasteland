//
//  MutableRefreshable.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// An object that can be refreshed and mutaded.
protocol MutableRefreshable: Refreshable {
    /// Send any changes made to the object
    /// - Parameter completion: completion handler
    func sendChanges(completion: ((Error?) -> Void)?)
}
