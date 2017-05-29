//
//  AlertControl.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
class AlertControl {
  
    static func displayAlertWithTitle(title:String , message:String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        return alert
    }
}
