//
//  WCoreTests.swift
//  WCoreTests
//
//  Created by Liam Stevenson on 4/21/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import XCTest
import WCore

class WCoreTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        FIRApp.core.configure(test: true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testExample2() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
