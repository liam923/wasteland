//
//  FArrayQueryManager.swift
//  WCore
//
//  Created by Liam Stevenson on 6/21/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// Manages queries designed to use arrays that can be longer than the max allowed length within a query (10).
/// `T` is the type of objects in the array.
class FArrayQueryManager<T: Hashable> {
    typealias QueryCreator = (Set<T>) -> [Any]
    
    private let queryCreator: QueryCreator
    private let clusterSizeLimit: Int
    
    private var vals = Set<T>()
    private var outstandingQueries: [(Set<T>, [Any])] = []
    
    /// Initialize an FArrayQueryManager.
    /// - Parameter queryCreator: given a set of up to 10 array items, creates one or more queries and returns
    /// the corresponding ListenerRegistration objects to cancel them
    init(queryCreator: @escaping QueryCreator, clusterSizeLimit: Int = 10) {
        self.queryCreator = queryCreator
        self.clusterSizeLimit = clusterSizeLimit
    }
    
    /// Update queries for a new array value.
    /// - Parameter vals: the new array value, as a set
    func setArray(_ vals: Set<T>) {
        let removed = self.vals.subtracting(vals)
        var added = vals.subtracting(self.vals)
        
        // remove queries with dated clusters
        for i in (0..<self.outstandingQueries.count).reversed() {
            let (cluster, _) = self.outstandingQueries[i]
            let keptVals = cluster.subtracting(removed)
            if keptVals.count < cluster.count {
                added = added.union(keptVals)
                outstandingQueries.remove(at: i)
            }
        }
        
        // determine what new clusters are necessary to add
        var clusters = [Set<T>]()
        for new in added {
            if let lastCluster = clusters.last, lastCluster.count < clusterSizeLimit {
                clusters[clusters.count - 1].insert(new)
            } else {
                clusters.append([new])
            }
        }
        if let lastNewCluster = clusters.last, let lastOldCluster = outstandingQueries.last?.0,
            lastNewCluster.count + lastOldCluster.count <= clusterSizeLimit {
            clusters[clusters.count - 1] = clusters[clusters.count - 1].union(lastOldCluster)
            outstandingQueries.removeLast()
        }
        
        // add new clusters
        for cluster in clusters {
            outstandingQueries.append((cluster, self.queryCreator(cluster)))
        }
        
        self.vals = vals
    }
}
