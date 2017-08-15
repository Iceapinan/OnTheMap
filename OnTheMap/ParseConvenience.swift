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
        let _ = taskForHTTPMethod(OTMConstants.Parse.StudentLocation, parameters: parameters, httpMethod: .GET, jsonBody: nil) { (response, error) in
            
            if let error = error {
                completionHandler(nil, error)
            }
            else {
                if let jsonLocationsDictionary = response?.value(forKey: "results") as? [[String:AnyObject]] {
                    
                    let students = StudentInformation.studentsFromResults(jsonLocationsDictionary)
                    print(students)
                    completionHandler(students, nil)
                    
                } else {
                    completionHandler(nil, "Could not parse getStudentLocations")
                }
            }
        }
    }
    
    func getSingleStudentLocation(uniqueKey : String, completionHandler : @escaping (_ studentLocation: StudentInformation?, _ error: String?) -> Void) {
        
        let parameters : [String : AnyObject]
            = [OTMConstants.Parse.ParameterKeys.Where : "{\"\(OTMConstants.Parse.ParameterKeys.uniqueKey)\":\"" + "\(uniqueKey)" + "\"}" as AnyObject]
        let _ = taskForHTTPMethod(OTMConstants.Parse.StudentLocation, parameters: parameters, httpMethod: .GET, jsonBody: nil) { (response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            else {
                if let jsonLocationDictionary = response?.value(forKey: "results") as? [[String:AnyObject]] {
                    completionHandler(StudentInformation.studentsFromResults(jsonLocationDictionary)[jsonLocationDictionary.startIndex], nil)
                } else {
                    completionHandler(nil, "Could not parse getSingleStudentLocation")
                }
            }
        }
    }
    
    func postNewStudentLocation (studentInfo : StudentInformation, completionHandler : @escaping (_ success : Bool, _ error: String?) -> Void) {
        let jsonbody = "{\"uniqueKey\": \"\(studentInfo.uniqueKey)\", \"firstName\": \"\(studentInfo.firstName)\", \"lastName\": \"\(studentInfo.lastName)\",\"mapString\": \"\(studentInfo.mapString)\", \"mediaURL\": \"\(studentInfo.mediaURL)\",\"latitude\": \(studentInfo.latitude), \"longitude\": \(studentInfo.longitude)}"
        let _ = taskForHTTPMethod(OTMConstants.Parse.StudentLocation, parameters: [:], httpMethod: .POST, jsonBody: jsonbody) { (response, error) in
            if let error = error {
                completionHandler(false, error)
            } else {
                if let jsonError = response?.value(forKey: "error") as? String {
                    completionHandler(false, jsonError)
                    return
                }
                else {
                if let _ = response?.value(forKey: OTMConstants.JSONResponseKeys.updatedAt) {
                    completionHandler(true, nil)
                    }
                }
            }
        }
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "<\(key)>") != nil {
            return method.replacingOccurrences(of: "<\(key)>", with: value)
        } else {
            return nil
        }
    }

    
    func updateNewStudentLocation (objectId : String, studentInfo : StudentInformation, completionHandler : @escaping (_ success : Bool, _ error: String?) -> Void) {
        let method = substituteKeyInMethod(OTMConstants.Parse.PUTStudentLocation, key: "objectId", value: objectId)!
        let jsonbody = "{\"uniqueKey\": \"\(studentInfo.uniqueKey)\", \"firstName\": \"\(studentInfo.firstName)\", \"lastName\": \"\(studentInfo.lastName)\",\"mapString\": \"\(studentInfo.mapString)\", \"mediaURL\": \"\(studentInfo.mediaURL)\",\"latitude\": \(studentInfo.latitude), \"longitude\": \(studentInfo.longitude)}"
        let _ = taskForHTTPMethod(method, parameters: [:], httpMethod: .PUT, jsonBody: jsonbody) { (response, error) in
            if let error = error {
                completionHandler(false, error)
            } else {
                if let jsonError = response?.value(forKey: "error") as? String {
                    completionHandler(false, jsonError)
                    return
                }
                else {
                    if let _ = response?.value(forKey: OTMConstants.JSONResponseKeys.updatedAt) {
                        completionHandler(true, nil)
                    }
                }
            }

        }
    }
}
