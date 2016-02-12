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
    
    override func loadView() {
        super.loadView()
        
        self.mapView = MKMapView()
        self.view = self.mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControl)
        
//        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(self.view.topAnchor)
//        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor)
//        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor, constant: 8.0)
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.trailingAnchor)
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        segmentedControl.addTarget(self, action: "changeMapType:", forControlEvents: .ValueChanged)
    }
    
    // MARK: - Helper Methods
    
    func changeMapType(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 1: self.mapView.mapType = MKMapType.Hybrid
        case 2: self.mapView.mapType = .Satellite
        default: self.mapView.mapType = .Standard
        }
    }
}