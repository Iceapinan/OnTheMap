//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by IceApinan on 4/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//


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
        objectId = dictionary[OTMConstants.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[OTMConstants.JSONResponseKeys.uniqueKey] as? String
        firstName = dictionary[OTMConstants.JSONResponseKeys.firstName] as! String
        lastName = dictionary[OTMConstants.JSONResponseKeys.lastName] as! String
        mapString = dictionary[OTMConstants.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[OTMConstants.JSONResponseKeys.mediaURL] as! String
        latitude = dictionary[OTMConstants.JSONResponseKeys.latitude] as! Float
        longitude = dictionary[OTMConstants.JSONResponseKeys.longitude] as! Float
        createdAt = dictionary[OTMConstants.JSONResponseKeys.createdAt] as! String
        updatedAt = dictionary[OTMConstants.JSONResponseKeys.updatedAt] as! String
        ACL = dictionary[OTMConstants.JSONResponseKeys.ACL] as! String

    }
    
    
}
