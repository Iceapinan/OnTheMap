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
class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var loginButton: FBSDKLoginButton!
    
    let facebookLoginManager = FBSDKLoginManager()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if (emailTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)! {
            alertShow(title: "Error!", message: "Please enter your email address and password")
        } else if (emailTextField.text?.isEmpty)! {
            alertShow(title: "Error!", message: "Please enter your email address")
        }
        else if (passwordTextField.text?.isEmpty)! {
           alertShow(title: "Error!", message: "Please enter your password")
        } else {
            activityIndicator.startAnimating()
            UdacityClient.sharedInstance().getUdacityAccountID(email: emailTextField.text!, password: passwordTextField.text!, facebookToken: nil, completionHandler: { (userID, error) in
                if let error = error {
                    DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.alertShow(title: "Error!", message: error)
                    }
                }
                else {
                    guard let userID = userID else { return }
                    Storage.shared.uniqueKey = userID
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "We got an UserID !!"), object: nil)
                    UdacityClient.sharedInstance().fetchStudentData(fromAccountID: userID, completionHandler: { (student, error) in
                        if let error = error {
                            self.activityIndicator.stopAnimating()
                            self.alertShow(title: "Error!", message: error)
                        }
                        else {
                           guard let student = student else { return }
                           Storage.shared.studentLoggedIn = student
                            print("HAHAHAH")
                           print(Storage.shared.studentLoggedIn!)
                            print("HAHAHAH")
                           DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.presentViewControllerWithIdentifier(identifier: "loggedInNavigationController", animated: true, completion: {
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                            })
                        }
                    }
                })
            }
        })
       }
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func currentAccessToken() -> FBSDKAccessToken! {
        return FBSDKAccessToken.current()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        if self.currentAccessToken() == nil {
            activityIndicator.startAnimating()
        }
        return true
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let token = result.token.tokenString {
            UdacityClient.sharedInstance().getUdacityAccountID(email: "", password: "", facebookToken: token, completionHandler: { (userID, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.alertShow(title: "Error!", message: error)
                    }
                } else {
                    if let userID = userID {
                        UdacityClient.sharedInstance().fetchStudentData(fromAccountID: userID, completionHandler: { (student, error) in
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.presentViewControllerWithIdentifier(identifier: "loggedInNavigationController", animated: true, completion: {
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                })
                            }
                        })
                    }
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        facebookLoginManager.logOut()
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension UIViewController {
    
    func alertShow(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (alertAction : UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func presentViewControllerWithIdentifier(identifier: String, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = storyboard!.instantiateViewController(withIdentifier: identifier)
        present(controller, animated: animated, completion: completion)
    }

    
    
}





