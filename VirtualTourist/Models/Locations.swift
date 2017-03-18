//
//  Locations.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation
import CoreData

extension Locations {
  
  convenience init(lat: Double, lng: Double, latd: Double, lngd: Double, createdAt: NSDate,
                   context: NSManagedObjectContext) {
    if let ent = NSEntityDescription.entity(forEntityName: Constants.entityLocations, in: context) {
      self.init(entity: ent, insertInto: context)
      self.latitude = lat
      self.longitude = lng
      self.latitudeDelta = latd
      self.longitudeDelta = lngd
      self.createdAt = createdAt
    }
    else {
      fatalError("Could not find entity \(Constants.entityLocations)")
    }
  }
  
}
