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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapViewDetails: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationDate = stringFromDate(date: locationModel.dateCaptured)
        dateLabel.text = "That happened on \(locationDate)"
        
        setupMap(latitude: Double(locationModel.latitude)!, longitude: Double(locationModel.longitude)!)
        
        if let description = locationModel.descriptionToSave {
            descriptionLabel.text = "Description: \(description)"
        } else {
            descriptionLabel.text = ""
        }
        
        // Do any additional setup after loading the view.
    }
    
    func stringFromDate(date: Date)-> String {
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        let localDate = iso8601Formatter.string(from: locationModel!.dateCaptured)
        return localDate
    }
    
    func setupMap(latitude: Double, longitude: Double) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapViewDetails.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapViewDetails.addAnnotation(annotation)
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
