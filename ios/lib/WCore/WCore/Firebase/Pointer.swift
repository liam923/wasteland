//
//  Pointer.swift
//  WCore
//
//  Created by Liam Stevenson on 6/11/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

class Pointer<T: AnyObject> {
    weak private(set) var obj: T?

    init(_ obj: T?) {
        self.obj = obj
    }
}
