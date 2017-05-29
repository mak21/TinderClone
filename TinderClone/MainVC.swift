//
//  ViewController.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
import DMSwipeCards

class MainVC: UIViewController {
  @IBOutlet weak var heartButton: UIButton!
  @IBOutlet weak var nopeButton: UIButton!
  private var swipeView: DMSwipeCardsView<String>!
  private var count = 0
  var users : [User] = []
  var myMatches : [String] = []
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

  
  override func viewDidLoad() {
    super.viewDidLoad()
    listenToFirebase()
   setupNavigationBar()
  
  }

 
  func setupCardView() {
    var index = 0
    let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
           index = Int(element)!
    
      let container = UIView(frame: CGRect(x: 15, y: 20, width: frame.width - 60, height: frame.height - 40))
      
      let cardImageView = UIImageView(frame: container.bounds)
      if self.users.count != 0 {
      if let profilePic = self.users[index].profileImagesUrl?.first {
      cardImageView.loadImageUsingCacheWithUrlString(profilePic)
      }
      cardImageView.center = container.center
      cardImageView.clipsToBounds = true
      cardImageView.layer.cornerRadius = 16
      container.addSubview(cardImageView)
      container.addSubview(cardImageView)
      let userNamelabel = UILabel(frame: container.bounds)
      userNamelabel.text = self.users[index].name
      userNamelabel.numberOfLines = 10
      userNamelabel.textAlignment = .center
      userNamelabel.textColor = UIColor.white
      userNamelabel.font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightBold)
      userNamelabel.frame = CGRect(x: 15, y: 370, width: 300, height: 100)
      
      container.addSubview(userNamelabel)
      container.layer.shouldRasterize = true
      container.layer.rasterizationScale = UIScreen.main.scale
      
      }
       return container
  }
  
    
    let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
      let label = UILabel()
      label.frame.size = CGSize(width: 100, height: 100)
      label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
      label.layer.cornerRadius = label.frame.width / 2
      
      label.backgroundColor = mode == .left ? UIColor.red : UIColor.green
      label.clipsToBounds = true
      label.text = mode == .left ? "👎" : "👍"
      label.font = UIFont.systemFont(ofSize: 24)
      label.textAlignment = .center
      
      return label
    }
    
    let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
    
   
    swipeView = DMSwipeCardsView<String>(frame: frame,
                                         viewGenerator: viewGenerator,
                                         overlayGenerator: overlayGenerator)
    swipeView.delegate = self
    self.view.addSubview(swipeView)
    
    if users.count == 0{
   self.swipeView.addCards((0...users.count ).map({"\($0)"}))
    }else{
      self.swipeView.addCards((0...users.count - 1 ).map({"\($0)"}))
    }
  }
  func setupNavigationBar(){
  navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
  navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  

  func listenToFirebase() {
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      let dictionary = snapshot.value as! [String:Any]
      let user = User(dictionary: dictionary)
     // filtering the results by adding only the users we didnt match before
      if user.id! != FIRAuth.auth()?.currentUser?.uid {
        if !self.myMatches.contains(user.id!){
            self.users.append(user)
          }
      }else{
        if let matches = user.matches{
        self.myMatches = matches
      }
      }
      DispatchQueue.main.async {
        
        self.setupCardView()
     
      }
    })
   

  }
 

 

  
  @IBAction func chatBarButtonTapped(_ sender: Any) {
    guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchChatVC") as? SearchChatVC else{return}
    
    navigationController?.pushViewController(controller, animated: true)
  }
}
extension MainVC: DMSwipeCardsViewDelegate {
  func reachedEndOfStack() {
    
  }

  func swipedLeft(_ object: Any) {
    
  }

  func swipedRight(_ object: Any) {
    let index = (object as AnyObject).integerValue
    
    print(self.users[index!].id!)
   FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["matches/\(self.users[index!].id!)" : true ])
     FIRDatabase.database().reference().child("users").child(self.users[index!].id!).updateChildValues(["matchedBy/\(FIRAuth.auth()!.currentUser!.uid)" : true ])
    
  }
  
  func cardTapped(_ object: Any) {
    
    guard let index = (object as AnyObject).integerValue else {return}
    guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC else{return}
    controller.profileType = .otherProfile
    controller.userId = self.users[index].id!
    present(controller, animated: false, completion: nil)
  }
  
  
}

