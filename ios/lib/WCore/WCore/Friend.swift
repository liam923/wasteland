//
//  Friend.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit
import FirebaseFirestore
import os
import Combine

/// A person on the user's friend list.
public class Friend: Account {
    enum Keys: String {
        case location, locationAsOf, currentDrinkingSession, currentBlackout
    }
    
    /// The status of this object.
    public internal(set) var status: Status { willSet { self.objectWillChange.send() } }
    
    /// The person's current location. This can only be set if this is an instance of AppUser.
    public var location: CLLocationCoordinate2D? {
        willSet {
            self.objectWillChange.send()
        }
        didSet {
            self.locationAsOf = Date()
            self.didSetLocation()
        }
    }
    /// The time the person's location was last updated.
    public private(set) var locationAsOf: Date? { willSet { self.objectWillChange.send() } }
    /// The person's current drinking session, if they have one.
    public internal(set) var currentDrinkingSession: DrinkingSession? {
        willSet {
            currentDrinkingSessionCancellable?.cancel()
            currentDrinkingSessionCancellable = newValue?.objectWillChange.sink {
                if self.currentDrinkingSession?.deleted ?? false {
                    self.currentDrinkingSession = nil
                }
                self.objectWillChange.send()
            }
            self.objectWillChange.send()
        }
    }
    /// The person's current blackout, if they have one.
    public internal(set) var currentBlackout: Blackout? {
        willSet {
            currentBlackoutCancellable?.cancel()
            currentBlackoutCancellable = newValue?.objectWillChange.sink {
                if self.currentBlackout?.deleted ?? false {
                    self.currentBlackout = nil
                }
                self.objectWillChange.send()
            }
            self.objectWillChange.send()
        }
    }
    
    private var currentDrinkingSessionCancellable: AnyCancellable? = nil
    private var currentBlackoutCancellable: AnyCancellable? = nil
    
    let document: Document<Model>
    
    struct Model: Codable {
        let location: GeoPoint?
        let locationAsOf: Timestamp?
    }
    
    override init(id: String,
                  displayName: String? = nil,
                  photoURL: URL? = nil) {
        
        self.document = Document(document: AppModel.model.db.collection("users").document(id), className: "Friend")
        self.status = .untied
        
        super.init(id: id, displayName: displayName, photoURL: photoURL)
        
        self.document.add(listener: self.set)
    }
    
    /// Report this user as blacked out.
    /// - Parameter completion: a completion handler that takes the blackout object connected to this report
    public func reportBlackout(completion: (Blackout?, Error?) -> Void) {
        
    }
    
    /// Fetch all drinking sessions belonging to the user between the given times.
    /// - Parameters:
    ///   - from: the beginning of the interval to fetch from
    ///   - to: the ending of the interval to fetch from
    ///   - completion: a completion handler that takes a list of the drinking sessions within the given interval
    public func fetchHistoricDrinkingSessions(from: Date, to: Date, completion: ([DrinkingSession], Error) -> Void) {
        
    }
    
    /// Fetch all blackouts belonging to the user between the given times.
    /// - Parameters:
    ///   - from: the beginning of the interval to fetch from
    ///   - to: the ending of the interval to fetch from
    ///   - completion: a completion handler that takes a list of the blackouts within the given interval
    public func fetchHistoricBlackouts(from: Date, to: Date, completion: ([Blackout], Error) -> Void) {
        
    }
    
    func didSetLocation() {
        
    }
    
    func set(fromModel model: Model) {
        self.location = CLLocationCoordinate2D(point: model.location)
        self.locationAsOf = model.locationAsOf?.dateValue()
        self.status = .tied
    }
}
