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
    @NSManaged public var photos: Photos?

}
