//
//  Location.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/14.
//

import Foundation
import MapKit

struct Location: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    static var exampleIns = Location(id: UUID(), name: "Ulsan Univ", description: "University in ulsan", latitude: 35.5437411, longitude: 129.2562843)
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    // This makes sure Equatble when it don't conforms to Equtable pr
    // this is more efficcient way
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
