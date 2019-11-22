//
//  LocationListViewController.swift
//  CheckThatIn
//
//  Created by Vladimir Vetrov on 16/06/2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LocationCollectionViewCell"

class LocationListViewController: UICollectionViewController {
    
    var locations = [Location]()
    
    let locationCrud = CoreDataLocationCRUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locations = locationCrud.readLocations()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return locations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LocationCollectionViewCell
    
        // Configure the cell
        let latitude = locations[indexPath.item].latitude
        let longitude = locations[indexPath.item].longitude
        cell.labelLocationTitle.text = "lat: \(latitude!.prefix(6)), long:  \(longitude!.prefix(6))"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case "fromLocationListVCToLocationListVC":
            guard let selectedCollectionViewCell = sender as? LocationCollectionViewCell,
                let indexPath = collectionView.indexPath(for: selectedCollectionViewCell)
                else { preconditionFailure("Expected sender to be a valid table view cell") }
            
            guard let locationDetailsViewController = segue.destination as? LocationDetailsViewController
                else { preconditionFailure("Expected a ColorItemViewController") }
            locationDetailsViewController.locationModel = locations[indexPath.item].convertToModel()
        default:
            print("unhandled segue")
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
