//
//  profileCollectionViewCell.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/29/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class profileCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var profileImage: UIImageView!
    
  @IBOutlet weak var editInfoButton: GraidentButton!
  override func prepareForReuse() {
    super.prepareForReuse()
    
    profileImage.image = nil
  }
}
