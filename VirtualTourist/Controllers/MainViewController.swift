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
  
  // MARK: - Properties
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    let fr = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityLocations)
    fr.sortDescriptors = []
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                          managedObjectContext: (appDelegate.dataStack?.context)!,
                                                          sectionNameKeyPath: nil, cacheName: nil)
    
    loadPins()
  }
  
  // MARK: - IBActions
  
  
  // MARK: - Public functions
  func addPin(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state != .began {
      return
    }
    
    let touchLocation = gesture.location(in: map)
    let location = map.convert(touchLocation, toCoordinateFrom: map)
    let span = map.region.span
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = location
    map.addAnnotation(annotation)
    
    let dbpin = Locations(lat: location.latitude, lng: location.longitude, latd: span.latitudeDelta,
                          lngd: span.longitudeDelta, context: (appDelegate.dataStack?.context)!)
    try! appDelegate.dataStack?.saveContext()
  }
  
  // MARK: - Private functions
  private func setup() {
    let longTapHandler = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
    map.addGestureRecognizer(longTapHandler)
  }
  
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
    
    for object in fetchedObjects {
      let location = object as! Locations
      let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinates
      annotations.append(annotation)
    }
    
    map.addAnnotations(annotations)
  }
  
}
