//
//  Photos.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation
import CoreData

extension Photos {
  
  convenience init(image: Data, context: NSManagedObjectContext) {
    if let ent = NSEntityDescription.entity(forEntityName: Constants.entityPhotos, in: context) {
      self.init(entity: ent, insertInto: context)
      self.photo = NSData(data: image)
    }
    else {
      fatalError("Could not find entity \(Constants.entityLocations)")
    }
  }
  
}
