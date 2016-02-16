//
//  ChosenLocations.swift
//  BNR_WorldTrotter
//
//  Created by Yohannes Wijaya on 2/15/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit
import MapKit

class ChosenLocations: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String = "Favorite Location", coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
