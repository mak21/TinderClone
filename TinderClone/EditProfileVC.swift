//
//  EditProfileVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/29/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class EditProfileVC: UIViewController {
var imagePickedTag = 0
  var photos : [String] = []
  @IBOutlet weak var imageView1: UIImageView!{
    didSet{
      let image1Tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTapped(sender:)))
      imageView1.addGestureRecognizer(image1Tap)
      imageView1.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var imageView2: UIImageView!{
    didSet{
      let image2Tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTapped(sender:)))
      imageView2.addGestureRecognizer(image2Tap)
      imageView2.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var imageView3: UIImageView!{
    didSet{
      let image3Tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTapped(sender:)))
      imageView3.addGestureRecognizer(image3Tap)
      imageView3.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var imageView4: UIImageView!{
    didSet{
      let image4Tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTapped(sender:)))
      imageView4.addGestureRecognizer(image4Tap)
      imageView4.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var imageView5: UIImageView!{
    didSet{
      let image5Tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTapped(sender:)))
      imageView5.addGestureRecognizer(image5Tap)
      imageView5.isUserInteractionEnabled = true
    }
  }
  @IBOutlet weak var profileImageView: UIImageView!{
    didSet{
      let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTapped(sender:)))
      profileImageView.addGestureRecognizer(profileImageTap)
      profileImageView.isUserInteractionEnabled = true
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      fetchphotos()
        // Do any additional setup after loading the view.
    }
  
  func fetchphotos() {
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      let dictionary = snapshot.value as! [String:Any]
      let user = User(dictionary: dictionary)
      if user.id == FIRAuth.auth()?.currentUser?.uid{
        for p in user.profileImagesUrl! {
        self.photos.append(p)
      }
      }
      DispatchQueue.main.async {
        
        self.profileImageView.loadImageUsingCacheWithUrlString(self.photos[0])
        if self.photos.count == 2{
         self.imageView1.loadImageUsingCacheWithUrlString(self.photos[1])
        }else if self.photos.count == 3{
           self.imageView1.loadImageUsingCacheWithUrlString(self.photos[1])
          self.imageView2.loadImageUsingCacheWithUrlString(self.photos[2])
        }else if self.photos.count == 4 {
          self.imageView1.loadImageUsingCacheWithUrlString(self.photos[1])
          self.imageView2.loadImageUsingCacheWithUrlString(self.photos[2])
          self.imageView3.loadImageUsingCacheWithUrlString(self.photos[3])
        }else if self.photos.count == 5{
          self.imageView1.loadImageUsingCacheWithUrlString(self.photos[1])
          self.imageView2.loadImageUsingCacheWithUrlString(self.photos[2])
          self.imageView3.loadImageUsingCacheWithUrlString(self.photos[3])
           self.imageView4.loadImageUsingCacheWithUrlString(self.photos[4])
        }else if self.photos.count == 6{
          self.imageView1.loadImageUsingCacheWithUrlString(self.photos[1])
          self.imageView2.loadImageUsingCacheWithUrlString(self.photos[2])
          self.imageView3.loadImageUsingCacheWithUrlString(self.photos[3])
          self.imageView4.loadImageUsingCacheWithUrlString(self.photos[4])
           self.imageView5.loadImageUsingCacheWithUrlString(self.photos[5])
        }
      }
    })
    
  }
  
  func handleImageTapped(sender: UITapGestureRecognizer) {
    print((sender.view?.tag)!)
    imagePickedTag = (sender.view?.tag)!
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
    
  }
  func saveImageToFirebase(name: String , selectedImage : UIImageView){
    let imageName = name
    let storageRef = FIRStorage.storage().reference().child("profile_images").child((FIRAuth.auth()?.currentUser?.uid)!).child("\(imageName).jpg")
    
    if let profileImage = selectedImage.image,
      let uploadData = UIImageJPEGRepresentation(profileImage, 0.5) {
      storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
        if error != nil {
          print(error!)
          return
        }
        
        guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
        print(profileImageUrl)
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("profileImagesUrl").updateChildValues([name:profileImageUrl])
          
        
      })
    }
  }

}
extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
  {
    print("User canceled out of picker")
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
  {
    var selectedImageFromPicker: UIImage?
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
    {
      selectedImageFromPicker = editedImage
      
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
    {
      selectedImageFromPicker = originalImage
    }
    
    if let selectedImage = selectedImageFromPicker
    {
      if imagePickedTag == 0 {
        profileImageView.image = selectedImage
        saveImageToFirebase(name: "\(imagePickedTag)", selectedImage: profileImageView)
      } else if imagePickedTag == 1 {
        imageView1.image = selectedImage
         saveImageToFirebase(name: "\(imagePickedTag)", selectedImage: imageView1)
      } else if imagePickedTag == 2 {
        imageView2.image = selectedImage
        saveImageToFirebase(name: "\(imagePickedTag)", selectedImage: imageView2)
      }else  if imagePickedTag == 3 {
        imageView3.image = selectedImage
        saveImageToFirebase(name: "\(imagePickedTag)", selectedImage: imageView3)
      } else if imagePickedTag == 4 {
        imageView4.image = selectedImage
        saveImageToFirebase(name: "\(imagePickedTag)", selectedImage: imageView4)
      }else if imagePickedTag == 5 {
        imageView5.image = selectedImage
        saveImageToFirebase(name: "\(imagePickedTag)", selectedImage: imageView5)
      }
      
    }
   
    
    dismiss(animated: true, completion: nil)
  }
  
}
