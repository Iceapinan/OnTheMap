//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 1/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import FacebookLogin
class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var loginButton: LoginButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton = LoginButton(readPermissions: [ .publicProfile ])
       
    }
    
    func alertShow(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: { (alertAction : UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if (emailTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)! {
            alertShow(title: "Error!", message: "Please enter your email address and password")
        } else if (emailTextField.text?.isEmpty)! {
            alertShow(title: "Error!", message: "Please enter your email address")
        }
        else if (passwordTextField.text?.isEmpty)! {
            alertShow(title: "Error!", message: "Please enter your password")
        } else {
            
            
        }
        
        
    }
   
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

