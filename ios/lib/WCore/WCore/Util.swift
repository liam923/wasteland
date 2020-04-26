//
//  Util.swift
//  WCore
//
//  Created by Liam Stevenson on 4/21/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit
import CodableFirebase

class Pointer<T: AnyObject> {
    weak private(set) var obj: T?
    
    init(_ obj: T?) {
        self.obj = obj
    }
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

extension CLLocationCoordinate2D {
    var geopoint: GeoPoint {
        return GeoPoint(coordinate: self)
    }
    
    init(point: GeoPoint) {
        self.init(latitude: point.latitude, longitude: point.longitude)
    }
    
    init?(point: GeoPoint?) {
        if let point = point {
            self.init(point: point)
        } else {
            return nil
        }
    }
}

extension GeoPoint {
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(point: self)
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    convenience init?(coordinate: CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            self.init(coordinate: coordinate)
        } else {
            return nil
        }
    }
}

extension Date {
    var timestamp: Timestamp {
        return Timestamp(date: self)
    }
}

