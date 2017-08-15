//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 11/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class TabBarViewController:UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func overwriteAlertShow(title : String, message: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (alertAction : UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: { (alertAction : UIAlertAction!) in
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addPinPressed(_ sender: Any) {
        if let studentLoggedIn = Storage.shared.studentLoggedIn {
        ParseClient.sharedInstance().getSingleStudentLocation(uniqueKey: studentLoggedIn.uniqueKey, completionHandler: { (student, error) in
            if student != nil {
                // Override Existing Location
                DispatchQueue.main.async {
                self.overwriteAlertShow(title: "", message: "User" + " " + "\"\(studentLoggedIn.fullName)\"" + " " + "Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", completion: {
                     self.presentViewControllerWithIdentifier(identifier: "InfoPostingViewController", animated: true, completion: nil)
                }) }
            } else { return }
        })
       }
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        Storage.shared.forUseAsDataSource()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UdacityClient.sharedInstance().logout { (success, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.alertShow(title: "Error!", message: error!)
                }
            }
            else {
                DispatchQueue.main.async {
                    self.view.alpha = 1.0
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}
   


