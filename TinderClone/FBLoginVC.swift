//
//  FBLoginVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/29/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
class FBLoginVC: UIViewController {
 @IBOutlet weak var facebookLoginButton: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
      handleScrollView()
        // Do any additional setup after loading the view.
    }
  func handleScrollView(){
    self.scrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width/1.1)
    let scrollViewHeight = self.scrollView.frame.height
    let scrollViewWidth = self.scrollView.frame.width
    
    let firstImage = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    
    let secondImage = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    let thirdImage = UIImageView(frame: CGRect(x: scrollViewWidth*2, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    let fourthImage = UIImageView(frame: CGRect(x: scrollViewWidth*3, y: 0, width: scrollViewWidth, height: scrollViewHeight))
    
    firstImage.image = UIImage(named: "1")
    firstImage.layer.cornerRadius = 15
    firstImage.layer.masksToBounds = true
    firstImage.contentMode = .scaleToFill
    secondImage.image = UIImage(named: "2")
    secondImage.layer.cornerRadius = 15
    secondImage.layer.masksToBounds = true
    thirdImage.image = UIImage(named: "3")
    thirdImage.layer.cornerRadius = 15
    thirdImage.layer.masksToBounds = true
    fourthImage.image = UIImage(named: "4")
    fourthImage.layer.cornerRadius = 15
    fourthImage.layer.masksToBounds = true
    
    self.scrollView.addSubview(firstImage)
    self.scrollView.addSubview(secondImage)
    self.scrollView.addSubview(thirdImage)
    self.scrollView.addSubview(fourthImage)
    
    self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width*4, height: self.scrollView.frame.height)
    self.scrollView.delegate = self
    self.pageControl.currentPage = 0
    
  }
  @IBAction func fbButtonPressed(_ sender: Any) {
    
    let facebookLogin = FBSDKLoginManager()
    
    facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
      
      if error != nil {
        
        print("Unable to authenticate with Facebook - \(String(describing: error))")
      } else if result?.isCancelled == true {
        print("User cancelled Facebook authentication")
      } else {
        
        print("Successfully authenticated with Facebook")
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        self.handleAuth(credential)
        
      }
    }
  }
  func handleAuth(_ credential: FIRAuthCredential) {
    
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
      if error != nil {
        print("Unable to authenticate with Firebase - \(String(describing: error))")
      } else {
        print("Successfully authenticated with Firebase")
        
        if let user = user,
          let name = user.displayName,
          let email = user.email{
          //  let userData = ["provider": credential.provider]
          
          let values = ["name": name, "email": email, "profileImagesUrl": ["0" : "\(user.photoURL!)"], "uid" : user.uid] as [String : Any]
          FIRDatabase.database().reference().child("users").child(user.uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
              print(err!)
              return
            }
          })
          
          self.presentHome()
          
        }
      }
    })
  }
  
  func presentHome(){
    let homeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVCNAV")
    self.present(homeController, animated: true, completion: nil)
  }

}
extension FBLoginVC :  UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
    let pageWidth:CGFloat = scrollView.frame.width
    let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
    self.pageControl.currentPage = Int(currentPage)
  
  }
}
