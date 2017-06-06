//
//  profileVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
enum ProfileType {
  case myProfile
  case otherProfile
}
class ProfileVC: UIViewController {
  @IBOutlet weak var dismissButton: UIButton!
  @IBOutlet weak var unmatchButton: UIButton!
  @IBOutlet weak var matchButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  var photos : [String] = []
  @IBOutlet weak var collectionView: UICollectionView!{
      didSet{
        collectionView.dataSource = self
        collectionView.delegate = self
      }
    
  }
  

 
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
   var profileType : ProfileType = .myProfile
  var userId = ""
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    photos.removeAll()
    configuringProfileType(profileType)
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      let cellScaling: CGFloat = 0.85
      let screenSize = UIScreen.main.bounds.size
      let cellWidth = floor(screenSize.width * cellScaling)
      let insetX = (view.bounds.width - cellWidth) / 2.0
      collectionView?.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  func configuringProfileType (_ type : ProfileType) {
    switch type {
    case .myProfile :
      
      userId = (FIRAuth.auth()?.currentUser?.uid)!
      fetchphotos(with: userId)
    case .otherProfile:
      dismissButton.isHidden = false
      matchButton.isHidden = false
      unmatchButton.isHidden = false
      fetchphotos(with: userId)
    }
  }
 
  
  
  func fetchphotos(with id : String) {
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      let dictionary = snapshot.value as! [String:Any]
      let user = User(dictionary: dictionary)
     
      if user.id == id{
         self.nameLabel.text = user.name
        for p in user.profileImagesUrl! {
          self.photos.append(p)
        }
      }
      DispatchQueue.main.async {
        
       self.collectionView.reloadData()
        
      }
    })
    
  }
  
  @IBAction func tinderLogButtonTapped(_ sender: Any) {

    dismiss(animated: false, completion: nil)
  }
  
 
  @IBAction func dismissButtonClicked(_ sender: Any) {
    dismiss(animated: false, completion: nil)
  }
  @IBAction func unmatchButtonClicked(_ sender: Any) {
    
    FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("matches/\(userId)").removeValue()
    dismiss(animated: true, completion: nil)
  }
  @IBAction func matchButtonClicked(_ sender: Any) {
    FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["matches/\(userId)" : true ])
    dismiss(animated: true, completion: nil)
  }
  @IBAction func logoutButtonClicked(_ sender: Any) {
    let firebaseAuth = FIRAuth.auth()
    do {
      let facebookManager = FBSDKLoginManager()
      facebookManager.logOut()
      try firebaseAuth?.signOut()
     
    } catch let signOutError as NSError {
      present(AlertControl.displayAlertWithTitle(title: "Error signing out:", message:" \(signOutError)"), animated: true, completion: nil)
    }
    
    
    let singInVC =  UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "FBLoginVC")
    present(singInVC, animated: true, completion: nil)
    
    
  }

}
extension ProfileVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
  
  func scrollToNearestVisibleCollectionViewCell() {
    let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (self.collectionView!.bounds.size.width / 2))
    var closestCellIndex = -1
    var closestDistance: Float = .greatestFiniteMagnitude
    for i in 0..<collectionView.visibleCells.count {
      let cell = collectionView.visibleCells[i]
      let cellWidth = cell.bounds.size.width
      let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
      
      // Now calculate closest cell
      let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
      if distance < closestDistance {
        closestDistance = distance
        closestCellIndex = collectionView.indexPath(for: cell)!.row
      }
    }
    if closestCellIndex != -1 {
      self.collectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return photos.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! profileCollectionViewCell
    if profileType == .myProfile{
      cell.editInfoButton.isHidden = false
    }else{
      cell.editInfoButton.isHidden = true
    }
    cell.profileImage.loadImageUsingCacheWithUrlString(photos[indexPath.row])
   
    
    return cell
    
  }
}
extension ProfileVC:UIScrollViewDelegate{
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    scrollToNearestVisibleCollectionViewCell()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      scrollToNearestVisibleCollectionViewCell()
    }
  }
}
