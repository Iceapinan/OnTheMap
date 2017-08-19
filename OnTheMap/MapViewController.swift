//
//  MapViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 7/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var annotations = [OTMLocation]()
    @IBOutlet weak var mapView: MKMapView!
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isRotateEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocations), name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
        let initialLocation = CLLocation(latitude: 13.736717, longitude: 100.523186)
        centerMapOnLocation(location: initialLocation)
        NotificationCenter.default.addObserver(self, selector: #selector(mapViewAnnotationsReload), name: NSNotification.Name(rawValue: "refreshPressed"), object: nil)
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.color = UIColor.blue
        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        activityIndicatorView.isHidden = true
        self.view.addSubview(activityIndicatorView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        forUseAsDataSource()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 10000000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        DispatchQueue.main.async {
        self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func mapViewAnnotationsReload() {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        annotations = []
        forUseAsDataSource()
    }
    
    func updateLocations () {
        
        for student in Storage.shared.arrayofStudents {
            let pinlocation = OTMLocation(fullName: "\(student.lastName) \(student.firstName)", mediaURL: student.mediaURL, latitude: student.latitude, longitude: student.longitude)
            annotations.append(pinlocation)
            
            DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                self.view.alpha = 1.0
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    private func forUseAsDataSource() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
            self.view.alpha = 0.5
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        ParseClient.sharedInstance().getStudentLocations { (students, error) in
            if let error = error {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStudentLocations Error"), object: error)
                self.alertShow(title: "", message: error)
                DispatchQueue.main.async {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicatorView.stopAnimating()
                    self.view.alpha = 1.0
                }
            }
                
            else {
                guard let students = students else { return }
                Storage.shared.arrayofStudents = students
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
            }
        }
    }

}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Students") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Students")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if (view.annotation?.subtitle)! != "" && UIApplication.shared.canOpenURL(URL(string: ((view.annotation?.subtitle)!)!)!) {
                UIApplication.shared.openURL(URL(string: ((view.annotation?.subtitle)!)!)!)
            } else {
                alertShow(title: "", message: "Invalid Link")
            }
        }
    }
    
}

