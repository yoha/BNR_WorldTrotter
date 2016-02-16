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
    var cycleLocationIndex: Int!
    var university: ChosenLocations!
    var workplace: ChosenLocations!
    var home: ChosenLocations!
    
    // MARK: - UIViewController Methods
    
    override func loadView() {
        super.loadView()
        
        self.mapView = MKMapView()
        self.view = self.mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.university = ChosenLocations(title: "San Jose State University", coordinate: CLLocationCoordinate2D(latitude: 37.335432, longitude: -121.881276))
        self.workplace = ChosenLocations(title: "Apple Store Los Gatos", coordinate: CLLocationCoordinate2D(latitude: 37.223653, longitude: -121.983850))
        self.home = ChosenLocations(title: "Home", coordinate: CLLocationCoordinate2DMake(37.321255, -121.967902))
        
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
        let locateMeButtonWidthConstraint = locateMeButton.widthAnchor.constraintEqualToAnchor(nil, constant: 120.0)
        let locateMeButtonHeightConstraint = locateMeButton.heightAnchor.constraintEqualToAnchor(nil, constant: 35.0)
        let locateMeButtonHorizontalConstraint = locateMeButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -15.0)
        let locateMeButtonVerticalConstraint = locateMeButton.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor, constant: -28.0)
        NSLayoutConstraint.activateConstraints([locateMeButtonWidthConstraint, locateMeButtonHeightConstraint, locateMeButtonHorizontalConstraint, locateMeButtonVerticalConstraint])
        
        let cycleLocationsButton = UIButton(type: .System)
        cycleLocationsButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        cycleLocationsButton.tintColor = UIColor.whiteColor()
        cycleLocationsButton.setTitle("Cycle Locations", forState: .Normal)
        cycleLocationsButton.layer.cornerRadius = 4.0
        cycleLocationsButton.layer.backgroundColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0).CGColor
        cycleLocationsButton.translatesAutoresizingMaskIntoConstraints = false
        cycleLocationsButton.addTarget(self, action: "cycleLocations", forControlEvents: .TouchUpInside)
        self.view.addSubview(cycleLocationsButton)
        
        // NSLayoutConstraint style
        let cycleLocationsButtonHorizontalConstraint = NSLayoutConstraint(item: cycleLocationsButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 15.0)
        let cycleLocationsButtonVerticalConstraint = NSLayoutConstraint(item: cycleLocationsButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: -28.0)
        let cycleLocationsButtonWidthConstraint = NSLayoutConstraint(item: cycleLocationsButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 120.0)
        let cycleLocationsButtonHeightConstriant = NSLayoutConstraint(item: cycleLocationsButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35.0)
        cycleLocationsButtonHorizontalConstraint.active = true
        cycleLocationsButtonVerticalConstraint.active = true
        cycleLocationsButtonWidthConstraint.active = true
        cycleLocationsButtonHeightConstriant.active = true
        

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
    
    func cycleLocations() {
        if self.cycleLocationIndex == nil || self.cycleLocationIndex == 2 {
            self.cycleLocationIndex = 0
            self.pinpointAndAnnotateLocationOnMap(self.university)
        }
        else if self.cycleLocationIndex == 0 {
            self.cycleLocationIndex = 1
            self.pinpointAndAnnotateLocationOnMap(self.workplace)
        }
        else if self.cycleLocationIndex == 1 {
            self.cycleLocationIndex = 2
            self.pinpointAndAnnotateLocationOnMap(self.home)
        }
    }
    
    private func pinpointAndAnnotateLocationOnMap(location: ChosenLocations) {
        let latitudeDeltaZoomLevel: CLLocationDegrees = 0.007
        let longitudeDeltaZoomLevel: CLLocationDegrees = 0.007
        let areaSpannedByMapRegion: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDeltaZoomLevel, longitudeDelta: longitudeDeltaZoomLevel)
        let geographicalCoordinateStruct: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let mapRegionToDisplay: MKCoordinateRegion = MKCoordinateRegionMake(geographicalCoordinateStruct, areaSpannedByMapRegion)
        self.mapView.setRegion(mapRegionToDisplay, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = geographicalCoordinateStruct
        annotation.title = location.title ?? "unspecified"
        self.mapView.addAnnotation(annotation)
    }
}