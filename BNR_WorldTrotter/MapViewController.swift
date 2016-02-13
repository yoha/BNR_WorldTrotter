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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Stored Properties
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    // MARK: - UIViewController Methods
    
    override func loadView() {
        super.loadView()
        
        self.mapView = MKMapView()
        self.view = self.mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*** Segmented Control begins
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: "changeMapType:", forControlEvents: .ValueChanged)
        self.view.addSubview(segmentedControl)
        
        /***
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(self.view.topAnchor)
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor)
        ***/
        
        segmentedControl.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor, constant: 8.0).active = true
        segmentedControl.leadingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.leadingAnchor).active = true
        segmentedControl.trailingAnchor.constraintEqualToAnchor(self.view.layoutMarginsGuide.trailingAnchor).active = true
        
        //*** Segmented Control ends
        
        //*** Button begins
        
        let locateMeButton = UIButton(type: UIButtonType.System)
        locateMeButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        locateMeButton.tintColor = UIColor.whiteColor()
        locateMeButton.setTitle("Locate Me", forState: UIControlState.Normal)
        locateMeButton.layer.cornerRadius = 4.0
        locateMeButton.layer.backgroundColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0).CGColor
        locateMeButton.translatesAutoresizingMaskIntoConstraints = false
        locateMeButton.addTarget(self, action: "navigateToCurrentLocation", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(locateMeButton)
        
        // http://stackoverflow.com/questions/26180822/swift-adding-constraints-programmatically/26181982#26181982
        
        // NSLayoutAnchor style (ios 9.0*)
        let widthConstraint = locateMeButton.widthAnchor.constraintEqualToAnchor(nil, constant: 100.0)
        let heightConstraint = locateMeButton.heightAnchor.constraintEqualToAnchor(nil, constant: 35.0)
        let horizontalConstraint = locateMeButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        let verticalConstraint = locateMeButton.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor, constant: -28.0)
        NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint, horizontalConstraint, verticalConstraint])
        
        /***
        // NSLayoutConstraint style
        let horizontalConstraint = NSLayoutConstraint(item: locateMeButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: locateMeButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -28.0)
        self.view.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: locateMeButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        self.view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: locateMeButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35)
        self.view.addConstraint(heightConstraint)
        ***/
        
        /***
        // Visual Format style
        let views = ["rootView": self.view, "button": locateMeButton]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[rootView]-(<=0)-[button(100)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        self.view.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[rootView]-(<=0)-[button(35)]", options: .AlignAllCenterX, metrics: nil, views: views)
        self.view.addConstraints(verticalConstraints)
        ***/
        
        //*** Button ends
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations updated.")
        if let validLastLocation = locations.last {
            print("Last location: \(validLastLocation).")
            self.currentLocation = validLastLocation
        }
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 500, 500)
        self.mapView.setRegion(zoomedInCurrentLocation, animated: true)
        self.mapView.showsUserLocation = true
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
    
    func navigateToCurrentLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        else if authorizationStatus == .AuthorizedAlways || authorizationStatus == .AuthorizedWhenInUse {
            print("Authorized to use your location. Requesting it...")
            self.locationManager.requestLocation()
        }
    }
}