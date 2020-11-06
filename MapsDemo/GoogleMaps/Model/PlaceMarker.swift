//
//  PlaceMarker.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/22/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import UIKit
import GoogleMaps
class PlaceMarker: GMSMarker {
      let place: GooglePlace
      init(place: GooglePlace, availableTypes: [String]) { //designated init with location types
        self.place = place
        super.init()
        position = place.coordinate
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
        var foundType = "restaurant"
        let possibleTypes = availableTypes.count > 0 ?
          availableTypes :
          ["bakery", "bar", "cafe", "grocery", "restaurant"]
        for type in place.types {
          if possibleTypes.contains(type) {
            foundType = type
            break
          }
        }
        icon = UIImage(named: foundType+"_pin")
      }
    }

