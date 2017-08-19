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
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        activityIndicatorView.color = UIColor.red
        activityIndicatorView.isHidden = true
        self.view.addSubview(activityIndicatorView)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if (websiteTextField.text?.isEmpty)! {
            alertShow(title: "Website Not Found", message: "Must Enter a website")
        } else if let url = URL(string: websiteTextField.text!), UIApplication.shared.canOpenURL(url) {
            self.activityIndicatorView.startAnimating()
            guard let studentLoggedIn = Storage.shared.studentLoggedIn else { return }
            if let objectId = Storage.shared.objectId {
                ParseClient.sharedInstance().updateNewStudentLocation(objectId: objectId, studentInfo: StudentInformation(objectId: objectId, uniqueKey: studentLoggedIn.uniqueKey, firstName: studentLoggedIn.firstName, lastName: studentLoggedIn.lastName, mapString: locationTextField.text!, mediaURL: websiteTextField.text!, latitude: (mark?.location?.coordinate.latitude)!, longitude: (mark?.location?.coordinate.longitude)!), completionHandler: { (success, error) in
                    if let error = error {
                        self.alertShow(title: "", message: error)
                        DispatchQueue.main.async {
                            self.activityIndicatorView.stopAnimating()
                        }
                    } else {
                        DispatchQueue.main.async {
                            Storage.shared.studentLoggedIn?.mediaURL = self.websiteTextField.text!
                        }
                        self.dismiss(animated: true, completion: {  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPressed"), object: nil) })
                        DispatchQueue.main.async {
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                })
                
            } else {
                ParseClient.sharedInstance().postNewStudentLocation(studentInfo: StudentInformation(objectId: "", uniqueKey: studentLoggedIn.uniqueKey, firstName: studentLoggedIn.firstName, lastName: studentLoggedIn.lastName, mapString: locationTextField.text!, mediaURL: websiteTextField.text!, latitude: (mark?.location?.coordinate.latitude)!, longitude: (mark?.location?.coordinate.longitude)!), completionHandler: { (success, error) in
                    if let error = error {
                        self.alertShow(title: "", message: error)
                    } else {
                        DispatchQueue.main.async {
                            Storage.shared.studentLoggedIn?.mediaURL = self.websiteTextField.text!
                        }
                        self.dismiss(animated: true, completion: {  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPressed"), object: nil) })
                    }
                })
            }

        } else {
            alertShow(title: "Invaild URL", message: "Must Enter a vaild website")
        }
        
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        if (locationTextField.text?.isEmpty)! {
            alertShow(title: "Location Not Found", message: "Must Enter a Location")
        } else {
        self.activityIndicatorView.startAnimating()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                }
                self.alertShow(title: "Location Not Found", message: "Could Not Geocode the String")
            
            } else {
                self.mark = placemark?.first
                DispatchQueue.main.async {
                    self.configureUI()
                    self.mapView.showAnnotations([MKPlacemark(placemark: self.mark!)], animated: true)
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
}
    private func setInitialUI() {
        DispatchQueue.main.async {
            self.mapView.isHidden = true
            self.websiteTextField.isHidden = true
            self.submitButton.isHidden = true
            let highlightedText : NSMutableAttributedString = NSMutableAttributedString(string: "Where are you studying today?")
            highlightedText.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: NSMakeRange(14, 8))
            self.questionLabel.attributedText = highlightedText
            self.locationTextField.delegate = self
            self.websiteTextField.delegate = self
            self.cancelButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
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


