//
//  PresentViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 19/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alertShow(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: { (alertAction : UIAlertAction!) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentViewControllerWithIdentifier(identifier: String, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = storyboard!.instantiateViewController(withIdentifier: identifier)
        DispatchQueue.main.async {
            self.present(controller, animated: animated, completion: completion)
        }
    }
    
}
