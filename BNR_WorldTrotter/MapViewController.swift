//
//  MapViewController.swift
//  BNR_WorldTrotter
//
//  Created by Yohannes Wijaya on 2/10/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    var mapView: MKMapView!
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its hierarchy of views")
    }
    
    override func loadView() {
        super.loadView()
        
        self.mapView = MKMapView()
        self.view = self.mapView
    }
}