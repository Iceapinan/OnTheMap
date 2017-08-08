//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 7/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var OnTheMapDummyButton: UIBarButtonItem!
    private var OnTheMapRealLabel = UILabel(frame: CGRect.zero)
    @IBOutlet weak var mapToolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapToolbar.delegate = self
        OnTheMapRealLabel.text = "On The Map"
        OnTheMapRealLabel.font = UIFont.boldSystemFont(ofSize: 18)
        OnTheMapRealLabel.sizeToFit()
        OnTheMapRealLabel.textAlignment = .center
        OnTheMapDummyButton.customView = OnTheMapRealLabel
    }

}

extension ListViewController: UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
}