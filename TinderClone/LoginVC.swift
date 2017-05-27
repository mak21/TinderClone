//
//  SignInVC.swift
//  FireBaseAuthTypes
//
//  Created by mahmoud khudairi on 4/24/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
class LoginVC: UIViewController {
  @IBOutlet weak var facebookLoginButton: UIButton!
  @IBOutlet weak var passwordTextField: UITextField!{
    didSet{
      passwordTextField.delegate = self
    }
  }
  @IBOutlet weak var emailTextField: UITextField!{
    didSet{
      emailTextField.delegate = self
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        if email != "" && password != "" {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                     self.present(AlertControl.displayAlertWithTitle(title: "Error", message: (error?.localizedDescription)!), animated: true, completion: nil)
                   
                } else {
                    
                   self.presentHome()
                    
                }
            })
        }else{
            present(AlertControl.displayAlertWithTitle(title: "Error", message: "Input Error: email/password cannot be empty"), animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
    
        guard let signUpController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignUpVCNAV") as? UINavigationController else { return }
        
    
        
        present(signUpController, animated: true, completion: nil)
    }
    func presentHome(){
        let homeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVCNAV")
        self.present(homeController, animated: true, completion: nil)
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
                   
                    let values = ["name": name, "email": email, "profileImageUrl": "\(user.photoURL!)", "uid" : user.uid] as [String : Any]
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
 
}
extension LoginVC : UITextFieldDelegate{
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
}
}
