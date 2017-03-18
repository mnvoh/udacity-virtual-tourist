//
//  FlickrApiClient.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import Foundation
import GameKit

class FlickrApiClient: Client {
  
  static let sharedInstance = FlickrApiClient()
  
  private override init() {
    super.init()
  }
  
  func getPhotosFor(location: Locations, _ completionHandler: @escaping ([FlickrPhoto]?, String?) -> Void) {
    // get the list of photos
    let url = Constants.Flickr.apiUrl
    let params = [
      "method": Constants.Flickr.searchMethod,
      "format": "json",
      "per_page": "300",
      "api_key": Constants.Flickr.apiKey,
      "lat": "\(location.latitude)",
      "lon": "\(location.longitude)",
      "radius": "\(Constants.Flickr.radius)"
    ]
    self.get(url, parameters: params, headers: nil) { (data, response, error) in
      guard let data = data else {
        completionHandler(nil, error)
        return
      }
      
      let subdata = data.subdata(in: Range(14 ..< data.count - 1))
      
      let json: [String: Any]
      
      do {
        json = try JSONSerialization.jsonObject(with: subdata, options: .allowFragments) as! [String: Any]
      } catch {
        completionHandler(nil, "Invalid response!")
        return
      }
      
      guard let photos = json["photos"], let photosArray = (photos as! [String: Any])["photo"] else {
        completionHandler(nil, "No Results!")
        return
      }
      
      var flickrPhotos = [FlickrPhoto]()

      for item in (photosArray as! [Any]) {
        let flickrPhoto = item as! [String: Any]
        
        guard let id = flickrPhoto["id"] as? String,
        let secret = flickrPhoto["secret"] as? String,
        let server = flickrPhoto["server"] as? String,
        let farm = flickrPhoto["farm"] as? Int,
        let title = flickrPhoto["title"] as? String else {
          continue
        }
        
        let fp = FlickrPhoto(id: id, secret: secret, server: server, farm: farm, title: title)
        flickrPhotos.append(fp)
      }
      
      // If the number of the images is less than what we want, no need to shuffle them
      if flickrPhotos.count < Constants.maxItemsPerCollection {
        completionHandler(flickrPhotos, nil)
        return
      }
      
      var shuffled: [FlickrPhoto] = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: flickrPhotos)
        as! [FlickrPhoto]
      
      completionHandler(Array(shuffled[0..<Constants.maxItemsPerCollection]), nil)
    }
  }
  
  func download(flickrPhoto: FlickrPhoto, indexInArray: Int, _ completionHandler: @escaping (UIImage?, Int) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      guard let url = URL(string: flickrPhoto.url) else {
        completionHandler(nil, indexInArray)
        return
      }
      
      do {
        let data = try Data(contentsOf: url)
        let image = UIImage(data: data)
        completionHandler(image, indexInArray)
      } catch {
        completionHandler(nil, indexInArray)
        return
      }
    }
  }
  
}
