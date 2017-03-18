//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Milad Nozari on 3/18/17.
//  Copyright © 2017 Nozary. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  var imageView: UIImageView!
  var activityInd: UIActivityIndicatorView!
  
  var image: UIImage? = nil {
    didSet {
      if image != nil {
        activityInd.isHidden = true
      }
      else {
        activityInd.isHidden = false
      }
      imageView.image = image
    }
  }
  
  // MARK: - Overrides
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: - Private Functions
  private func setup() {
    imageView = UIImageView()
    imageView.backgroundColor = #colorLiteral(red: 0.9466013642, green: 0.9466013642, blue: 0.9466013642, alpha: 1)
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(imageView)
    
    let iTopC = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
    let iRightC = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
    let iBottomC = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
    let iLeftC = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
    
    
    activityInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    activityInd.color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    activityInd.startAnimating()
    activityInd.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(activityInd)
    
    let aHorC = NSLayoutConstraint(item: activityInd, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
    let aVerC = NSLayoutConstraint(item: activityInd, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
    
    NSLayoutConstraint.activate([
      iTopC, iRightC, iBottomC, iLeftC,
      aHorC, aVerC
    ])
  }
}
