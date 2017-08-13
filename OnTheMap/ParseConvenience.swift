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
                    
                } else { print("NOOOOOOOO")}
            }
        }
        
        
        
    }
    
}
