//
//  AppUser.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit
import FirebaseAuth
import FirebaseFirestore
import Combine

/// The account of the current user.
public class AppUser: Friend {
    private struct FriendshipsModel: Codable {
        let friends: [String]
        let sentFriendRequests: [String]
        let receivedFriendRequests: [String]
    }
    private var friendshipsDocument: Document<FriendshipsModel>?
    private var currentDrinkingSessionQuery: DocumentQuery<DrinkingSession.Model>?
    private var currentBlackoutQuery: DocumentQuery<Blackout.Model>?

    private let clusterSizeLimit = 10
    private var currentQueries = [(friends: [String],
                                   blackoutQuery: DocumentQuery<Blackout.Model>,
                                   drinkingSessionQuery: DocumentQuery<DrinkingSession.Model>)]()
    public private(set) var friends: [Friend] {
        willSet {
            for cancellable in friendsCancellables {
                cancellable?.cancel()
            }
            friendsCancellables = newValue.map {
                $0.objectWillChange.sink {
                    self.objectWillChange.send()
                }
            }
            self.objectWillChange.send()
        }
        didSet {
            let oldFriends = Set(oldValue.map { $0.id })
            let newFriends = Set(self.friends.map { $0.id })
            var toAdd = newFriends.subtracting(oldFriends)
            let removed = oldFriends.subtracting(newFriends)

            for (friends, _, _) in self.currentQueries {
                let keptFriends = friends.filter(removed.contains)
                if keptFriends.count < friends.count {
                    toAdd = toAdd.union(keptFriends)
                }
            }

            var clusters = [[String]]()
            for new in toAdd {
                if let lastCluster = clusters.last, lastCluster.count < clusterSizeLimit {
                    clusters[clusters.count - 1] = lastCluster + [new]
                } else {
                    clusters.append([new])
                }
            }

            if let lastCluster = clusters.last, let lastFriends = currentQueries.last?.friends,
                lastFriends.count + lastCluster.count <= clusterSizeLimit {
                clusters[clusters.count - 1] += currentQueries.last?.friends ?? []
            }

            for cluster in clusters {
                self.currentQueries.append((friends: cluster,
                                            blackoutQuery: self.makeBlackoutQuery(forFriends: cluster),
                                            drinkingSessionQuery: self.makeDrinkingSessionQuery(forFriends: cluster)))
            }
        }
    }
    public private(set) var sentFriendRequests: [Account] {
        willSet {
            for cancellable in sentFriendRequestsCancellables {
                cancellable?.cancel()
            }
            sentFriendRequestsCancellables = newValue.map {
                $0.objectWillChange.sink {
                    self.objectWillChange.send()
                }
            }
            self.objectWillChange.send()
        }

    }
    public private(set) var receivedFriendRequests: [Account] {
        willSet {
            for cancellable in receivedFriendRequestsCancellables {
                cancellable?.cancel()
            }
            receivedFriendRequestsCancellables = newValue.map {
                $0.objectWillChange.sink {
                    self.objectWillChange.send()
                }
            }
            self.objectWillChange.send()
        }
    }

    private var friendsCancellables: [AnyCancellable?] = []
    private var sentFriendRequestsCancellables: [AnyCancellable?] = []
    private var receivedFriendRequestsCancellables: [AnyCancellable?] = []

    private var mutatedDisplayName = false
    private var mutatedPhotoURL = false
    private var mutatedLocation = false
    private var user: User

    init(user: User) {
        self.user = user
        self.friends = []
        self.sentFriendRequests = []
        self.receivedFriendRequests = []

        super.init(id: user.uid, displayName: user.displayName, photoURL: user.photoURL)

        self.friendshipsDocument = Document(document: self.document.documentReference.collection("private")
            .document("friendships"),
                                            className: "FriendshipsReference",
                                            listener: self.set)

        self.currentDrinkingSessionQuery = self.makeDrinkingSessionQuery(forFriends: [self.id])
        self.currentBlackoutQuery = self.makeBlackoutQuery(forFriends: [self.id])
    }

    /// Send a friend request to the given user.
    /// - Parameters:
    ///   - user: the user to send the friend request to
    ///   - completion: completion handler
    public func sendFriendRequest(_ user: Account, completion: ((Error?) -> Void)?) {

    }

    /// Reply to a friend request from a given user.
    /// - Parameters:
    ///   - user: the user whose friend request is being replied to
    ///   - accepted: true if the request is accepted, false if denied
    ///   - completion: completion handler
    public func replyToFriendRequest(_ user: Account, accepted: Bool, completion: ((Error?) -> Void)?) {

    }

    /// Record the user's location.
    /// - Parameters:
    ///   - location: the current location of the user
    ///   - completion: completion handler
    public func record(location: CLLocationCoordinate2D, completion: ((Error?) -> Void)?) {

    }

    /// Constructs the given drinking session and adds it to this user.
    /// - Parameter drinkingSession: the drinking session to construct
    /// - Returns: the constructed drinking session
    public func add(drinkingSession: DrinkingSession.Builder) -> DrinkingSession {
        return drinkingSession.build()
    }

    public override func didSetDisplayName() {
        self.status = .untied
        mutatedDisplayName = true
    }

    public override func didSetPhotoURL() {
        self.status = .untied
        mutatedPhotoURL = true
    }

    public override func didSetLocation() {
        self.status = .untied
        mutatedLocation = true
        if let location = self.location {
            self.currentDrinkingSession?.closeLocation = location
        }
    }

    public func sendChanges(completion: ((Error?) -> Void)?) {
        func updateProfile(completion: ((Error?) -> Void)?) {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = self.displayName
            changeRequest.photoURL = self.photoURL
            changeRequest.commitChanges(completion: completion)
        }
        func updateLocation(completion: ((Error?) -> Void)?) {
            self.document.upload(data: Friend.Model(location: self.location?.geopoint,
                                                    locationAsOf: self.locationAsOf?.timestamp),
                                 completion: completion)
        }
        if mutatedDisplayName || mutatedPhotoURL {
            if mutatedLocation {
                updateProfile { (error) in
                    if error != nil {
                        completion?(error)
                    } else {
                        self.mutatedDisplayName = false
                        self.mutatedPhotoURL = false
                        updateLocation { (error) in
                            if error == nil {
                                self.mutatedLocation = false
                                self.status = .tied
                            }
                            completion?(error)
                        }
                    }
                }
            } else {
                updateProfile { (error) in
                    if error == nil {
                        self.mutatedDisplayName = false
                        self.mutatedPhotoURL = false
                        self.status = .tied
                    }
                    completion?(error)
                }
            }
        } else if mutatedLocation {
            updateLocation { (error) in
                if error == nil {
                    self.mutatedLocation = false
                    self.status = .tied
                }
                completion?(error)
            }
        } else {
            self.status = .tied
            completion?(nil)
        }
    }

    private func makeBlackoutQuery(forFriends friends: [String]) -> DocumentQuery<Blackout.Model> {
        let query = AppModel.model.db.collectionGroup("blackouts")
            .whereField("blackoutUserID", in: friends)
            .whereField("startTime", isLessThanOrEqualTo: Timestamp())
        print(friends)

        return DocumentQuery(query: query, className: "Blackout") { results in
            let data = results.filter { result in
                result.model.startTime.dateValue() <= Date() && Date() <= result.model.endTime.dateValue()
            }
            for (blackout, id) in data {
                // add blackout to appropriate user
                if let friend = Account.make(id: blackout.blackoutUserID) as? Friend {
                    if let currentBlackout = friend.currentBlackout, currentBlackout.id == id {
                        currentBlackout.set(fromModel: blackout)
                    } else {
                        friend.currentBlackout = Blackout(id: id, fromModel: blackout, status: .tied)
                    }
                }
            }

            // remove old blackouts
            let ids = Set(data.map { $0.id })
            for friend in self.friends {
                if let blackout = friend.currentBlackout, blackout.status == .tied, !ids.contains(blackout.id) {
                    friend.currentBlackout = nil
                }
            }
        }
    }

    private func makeDrinkingSessionQuery(forFriends friends: [String]) -> DocumentQuery<DrinkingSession.Model> {
        let query = AppModel.model.db.collectionGroup("sessions")
            .whereField("drinkerID", in: friends)
            .whereField("openTime", isLessThanOrEqualTo: Timestamp())

        return DocumentQuery(query: query, className: "DrinkingSession") { results in
            let data = results.filter { result in
                result.model.openTime.dateValue() <= Date() && Date() <= result.model.closeTime.dateValue()
            }
            for (session, id) in data {
                // add blackout to appropriate user
                if let friend = Account.make(id: session.drinkerID) as? Friend {
                    if let currentDrinkingSession = friend.currentDrinkingSession, currentDrinkingSession.id == id {
                        currentDrinkingSession.set(fromModel: session)
                    } else {
                        friend.currentDrinkingSession = DrinkingSession(id: id, fromModel: session, status: .tied)
                    }
                }
            }

            // remove old blackouts
            let ids = Set(data.map { $0.id })
            for friend in self.friends {
                if let session = friend.currentDrinkingSession, session.status == .tied, !ids.contains(session.id) {
                    friend.currentDrinkingSession = nil
                }
            }
        }
    }

    private func set(fromModel model: FriendshipsModel) {
        self.friends = model.friends.map { Account.makeAsFriend(id: $0) }
        self.sentFriendRequests = model.sentFriendRequests.map { Account.make(id: $0) }
        self.receivedFriendRequests = model.receivedFriendRequests.map { Account.make(id: $0) }
    }
}
