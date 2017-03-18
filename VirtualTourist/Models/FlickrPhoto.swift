//
//  FlickrPhoto.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation

struct FlickrPhoto {
  let id: String
  let secret: String
  let server: String
  let farm: Int
  let title: String
  
  var url: String {
    return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
  }
}
