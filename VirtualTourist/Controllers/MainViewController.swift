//
//  MainViewController.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var map: MKMapView!
  
  // MARK: - Properties
  let dataStack = CoreDataStack(modelName: Constants.modelName)
  
  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.navigationBar.isHidden = false
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
  }
  
  // MARK: - Private functions
  private func setup() {
    let longTapHandler = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
    map.addGestureRecognizer(longTapHandler)
  }
  
}
