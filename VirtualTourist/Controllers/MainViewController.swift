//
//  MainViewController.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MainViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var tapToDeleteLabelHeightConstraint: NSLayoutConstraint!
  
  // MARK: - Properties
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
  var deleteMode = false {
    didSet {
      if deleteMode {
        tapToDeleteLabelHeightConstraint.constant = 44
        UIView.animate(withDuration: 0.3, animations: {
          self.view.layoutIfNeeded()
        })
      }
      else {
        tapToDeleteLabelHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
          self.view.layoutIfNeeded()
        })
      }
    }
  }
  
  struct Storyboard {
    static let mapToPhotosId = "mapToPhotos"
  }
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    let fr = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityLocations)
    fr.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                          managedObjectContext: (appDelegate.dataStack?.context)!,
                                                          sectionNameKeyPath: nil, cacheName: nil)
    
    loadPins()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tapToDeleteLabelHeightConstraint.constant = 0
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboard.mapToPhotosId {
      let vc = segue.destination as! CollectionViewController
      vc.location = sender as! Locations
    }
  }
  
  // MARK: - IBActions
  @IBAction func edit(_ sender: UIBarButtonItem) {
    if deleteMode {
      sender.title = "Edit"
      deleteMode = false
    }
    else {
      sender.title = "Done"
      deleteMode = true
    }
  }
  
  
  // MARK: - Public functions
  func addPin(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state != .began {
      return
    }

    let touchLocation = gesture.location(in: map)
    let location = map.convert(touchLocation, toCoordinateFrom: map)
    let span = map.region.span
    
    let annotation = MKPointAnnotation()
    if let fetchedObjects = fetchedResultsController.fetchedObjects {
      annotation.title = "\(fetchedObjects.count)"
    }
    annotation.coordinate = location
    map.addAnnotation(annotation)
    
    _ = Locations(lat: location.latitude, lng: location.longitude, latd: span.latitudeDelta,
                  lngd: span.longitudeDelta, createdAt: NSDate(), context: (appDelegate.dataStack?.context)!)
    do {
      try appDelegate.dataStack?.saveContext()
      try fetchedResultsController.performFetch()
    } catch {
      print(error.localizedDescription)
    }
  }
  
  // MARK: - Private functions
  private func setup() {
    let longTapHandler = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
    map.addGestureRecognizer(longTapHandler)
    map.delegate = self
  }
  
  /// Fetch the stored locations form the database
  private func loadPins() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("Fetch Failed!!!!!!")
      return
    }
    
    guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
      return
    }
    
    var annotations = [MKPointAnnotation]()
    
    for (index, object) in fetchedObjects.enumerated() {
      let location = object as! Locations
      let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinates
      annotation.title = "\(index)"
      annotations.append(annotation)
    }
    
    map.addAnnotations(annotations)
  }
  
}

// MARK: - Map Delegate
extension MainViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "mkpin"
    
    var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
    
    if view == nil {
      view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      view?.canShowCallout = false
    }
    else {
      view?.annotation = annotation
    }
    
    return view
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation,
      let unwrappedTitle = annotation.title,
      let title = unwrappedTitle,
      let index = Int(title),
      let location = fetchedResultsController.fetchedObjects?[index] else {
      return
    }
    
    performSegue(withIdentifier: Storyboard.mapToPhotosId, sender: location)
  }
  
}
