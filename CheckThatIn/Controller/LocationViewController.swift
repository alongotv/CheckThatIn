//
//  LocationViewController.swift
//  CheckThatIn
//
//  Created by Vladimir on 05/06/2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    lazy var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapViewOutlet: MKMapView!
    
    @IBAction func updateLocation() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        requestPermissionToUseLocation()
        startReceivingLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationTextLabel.text = location.description
            locationManager.stopUpdatingLocation()
        }
        // Do something with the location.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }

    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func requestPermissionToUseLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse: do {
            print("authorized")
            startReceivingLocationChanges()            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        @unknown default:
            print("unknown")
        }
    }
}
