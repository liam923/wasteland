//
//  Blackout.swift
//  Wasteland
//
//  Created by Liam Stevenson on 2/29/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import MapKit
import FirebaseFirestore
import CodableFirebase

/// An object representing a time a user is blacked out.
public class Blackout: ObservableObject, Identifiable {
    /// An object representing a report.
    public struct Report: Identifiable {
        /// A unique identifier for this report.
        public let id: String
        /// The person who made the report.
        public let reporter: Account
        /// When the report was made.
        public let time: Date
        /// Where the report was made.
        public let location: CLLocationCoordinate2D

        init(fromModel model: Model) {
            self.id = model.id
            self.reporter = Account.make(id: model.id)
            self.time = model.time.dateValue()
            self.location = model.location.location
        }

        func toModel() -> Model {
            return Model(id: self.id,
                         reporter: self.reporter.id,
                         time: self.time.timestamp,
                         location: GeoPoint(coordinate: self.location))
        }

        struct Model: Codable {
            let id: String
            let reporter: String
            let time: Timestamp
            let location: GeoPoint
        }
    }

    /// A unique identifier for this object.
    public var id: String { willSet { self.objectWillChange.send() } }
    /// The time of the first blackout report.
    public private(set) var startTime: Date { willSet { self.objectWillChange.send() } }
    /// The time at which the blackout will end.
    public private(set) var endTime: Date { willSet { self.objectWillChange.send() } }
    /// A list of the users who reported the blackout, when they reported it, and where they were when they reported it.
    public private(set) var reports: [Report] { willSet { self.objectWillChange.send() } }
    /// A list of the users who dissented to the blackout report, when they dissented,
    /// and where they were when they dissented.
    public private(set) var dissents: [Report] { willSet { self.objectWillChange.send() } }
    /// The user reported as blacked out.
    public private(set) var blackoutUser: Account { willSet { self.objectWillChange.send() } }
    /// The status of this object.
    public internal(set) var status: Status { willSet { self.objectWillChange.send() } }
    /// Whether or not this object has been deleted.
    public private(set) var deleted: Bool { willSet { self.objectWillChange.send() } }

    private let document: Document<Model>?

    struct Model: Codable {
        let startTime: Timestamp
        let endTime: Timestamp
        let reports: [Report.Model]
        let dissents: [Report.Model]
        let blackoutUserID: String
    }

    /// Initialize from a model and do not syncronize with the database.
    init(id: String, fromModel model: Model, status: Status) {
        self.id = id
        self.startTime = model.startTime.dateValue()
        self.endTime = model.endTime.dateValue()
        self.reports = model.reports.map { Report(fromModel: $0) }
        self.dissents = model.dissents.map { Report(fromModel: $0) }
        self.blackoutUser = Account.make(id: model.blackoutUserID)
        self.deleted = false
        self.status = status

        self.document = nil
    }

    /// Initialize with a tie to an existing blackout and syncronize with the database.
    init(reference: DocumentReference) {
        self.id = reference.documentID
        self.startTime = Date()
        self.endTime = Date()
        self.reports = []
        self.dissents = []
        self.blackoutUser = Account()
        self.deleted = false
        self.status = .untied

        self.document = Document(document: reference, className: "Blackout")

        self.document?.add(listener: { model in
            self.set(fromModel: model)
            self.status = .tied
        })
        self.document?.add(deleteCallback: self.deleteCallback)
    }

    func set(fromModel model: Model) {
        self.startTime = model.startTime.dateValue()
        self.endTime = model.endTime.dateValue()
        self.reports = model.reports.map { Report(fromModel: $0) }
        self.dissents = model.dissents.map { Report(fromModel: $0) }
        self.blackoutUser = Account.make(id: model.blackoutUserID)
    }

    private func deleteCallback() {
        self.status = .tied
        self.deleted = true
    }
}
