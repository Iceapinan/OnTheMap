//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by IceApinan on 4/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

struct StudentInformation {
    
    // MARK: Properties
    let objectId : String
    let uniqueKey : String?
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Float
    let longitude : Float
    let createdAt : String //
    let updatedAt : String //
    let ACL : String //
    
    // MARK: Initializers
    init(dictionary : [String: AnyObject]) {
        objectId = dictionary[OTMClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[OTMClient.JSONResponseKeys.uniqueKey] as? String
        firstName = dictionary[OTMClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[OTMClient.JSONResponseKeys.lastName] as! String
        mapString = dictionary[OTMClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[OTMClient.JSONResponseKeys.mediaURL] as! String
        latitude = dictionary[OTMClient.JSONResponseKeys.latitude] as! Float
        longitude = dictionary[OTMClient.JSONResponseKeys.longitude] as! Float
        createdAt = dictionary[OTMClient.JSONResponseKeys.createdAt] as! String
        updatedAt = dictionary[OTMClient.JSONResponseKeys.updatedAt] as! String
        ACL = dictionary[OTMClient.JSONResponseKeys.ACL] as! String
    }
    
    
}
