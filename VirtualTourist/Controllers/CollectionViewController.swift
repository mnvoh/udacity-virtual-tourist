//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
  
  var location: Locations!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    FlickrApiClient.sharedInstance.getPhotosFor(location: location) { (photos, error) in
      guard let photos = photos else {
        print(error)
        return
      }
      
      for photo in photos {
        print(photo.url)
      }
    }
  }
  
}
