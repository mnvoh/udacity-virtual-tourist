//
//  Constants.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

struct Constants {
  static let modelName = "VirtualTourist"
  static let entityLocations = "Locations"
  static let entityPhotos = "Photos"
  static let maxItemsPerCollection = 21
  
  struct Flickr {
    static let apiUrl = "https://api.flickr.com/services/rest/"
    static let apiKey = "8d08f5c86f96e558a93fca47ff650574"
    static let searchMethod = "flickr.photos.search"
    static let radius = 10
  }
}
