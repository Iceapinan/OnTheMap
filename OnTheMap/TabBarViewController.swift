//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 11/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
   


