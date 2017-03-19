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
  @IBOutlet weak var newCollectionButton: UIButton!
  
  
  // MARK: - Properties
  let cellReuseId = "photocell"
  let dataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack
  var location: Locations!
  var photos: [Photos?] = []
  
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
      photos = [Photos?]()
      for p in dbphotos {
        photos.append(p as? Photos)
      }
    }
    else {
      getPhotos()
    }
  }
  
  override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    setupCollectionView()
  }
  
  
  // MARK: - IBActions
  
  @IBAction func newCollection(_ sender: Any) {
    getPhotos()
  }
  
  
  // MARK: - Private Functions
  private func getPhotos() {
    setNewCollectionButton(enabled: false)
    
    // delete the current photos, if any
    if photos.count > 0 {
      for photo in photos {
        if let photo = photo {
          dataStack?.context.delete(photo)
        }
      }
      do {
        try dataStack?.saveContext()
      } catch {
        // could not save the database
        showError(title: "Error", message: error.localizedDescription)
        setNewCollectionButton(enabled: true)
        return
      }
    }
    
    // reload the collection view to show that it's been emptied
    collection.reloadData()
    
    FlickrApiClient.sharedInstance.getPhotosFor(location: location) { (photos, error) in
      guard error == nil else {
        self.showError(title: "Error", message: error!)
        self.setNewCollectionButton(enabled: true)
        return
      }
      
      guard let photos = photos else {
        self.showError(title: "Error", message: "Could not get the photos!")
        self.setNewCollectionButton(enabled: true)
        return
      }
      
      if photos.count <= 0 {
        self.setNewCollectionButton(enabled: true)
        return
      }
      
      DispatchQueue.main.async {
        self.photos = [Photos?]()
        for _ in 0 ..< photos.count {
          self.photos.append(nil)
        }
        self.collection.reloadData()
      }
      
      for (index, item) in photos.enumerated() {
        FlickrApiClient.sharedInstance.download(flickrPhoto: item, indexInArray: index, { (image, indexInArray) in
          guard let image = image else { return }
          
          // save the image in the database
          if let imageData = UIImageJPEGRepresentation(image, 0.9) {
            // Create a Photos object
            let dbphoto = Photos(image: imageData, context: (self.dataStack?.context)!)
            dbphoto.location = self.location
            self.photos[indexInArray] = dbphoto
            
            // Update teh collection view
            DispatchQueue.main.async {
              self.collection.reloadData()
            }
            
            do {
              try self.dataStack?.saveContext()
            } catch {
              print(error.localizedDescription)
            }
          }
        })
      }
      self.setNewCollectionButton(enabled: true)
    }
  }
  
  private func setupCollectionView() {
    let itemsize = (collection.frame.width - 2) / CGFloat(3)
    flowLayout.itemSize = CGSize(width: itemsize, height: itemsize)
    flowLayout.minimumInteritemSpacing = 1
    flowLayout.minimumLineSpacing = 1
    collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
  }
  
  private func setNewCollectionButton(enabled: Bool) {
    newCollectionButton.isEnabled = enabled
    newCollectionButton.alpha = enabled ? 1.0 : 0.5
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // the photo has not been loaded, so move on
    guard let photo = photos[indexPath.item] else {
      return
    }
    
    dataStack?.context.delete(photo)
    do {
      try dataStack?.saveContext()
    } catch {
      print(error)
    }
    photos.remove(at: indexPath.item)
    collectionView.deleteItems(at: [indexPath])
  }
  
}
