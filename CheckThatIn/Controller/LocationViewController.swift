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
    
    lazy var coreDataLocationCRUD = CoreDataLocationCRUD()

    var lastKnownLocation: CLLocation?

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func updateLocation() {
        mapView.removeAnnotations(mapView.annotations)
        startReceivingLocationChanges()
    }
    
    @IBAction func addLocationButtonClicked(_ sender: Any) {
        let alertController: UIAlertController = UIAlertController(title: "Save your current location", message: "", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //cancel code
        }
        alertController.addAction(cancelAction)

        //Create an optional action
        let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .default) { action -> Void in
            let enteredDescription = alertController.textFields![0].text
            let lastKnownLocationCoordinates = self.lastKnownLocation?.coordinate
            
            let locationToSave = LocationModel(latitude: lastKnownLocationCoordinates?.latitude.description, longitude: (lastKnownLocationCoordinates?.longitude.description)!, dateCaptured: Date(), descriptionToSave: enteredDescription)
            self.coreDataLocationCRUD.createLocation(location: locationToSave)
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter description(optional)"
        }
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true)
        
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
            self.lastKnownLocation = lastLocation
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let location = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            mapView.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
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
