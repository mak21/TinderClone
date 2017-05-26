//
//  profileVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

  @IBOutlet weak var profilebutton: UIButton!{
    didSet{
      profilebutton.tintColor = UIColor.red
    }
  }
  @IBOutlet weak var tinderlogoBtton: UIBarButtonItem!{
    didSet{
      tinderlogoBtton.tintColor = UIColor.lightGray
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.shadowImage = UIImage()
    }

  @IBAction func tinderLogButtonTapped(_ sender: Any) {

    dismiss(animated: false, completion: nil)
  }
    

  

}
