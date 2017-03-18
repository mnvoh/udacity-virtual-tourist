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
    print(location.latitude, location.longitude)
  }
  
}
