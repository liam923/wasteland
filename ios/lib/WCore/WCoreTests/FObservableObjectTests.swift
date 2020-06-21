//
//  FObservableObjectTests.swift
//  WCoreTests
//
//  Created by Liam Stevenson on 6/14/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

@testable import WCore
import XCTest

class FObservableObjectTests: XCTestCase {
    func testWeak() {
        var objectA: Nester? = Nester()
        let objectB: Nester? = Nester()
        
        weak var weakObjectA = objectA
        objectA?.nested = objectB
        objectB?.nested = objectA
        
        objectA = nil
        XCTAssertNil(weakObjectA)
    }
    
    func testSinglePropogation() {
        let objectA: Nester = Nester()
        let objectB: Nester = Nester()
        objectA.nested = objectB
        objectB.nested = objectA
        
        var aCount = 0
        let aSub = objectA.objectWillChange.sink {
            aCount += 1
        }
        var bCount = 0
        let bSub = objectB.objectWillChange.sink {
            bCount += 1
        }
        
        objectA.objectWillChange()
        XCTAssertEqual(aCount, 1)
        XCTAssertEqual(bCount, 1)
        aSub.cancel()
        bSub.cancel()
    }
}

fileprivate final class Nester: FObservableObject {
    weak var nested: Nester? {
        didSet {
            if let nested = nested {
                self.receive(from: nested)
            }
        }
    }
}
