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
  private var swipeView: DMSwipeCardsView<String>!
  private var count = 0
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
      
      cardImageView.loadImageUsingCacheWithUrlString(self.users[index].profileImageUrl!)
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
      
      container.layer.shadowRadius = 4
      container.layer.shadowOpacity = 1.0
      container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
      container.layer.shadowOffset = CGSize(width: 0, height: 0)
      container.layer.shouldRasterize = true
      container.layer.rasterizationScale = UIScreen.main.scale
      
     
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
    
    self.swipeView.addCards((0...users.count - 1 ).map({"\($0)"}))
    
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
  func swipedLeft(_ object: Any) {
    print("Swiped left: \(object)")
  }
  
  func swipedRight(_ object: Any) {
    let index = (object as AnyObject).integerValue
    print("Swiped right: \(String(describing: index!))")
    
    print(self.users[index!].id!)
   FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["matches/\(self.users[index!].id!)" : true ])
    
  }
  
  func cardTapped(_ object: Any) {
    print("Tapped on: \(object)")
  }
  
  func reachedEndOfStack() {
    print("Reached end of stack")
  }
}

