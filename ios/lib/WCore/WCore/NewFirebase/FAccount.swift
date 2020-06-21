//
//  FAccount.swift
//  WCore
//
//  Created by Liam Stevenson on 5/5/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// An implementation of Account using firebase.
public class FAccount: FObservableObject, Account {
    public let id: String
    public let displayName: String? = nil
    public let photoURL: URL? = nil
    
    init(id: String) {
        self.id = id
    }
}
