//
//  CollectionViewCell.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
  
    override func prepareForReuse() {
        super.prepareForReuse()
      
        profileImage.image = nil
    }
}
