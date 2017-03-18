//
//  Locations+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation
import CoreData


extension Locations {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
    return NSFetchRequest<Locations>(entityName: "Locations");
  }
  
  @NSManaged public var createdAt: NSDate?
  @NSManaged public var latitude: Double
  @NSManaged public var latitudeDelta: Double
  @NSManaged public var longitude: Double
  @NSManaged public var longitudeDelta: Double
  @NSManaged public var photos: NSSet?
  
}

// MARK: Generated accessors for photos
extension Locations {
  
  @objc(addPhotosObject:)
  @NSManaged public func addToPhotos(_ value: Photos)
  
  @objc(removePhotosObject:)
  @NSManaged public func removeFromPhotos(_ value: Photos)
  
  @objc(addPhotos:)
  @NSManaged public func addToPhotos(_ values: NSSet)
  
  @objc(removePhotos:)
  @NSManaged public func removeFromPhotos(_ values: NSSet)
  
}
