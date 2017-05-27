//
//  ChatVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/26/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class SearchChatVC: UIViewController {
  var users : [User] = []
   var filterdUsers = [User]()
  @IBOutlet weak var usersCollectionView:UICollectionView!{
    didSet{
      usersCollectionView.delegate = self
      usersCollectionView.dataSource = self
    }
  }
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
    listenToFirebase() 
    // Do any additional setup after loading the view.
  }
  
  func listenToFirebase() {
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      let dictionary = snapshot.value as! [String:Any]
      let user = User(dictionary: dictionary)
      self.users.append(user)
      self.filterdUsers = self.users
      DispatchQueue.main.async {
        self.usersCollectionView.reloadData()
        
      }
    })
  }
  func filterCollectionView(text:String) {
    
    filterdUsers = users.filter({ (user) -> Bool in
      return (user.name?.lowercased().contains(text.lowercased()))!
    })
    self.usersCollectionView.reloadData()
    
  }
  @IBAction func tinderlogoTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
}
extension SearchChatVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
  
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    if (kind == UICollectionElementKindSectionHeader) {
      let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
      
      return headerView
    }
    
    return UICollectionReusableView()
    
  }
  
  //MARK: - SEARCH
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if(!(searchBar.text?.isEmpty)!){
      
      self.usersCollectionView?.reloadData()
    }
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      filterdUsers = users
      self.usersCollectionView.reloadData()
    }else {
      filterCollectionView(text: searchText)
    }
  }
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return filterdUsers.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    
    cell.profileImage.loadImageUsingCacheWithUrlString(filterdUsers[indexPath.row].profileImageUrl!)
    cell.profileImage.circlerImage()
    cell.nameLabel.text = filterdUsers[indexPath.row].name
    
    
    
    return cell
    
  }

  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
     guard let chatController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else { return }
    navigationController?.pushViewController(chatController, animated: true)
  }
}
