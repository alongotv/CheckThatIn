//
//  LocationDetailsViewController.swift
//  CheckThatIn
//
//  Created by Vladimir Vetrov on 16/06/2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController {

    var locationModel: LocationModel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapViewDetails: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "That happened on \(String(describing: locationModel.dateCaptured!)) \n Description: \( locationModel.descriptionToSave))"
        let latitude = Double(locationModel!.latitude)!
        let longitude = Double(locationModel!.longitude)!
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapViewDetails.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapViewDetails.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
