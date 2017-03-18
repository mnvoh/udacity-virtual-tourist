//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import MapKit

class CollectionViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var collection: UICollectionView!
  
  // MARK: - Properties
  var location: Locations!
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    let span = MKCoordinateSpan(latitudeDelta: location.latitudeDelta, longitudeDelta: location.longitudeDelta)
    map.region.center = center
    map.region.span = span
    let annotation = MKPointAnnotation()
    annotation.coordinate = center
    map.addAnnotation(annotation)
    
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
  
  // MARK: - Private Functions
  private func getPhotos() {
    
  }
  
}
