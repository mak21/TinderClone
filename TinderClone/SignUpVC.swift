//
//  SignUpVC.swift
//  FireBaseAuthTypes
//
//  Created by mahmoud khudairi on 4/24/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class SignUpVC: UIViewController {
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text,let confirmPassword = confirmPasswordTextField.text  else {
                present(AlertControl.displayAlertWithTitle(title: "Error", message: "Form is not valid"), animated: true, completion: nil)
            return
        }
        if password != confirmPassword {
            present(AlertControl.displayAlertWithTitle(title: "Error", message: "password not much"), animated: true, completion: nil)
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.present(AlertControl.displayAlertWithTitle(title: "Error", message: (error?.localizedDescription)!), animated: true, completion: nil)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
     //successfully authenticated user
     let imageName = self.emailTextField.text
     let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName ?? uid).jpg")
     
     if let profileImage = self.profilePicture.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
     storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
     if error != nil {
     print(error!)
     return
     }
     if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
     let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "uid" : uid] as [String : Any]
     self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
     
     }
     })
     }
     })
        
     }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
        })
        let homeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVCNAV")
        self.present(homeController, animated: true, completion: nil)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
