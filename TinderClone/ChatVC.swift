//
//  chatVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/27/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
class ChatVC: JSQMessagesViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
      self.senderId = FIRAuth.auth()?.currentUser?.uid
      self.senderDisplayName = "testing"
        // Do any additional setup after loading the view.
    }

   


}
