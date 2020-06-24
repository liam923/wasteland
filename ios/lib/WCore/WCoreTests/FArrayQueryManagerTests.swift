//
//  FArrayQueryManagerTests.swift
//  WCoreTests
//
//  Created by Liam Stevenson on 6/23/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

@testable import WCore
import XCTest

class FArrayQueryManagerTests: XCTestCase {
    func testSetArray() {
        var callbacks = [Set<Int>]()
        let manager = FArrayQueryManager(queryCreator: { (cluster: Set<Int>) -> [Any] in
            callbacks.append(cluster)
            return []
        }, clusterSizeLimit: 3)
        
        manager.setArray(Set<Int>([0, 1, 2, 3, 4]))
        XCTAssertEqual(2, callbacks.count)
        XCTAssertEqual(3, callbacks.map({ $0.count }).max())
        XCTAssertEqual(callbacks[0].union(callbacks[1]), Set<Int>([0, 1, 2, 3, 4]))
        XCTAssertEqual(callbacks[0].intersection(callbacks[1]).count, 0)
        let smallCluster = callbacks.filter({$0.count < 3}).first!
        var bigCluster = callbacks.filter({$0.count == 3}).first!
        bigCluster.removeFirst()
        bigCluster.insert(5)
        callbacks = []
        
        manager.setArray(smallCluster.union(bigCluster))
        XCTAssertEqual(callbacks, [bigCluster])
    }
}
