//
//  FObservableObject.swift
//  WCore
//
//  Created by Liam Stevenson on 6/13/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

/// A subclassable `ObservableObject` implementation that allows for nesting.
public class FObservableObject: ObservableObject {
    private var forwardTargets = FWeakDict<UUID, FObservableObject>()
    private let fObservableObjectId = UUID()
    
    /// Register an object that should propogate change events to `self`.
    /// - Parameter object: the object for change events to be propogated from
    final func receive(from object: FObservableObject) {
        object.forwardTargets[self.fObservableObjectId] = self
    }
    
    /// Register an object that should propogate change events to `self`.
    /// - Parameter object: the object for change events to be propogated from
    final func stopReceiving(from object: FObservableObject) {
        object.forwardTargets.removeValue(forKey: self.fObservableObjectId)
    }
    
    /// Call this method to call `self.objectWillChange.send()` and also propogate this call to the
    /// objects registered via `self.forward`.
    final func objectWillChange() {
        self.objectWillChange(visitedForwarders: Set())
    }
    
    private func objectWillChange(visitedForwarders: Set<UUID>) {
        var visitedForwarders = visitedForwarders
        if visitedForwarders.insert(self.fObservableObjectId).inserted {
            self.objectWillChange.send()
            for forwardTarget in forwardTargets.values {
                forwardTarget.objectWillChange(visitedForwarders: visitedForwarders)
            }
        }
    }
}
