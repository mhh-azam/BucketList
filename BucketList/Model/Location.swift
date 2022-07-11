//
//  Location.swift
//  BucketList
//
//  Created by QBUser on 11/07/22.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable  {
    var id = UUID()
    var name: String
    var description: String
    var longitude: Double
    var latitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    static let example = Location(name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", longitude: 51.501, latitude: -0.141)
}
