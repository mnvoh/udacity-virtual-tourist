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
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
  
  // MARK: - Properties
  let cellReuseId = "photocell"
  let dataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack
  var location: Locations!
  var photos: [UIImage?] = []
  
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
    
    setupCollectionView()
    
    if let dbphotos = location.photos, dbphotos.count > 0 {
      photos = [UIImage?]()
      for p in dbphotos {
        photos.append(UIImage(data: (p as! Photos).photo as! Data))
      }
    }
    else {
      getPhotos()
    }
  }
  
  override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    setupCollectionView()
  }
  
  // MARK: - Private Functions
  private func getPhotos() {
    FlickrApiClient.sharedInstance.getPhotosFor(location: location) { (photos, error) in
      guard error == nil else {
        self.showError(title: "Error", message: error!)
        return
      }
      
      guard let photos = photos else {
        self.showError(title: "Error", message: "Could not get the photos!")
        return
      }
      
      if photos.count <= 0 {
        return
      }
      
      DispatchQueue.main.async {
        self.photos = [UIImage?]()
        for _ in 0 ..< photos.count {
          self.photos.append(nil)
        }
        self.collection.reloadData()
      }
      
      for (index, item) in photos.enumerated() {
        FlickrApiClient.sharedInstance.download(flickrPhoto: item, indexInArray: index, { (image, indexInArray) in
          DispatchQueue.main.async {
            self.photos[indexInArray] = image
            self.collection.reloadData()
          }
          
          guard let image = image else { return }
          
          // save the image in the database
          if let imageData = UIImageJPEGRepresentation(image, 0.9) {
            let dbphoto = Photos(image: imageData, context: (self.dataStack?.context)!)
            dbphoto.location = self.location
            do {
              try self.dataStack?.saveContext()
            } catch {
              print(error.localizedDescription)
            }
          }
        })
      }
    }
  }
  
  private func setupCollectionView() {
    let itemsize = (collection.frame.width - 2) / CGFloat(3)
    flowLayout.itemSize = CGSize(width: itemsize, height: itemsize)
    flowLayout.minimumInteritemSpacing = 1
    flowLayout.minimumLineSpacing = 1
    collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
  }
  
  private func showError(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(action)
    present(alertController, animated: true, completion: nil)
  }
}

// MARK: - CollectionView DataSource
extension CollectionViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
      as? PhotoCollectionViewCell
    
    if cell == nil {
      cell = PhotoCollectionViewCell()
    }
    
    cell?.image = photos[indexPath.item]
    
    return cell!
  }
  
}


// MARK: - CollectionView Delegate
extension CollectionViewController: UICollectionViewDelegate {
  
  
  
}
