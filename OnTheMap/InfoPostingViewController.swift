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
        setInitialUI()
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if (websiteTextField.text?.isEmpty)! {
            alertShow(title: "Website Not Found", message: "Must Enter a website")
        }
        guard let studentLoggedIn = Storage.shared.studentLoggedIn else { return }
        if let objectId = Storage.shared.objectId {
            ParseClient.sharedInstance().updateNewStudentLocation(objectId: objectId, studentInfo: StudentInformation(objectId: objectId, uniqueKey: studentLoggedIn.uniqueKey, firstName: studentLoggedIn.firstName, lastName: studentLoggedIn.lastName, mapString: locationTextField.text!, mediaURL: websiteTextField.text!, latitude: (mark?.location?.coordinate.latitude)!, longitude: (mark?.location?.coordinate.longitude)!), completionHandler: { (success, error) in
                if let _ = error {
                    self.alertShow(title: "HAHAAH", message: "1234")
                } else {
                    Storage.shared.studentLoggedIn?.mediaURL = self.websiteTextField.text!
                    Storage.shared.forUseAsDataSource()
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        } else {
            print("1")
            
        }
        
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        if (locationTextField.text?.isEmpty)! {
            alertShow(title: "Location Not Found", message: "Must Enter a Location")
        } else {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            if let _ = error {
                self.alertShow(title: "Location Not Found", message: "Could Not Geocode the String")
            } else {
                self.mark = placemark?.first
                DispatchQueue.main.async {
                    self.configureUI()
                    self.mapView.showAnnotations([MKPlacemark(placemark: self.mark!)], animated: true)
                }
            }
        }
    }
}
    private func setInitialUI() {
        DispatchQueue.main.async {
            let highlightedText : NSMutableAttributedString = NSMutableAttributedString(string: "Where are you studying today?")
            highlightedText.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: NSMakeRange(14, 8))
            self.questionLabel.attributedText = highlightedText
            self.locationTextField.delegate = self
            self.websiteTextField.delegate = self
            self.cancelButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
            self.mapView.isHidden = true
            self.websiteTextField.isHidden = true
            self.submitButton.isHidden = true
        }
    }
    
    private func configureUI() {
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


