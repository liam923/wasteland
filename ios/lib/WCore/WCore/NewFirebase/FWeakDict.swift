//
//  FWeakDict.swift
//  WCore
//
//  Created by Liam Stevenson on 6/13/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// An FWeakDict is a dictionary where all values are weakly referenced.
struct FWeakDict<K: Hashable, V: AnyObject> {
    private var dict: [K: WeakBox<V>] = [:]
    
    subscript(key: K) -> V? {
        get {
            return dict[key]?.unbox
        }
        set {
            dict[key]?.unbox = newValue
        }
    }
}

// Taken from https://www.objc.io/blog/2017/12/28/weak-arrays/
fileprivate final class WeakBox<T: AnyObject> {
    weak var unbox: T?
    init(_ value: T) {
        unbox = value
    }
}
