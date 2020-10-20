//
//  Place.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import CoreLocation

struct Place: Decodable {
    var id: String
    var type: String
    var name: String
    var population: Int
    var coordinates: Coordinates
}

struct Coordinates: Decodable {
    var latitude: Double
    var longitude: Double
    
    var cordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
