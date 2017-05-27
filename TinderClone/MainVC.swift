//
//  ViewController.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class MainVC: UIViewController {
  var users : [User] = []
  @IBOutlet weak var segmentedController: UISegmentedControl!{
    didSet{
      
        segmentedController.backgroundColor = UIColor.clear
      segmentedController.tintColor = UIColor.red
     
      
  }
  }
  @IBOutlet weak var chatBarButton: UIBarButtonItem!{
    didSet{
       chatBarButton.tintColor = UIColor.lightGray
    }
  }
  @IBOutlet weak var profileBarButton: UIBarButtonItem!{
    didSet{
      profileBarButton.tintColor = UIColor.lightGray
    }
  }
  @IBOutlet weak var nopeImageView: UIImageView!
  @IBOutlet weak var likeImageView: UIImageView!
  @IBOutlet weak var cardView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    listenToFirebase()
   setupNavigationBar()
    
  }
  func setupNavigationBar(){
  navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
  navigationController?.navigationBar.shadowImage = UIImage()
  }

  @IBAction func logoutButtonClicked(_ sender: Any) {
    let firebaseAuth = FIRAuth.auth()
    do {
      try firebaseAuth?.signOut()
      
    } catch let signOutError as NSError {
      present(AlertControl.displayAlertWithTitle(title: "Error signing out:", message:" \(signOutError)"), animated: true, completion: nil)
    }
    
    
    let singInVC =  UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
    present(singInVC, animated: true, completion: nil)
    
  
  }

  func listenToFirebase() {
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      let dictionary = snapshot.value as! [String:Any]
      let user = User(dictionary: dictionary)
      self.users.append(user)
    })
 
    
  }
  @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer) {

       CardView.handleSwipe(sender, superView: view, cardView: cardView, likeImageView: likeImageView, nopeImageView: nopeImageView)
  }

  @IBAction func resetview(_ sender: Any) {
   CardView.resetCard(cardView: cardView, superView: view, likeImageView: likeImageView, nopeImageView: nopeImageView)
  }

  
  
  @IBAction func chatBarButtonTapped(_ sender: Any) {
    guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else{return}
    
    navigationController?.pushViewController(controller, animated: true)
  }
}

