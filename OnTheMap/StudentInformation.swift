//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by IceApinan on 4/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

struct StudentInformation  {
  // MARK: Properties
    let objectId : String
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double
    let longitude : Double
//    var createdAt : String?
//    var updatedAt : String?
    
    // MARK: Initializers
    init(dictionary : [String: AnyObject]) {
        objectId = dictionary[OTMConstants.JSONResponseKeys.objectId] as? String ?? ""
        uniqueKey = dictionary[OTMConstants.JSONResponseKeys.uniqueKey] as? String ?? ""
        firstName = dictionary[OTMConstants.JSONResponseKeys.firstName] as? String ?? ""
        lastName = dictionary[OTMConstants.JSONResponseKeys.lastName] as? String ?? ""
        mapString = dictionary[OTMConstants.JSONResponseKeys.mapString] as? String ?? ""
        mediaURL = dictionary[OTMConstants.JSONResponseKeys.mediaURL] as? String ?? ""
        latitude = dictionary[OTMConstants.JSONResponseKeys.latitude] as? Double ?? 0.0
        longitude = dictionary[OTMConstants.JSONResponseKeys.longitude] as? Double ?? 0.0
//        createdAt = dictionary[OTMConstants.JSONResponseKeys.createdAt] as? String ?? ""
//        updatedAt = dictionary[OTMConstants.JSONResponseKeys.updatedAt]as? String ?? ""
    }
    init(objectId : String, uniqueKey: String, firstName : String, lastName: String, mapString: String, mediaURL : String, latitude: Double, longitude: Double) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func studentsFromResults (_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }


}
