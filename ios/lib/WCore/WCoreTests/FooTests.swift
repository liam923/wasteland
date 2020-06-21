//
//  FooTests.swift
//  WCoreTests
//
//  Created by Liam Stevenson on 6/20/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Combine
import XCTest

class FooTests: XCTestCase {
    func testFoo() {
        let object = Foo()
        
        var count = 0
        let sub = object.objectWillChange.sink {
            count += 1
        }
        
        object.objectWillChange.send()
        sleep(5)
        XCTAssertEqual(count, 1)
        sub.cancel()
    }
}

fileprivate final class Foo: ObservableObject {
    
}
