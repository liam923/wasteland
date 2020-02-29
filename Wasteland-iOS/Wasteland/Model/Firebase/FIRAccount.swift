//
//  FIRAccount.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

class FIRAccount: FIRRefreshable, Account {
    private(set) var id: String
    private(set) var displayName: String
    private(set) var photoURL: URL?
    
    init(id: String, displayName: String, photoURL: URL? = nil) {
        self.id = id
        self.displayName = displayName
        self.photoURL = photoURL
    }
}
