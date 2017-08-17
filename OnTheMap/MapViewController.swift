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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isRotateEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocations), name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
        Storage.shared.forUseAsDataSource()
        let initialLocation = CLLocation(latitude: 13.736717, longitude: 100.523186)
        centerMapOnLocation(location: initialLocation)
        NotificationCenter.default.addObserver(self, selector: #selector(mapViewAnnotationsReload), name: NSNotification.Name(rawValue: "refreshPressed"), object: nil)
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
        Storage.shared.forUseAsDataSource()
    }
    
    func updateLocations () {
        
        for student in Storage.shared.arrayofStudents {
            let pinlocation = OTMLocation(fullName: "\(student.lastName) \(student.firstName)", mediaURL: student.mediaURL, latitude: student.latitude, longitude: student.longitude)
            annotations.append(pinlocation)
            
            DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
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
