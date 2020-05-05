//
//  IDedObject.swift
//  WCore
//
//  Created by Liam Stevenson on 5/3/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

/// An extension of the `Indentifiable protocol` where the identifier is also used for equality comparisons and hashes.
public protocol HashedIdentifiable: Identifiable, Hashable { }

public extension HashedIdentifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
