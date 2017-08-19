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
    
    static let facebookLoginManager = FBSDKLoginManager()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton = FBSDKLoginButton(frame: loginButton.bounds)
        loginButton.readPermissions = ["public_profile"]
        signUpButton.addTarget(self, action: #selector(openSignUpLinkToSafari), for: .touchUpInside)
        let signUpString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        let range = signUpString.mutableString.range(of: "Sign Up")
        signUpString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 22.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1), range: range)
        signUpButton.titleLabel?.attributedText = signUpString
        NotificationCenter.default.addObserver(self, selector: #selector(loginWithFacebookToken), name: NSNotification.Name.FBSDKAccessTokenDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginWithFacebookToken()
    }
    
    func loginWithFacebookToken() {
        if let token = FBSDKAccessToken.current() {
            activityIndicator.startAnimating()
            loginOTM(email: nil, password: nil, facebookToken: token.tokenString)
        }
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
            loginOTM(email: emailTextField.text!, password: passwordTextField.text!, facebookToken: nil)
      }
    }
    func loginOTM(email : String?, password : String?, facebookToken: String?) {
        UdacityClient.sharedInstance().getUdacityAccountID(email: email, password: password, facebookToken: facebookToken, completionHandler: { (userID, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.alertShow(title: "Error!", message: error)
                }
            }
            else {
                guard let userID = userID else { return }
                Storage.shared.uniqueKey = userID
                UdacityClient.sharedInstance().fetchStudentData(fromAccountID: userID, completionHandler: { (student, error) in
                    if let error = error {
                        self.activityIndicator.stopAnimating()
                        self.alertShow(title: "Error!", message: error)
                    }
                    else {
                        guard let student = student else { return }
                        Storage.shared.studentLoggedIn = student
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

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}






