//
//  MapViewController.swift
//  BNR_WorldTrotter
//
//  Created by Yohannes Wijaya on 2/10/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Stored Properties
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard CLLocationManager.locationServicesEnabled() else { return }
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.mapView.showsUserLocation = true
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        let centerOfCurrentLocation = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
        let regionOfMapToDisplay = MKCoordinateRegion(center: centerOfCurrentLocation, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(regionOfMapToDisplay, animated: true)
        self.locationManager.stopUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("An error has occured: \(error.localizedDescription)")
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