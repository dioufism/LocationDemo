//
//  CustomAnnotation.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    init(place: Place) {
        self.coordinate = place.coordinates.cordinates
        self.title = place.name
    }
}
