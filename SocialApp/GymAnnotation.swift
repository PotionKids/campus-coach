//
//  PokeAnnotation.swift
//  PokeFinder
//
//  Created by Mark Price on 7/25/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import Foundation
import MapKit

class GymAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var gymName: String
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, gymName: String, message: String) {
        self.coordinate = coordinate
        self.gymName = gymName
        let display = "\(gymName) is \(message)"
        self.title = display
    }
}

