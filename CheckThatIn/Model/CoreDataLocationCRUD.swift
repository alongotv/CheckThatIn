//
//  CoreDataLocationCRUD.swift
//  CheckThatIn
//
//  Created by Vladimir Vetrov on 16/06/2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataLocationCRUD {
    
    func readLocations()-> Array<Location> {
        var locations = [Location]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        
        do {
            locations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return locations
    }
    
    func createLocation(location: LocationModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.persistentContainer.performBackgroundTask { context in
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)!
            let newLocation = Location(entity: entity, insertInto: context)
            newLocation.setValue(location.latitude, forKey: "latitude")
            newLocation.setValue(location.longitude, forKey: "longitude")
            newLocation.setValue(location.dateCaptured, forKey: "date")
            newLocation.setValue(location.descriptionToSave, forKey: "locationDescription")
            do {
                try context.save() }
            catch let error as NSError {
                print("Could not insert. \(error), \(error.userInfo)")
            }
        }
    }
    
}
