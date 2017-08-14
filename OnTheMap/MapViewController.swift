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
        mapView.isRotateEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocations), name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
        Storage.shared.forUseAsDataSource()
        let initialLocation = CLLocation(latitude: 13.736717, longitude: 100.523186)
        centerMapOnLocation(location: initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 10000000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func updateLocations () {
        for student in Storage.shared.arrayofStudents {
            print(student)
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
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
}
