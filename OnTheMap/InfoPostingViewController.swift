//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 13/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import MapKit
class InfoPostingViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topSectionView: UIView!
    @IBOutlet weak var middleSectionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findLocationButton: RoundedButton!
    @IBOutlet weak var submitButton: RoundedButton!
    @IBOutlet weak var locationTextField: UITextField!
    private var mark: CLPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let highlightedText : NSMutableAttributedString = NSMutableAttributedString(string: "Where are you studying today?")
        highlightedText.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: NSMakeRange(14, 8))
        self.questionLabel.attributedText = highlightedText
        
        locationTextField.delegate = self
        websiteTextField.delegate = self
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        mapView.isHidden = true
        websiteTextField.isHidden = true
        submitButton.isHidden = true
    }
    @IBAction func findLocationPressed(_ sender: Any) {
        if (locationTextField.text?.isEmpty)! {
            alertShow(title: "Location Not Found", message: "Must Enter a Location")
        }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            if let _ = error {
                self.alertShow(title: "Location Not Found", message: "Could Not Geocode the String")
            } else {
                self.mark = placemark?.first
                DispatchQueue.main.async {
                    self.configureUI()
                }
                self.mapView.showAnnotations([MKPlacemark(placemark: self.mark!)], animated: true)
            }
        }
        
    }
    
    private func configureUI () {
        mapView.isHidden = false
        websiteTextField.isHidden = false
        submitButton.isHidden = false
        questionLabel.isHidden = true
        middleSectionView.isHidden = true
        findLocationButton.isHidden = true
        topSectionView.backgroundColor = UIColor(red: 81, green: 137, blue: 180, alpha: 1.0)
        
    }
    func dismissVC() {
       self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension InfoPostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


