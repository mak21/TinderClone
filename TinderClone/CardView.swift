//
//  CardView.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/27/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class CardView {
  
  static func handleSwipe(_ sender: UIPanGestureRecognizer, superView: UIView!, cardView: UIView, likeImageView: UIImageView, nopeImageView: UIImageView) {
    
    let divider = (superView.frame.width / 2) / 0.61 //0.61 is radian value of 35 degree
    let card = sender.view!
    let point = sender.translation(in: superView)
    let xFromCenter = card.center.x - superView.center.x
    let scale = min(abs(100 / xFromCenter) , 1) //  min  will return the smallest number after compairing , abs will take the positive value only
    
    card.center = CGPoint(x: superView.center.x + point.x , y: superView.center.y + point.y)
    card.transform = CGAffineTransform(rotationAngle: xFromCenter/divider).scaledBy(x: scale, y: scale) // for scaling anything less than 1 will make the object smaller
    
    if xFromCenter > 0 {
      likeImageView.image = #imageLiteral(resourceName: "like")
      likeImageView.tintColor = UIColor.green
      likeImageView.alpha = abs(xFromCenter) / superView.center.x
    }else{
      nopeImageView.image = #imageLiteral(resourceName: "unlike")
      nopeImageView.tintColor = UIColor.red
      nopeImageView.alpha = abs(xFromCenter) / superView.center.x
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
        
      }else if card.center.x > (superView.frame.width - 75){
        // the view should move to the right
     FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["matches":true])
        
        UIView.animate(withDuration: 0.2, animations: {
          card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
          card.alpha = 0
        })
        return
      }
      resetCard(cardView: cardView, superView: superView, likeImageView: likeImageView, nopeImageView: nopeImageView)
      
    }
  }
  
  static func resetCard(cardView: UIView, superView: UIView!, likeImageView: UIImageView, nopeImageView: UIImageView){
    UIView.animate(withDuration: 0.2) {
      cardView.center = superView.center
      likeImageView.alpha = 0
      nopeImageView.alpha = 0
      cardView.alpha = 1
      cardView.transform = .identity
    }
  }
    

 
  
}
