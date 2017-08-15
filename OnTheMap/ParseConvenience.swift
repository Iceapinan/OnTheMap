//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by IceApinan on 7/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getStudentLocations(completionHandler : @escaping (_ studentLocations: [StudentInformation]?, _ error: String?) -> Void) {
        
        let parameters : [String : AnyObject] =
            [OTMConstants.Parse.ParameterKeys.limit : OTMConstants.Parse.ParameterValues.hundred as AnyObject, OTMConstants.Parse.ParameterKeys.order: OTMConstants.Parse.ParameterValues.recentlyUpdated as AnyObject]
        let _ = taskForHTTPMethod(OTMConstants.Parse.StudentLocation, parameters: parameters, httpMethod: .GET, jsonBody: nil) { (students, error) in
            
            if let error = error {
                completionHandler(nil, error)
            }
            else {
                if let jsonLocationsDictionary = students?.value(forKey: "results") as? [[String:AnyObject]] {
                    
                    let students = StudentInformation.studentsFromResults(jsonLocationsDictionary)
                    print(students)
                    completionHandler(students, nil)
                    
                } else {
                    completionHandler(nil, "Could not parse getStudentLocations")
                }
            }
        }
    }
    
    func getSingleStudentLocation(uniqueKey : String, completionHandler : @escaping (_ studentLocation: [StudentInformation]?, _ error: String?) -> Void) {
        
        let parameters : [String : AnyObject]
            = [OTMConstants.Parse.ParameterKeys.Where : "{\"\(OTMConstants.Parse.ParameterKeys.uniqueKey)\":\"" + "\(uniqueKey)" + "\"}" as AnyObject]
        let _ = taskForHTTPMethod(OTMConstants.Parse.StudentLocation, parameters: parameters, httpMethod: .GET, jsonBody: nil) { (student, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            else {
                if let jsonLocationDictionary = student?.value(forKey: "results") as? [[String:AnyObject]] {
                    completionHandler(StudentInformation.studentsFromResults(jsonLocationDictionary), nil)
                } else {
                    completionHandler(nil, "Could not parse getSingleStudentLocation")
                }
            }
        }
        
    }
    
}
