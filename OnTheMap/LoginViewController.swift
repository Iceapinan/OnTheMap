//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 1/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton = FBSDKLoginButton(frame: loginButton.bounds)
        loginButton.readPermissions = ["public_profile"]
        loginButton.delegate = self
        signUpButton.addTarget(self, action: #selector(openSignUpLinkToSafari), for: .touchUpInside)
        let signUpString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        let range = signUpString.mutableString.range(of: "Sign Up")
        signUpString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 22.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1), range: range)
        signUpButton.titleLabel?.attributedText = signUpString
    }
    
    func openSignUpLinkToSafari () {
        UIApplication.shared.openURL(URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!)
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
          
            UdacityClient.sharedInstance().getUdacitySessionID(email: emailTextField.text!, password: passwordTextField.text!, completionHandler: { (results, error) in
                
            })
            
        }
        
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}





