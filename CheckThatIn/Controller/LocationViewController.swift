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
        mapViewOutlet.removeAnnotations(mapViewOutlet.annotations)
        startReceivingLocationChanges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        requestPermissionToUseLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let location = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            mapViewOutlet.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapViewOutlet.addAnnotation(annotation)
            
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
            startReceivingLocationChanges()
            
        }
        startReceivingLocationChanges()
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
