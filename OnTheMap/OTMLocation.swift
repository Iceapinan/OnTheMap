//
//  OTMLocation.swift
//  OnTheMap
//
//  Created by IceApinan on 14/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import MapKit

class OTMLocation: NSObject {
    var location: CLLocation
    var fullName: String?
    var mediaURL: String?
    
    init(fullName: String, mediaURL: String, latitude: Double, longitude: Double) {
        self.fullName = fullName
        self.mediaURL = mediaURL
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        super.init()
    }

}

extension OTMLocation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    
    var title: String? {
        get {
            return fullName
        }
    }
    var subtitle: String? {
        get {
            return mediaURL
        }
    }
    
    
}
