//
//  SignInVC.swift
//  TinderClone
//
//  Created by mahmoud khudairi on 5/27/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
 
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
    
}
extension LoginVC : UITextFieldDelegate{
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
}
}
