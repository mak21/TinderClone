//
//  ViewController.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class MainVC: UIViewController {

  @IBOutlet weak var segmentedController: UISegmentedControl!{
    didSet{
      
        segmentedController.backgroundColor = UIColor.clear
      segmentedController.tintColor = UIColor.red
     
      
  }
  }
  @IBOutlet weak var chatBarButton: UIBarButtonItem!
  @IBOutlet weak var profileBarButton: UIBarButtonItem!
  @IBOutlet weak var nopeImageView: UIImageView!
  @IBOutlet weak var likeImageView: UIImageView!
  @IBOutlet weak var cardView: UIView!
  var dividor : CGFloat!
  override func viewDidLoad() {
    super.viewDidLoad()
    chatBarButton.tintColor = UIColor.lightGray
    profileBarButton.tintColor = UIColor.lightGray
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
   
    dividor = (view.frame.width / 2) / 0.61 //0.61 is radian value of 35 degree
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


  @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer) {
    let card = sender.view!
    let point = sender.translation(in: view)
    let xFromCenter = card.center.x - view.center.x
    let scale = min(abs(100 / xFromCenter) , 1) //  min  will return the smallest number after compairing , abs will take the positive value only
    
    card.center = CGPoint(x: view.center.x + point.x , y: view.center.y + point.y)
    card.transform = CGAffineTransform(rotationAngle: xFromCenter/dividor).scaledBy(x: scale, y: scale) // for scaling anything less than 1 will make the object smaller 
    
    if xFromCenter > 0 {
      likeImageView.image = #imageLiteral(resourceName: "like")
      likeImageView.tintColor = UIColor.green
      likeImageView.alpha = abs(xFromCenter) / view.center.x
    }else{
      nopeImageView.image = #imageLiteral(resourceName: "unlike")
      nopeImageView.tintColor = UIColor.red
      nopeImageView.alpha = abs(xFromCenter) / view.center.x
    }
    //thumbImageView.alpha = abs(xFromCenter) / view.center.x
    if sender.state == .ended{
      // setting a mergins to 75 to animate
      if card.center.x < 75 {
        // the view should move to the left
        UIView.animate(withDuration: 0.2, animations: { 
          card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
          card.alpha = 0
        })
return
        
      }else if card.center.x > (view.frame.width - 75){
        // the view should move to the right
          UIView.animate(withDuration: 0.2, animations: {
         card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
            card.alpha = 0
        })
        return
      }
   resetCard()
    
  }
  }
  func resetCard(){
    UIView.animate(withDuration: 0.2) {
      self.cardView.center = self.view.center
      self.likeImageView.alpha = 0
      self.nopeImageView.alpha = 0
      self.cardView.alpha = 1
      self.cardView.transform = .identity
    }
  }
  @IBAction func resetview(_ sender: Any) {
    resetCard()
  }

  
  
  @IBAction func chatBarButtonTapped(_ sender: Any) {
    guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else{return}
    
    navigationController?.pushViewController(controller, animated: true)
  }
}

