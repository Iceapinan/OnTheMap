//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 13/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController {
    
    @IBOutlet weak var addNewLocation: UITextField!
    @IBOutlet weak var addNewWebsite: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
    }
    
    @IBOutlet weak var findLocationPressed: RoundedButton!
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
