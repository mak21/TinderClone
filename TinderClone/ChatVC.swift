//
//  ChatVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
  @IBOutlet weak var chatbutton: UIButton!{
    didSet{
      chatbutton.tintColor = UIColor.red
    }
  }
  @IBOutlet weak var tinderlogoBtton: UIBarButtonItem!{
    didSet{
      tinderlogoBtton.tintColor = UIColor.lightGray
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func tinderlogoTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
}
