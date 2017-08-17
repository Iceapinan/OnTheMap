//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by IceApinan on 6/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import Foundation
import UIKit
extension UdacityClient {
    
    func getUdacityAccountID(email : String?, password : String?, facebookToken: String?, completionHandler: @escaping (_ userID: String?, _ error: String?) -> Void) {
        
        var jsonBody = ""
        if let facebookToken = facebookToken {
            jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(facebookToken)\"}}"
        }
        else {
            guard let email = email, let password = password else { return }
            jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        }
        let _ = taskForHTTPMethod(OTMConstants.Udacity.Session, httpMethod: .POST, jsonBody: jsonBody) { (results, error) in
            if let error = error
            {
                completionHandler(nil, error)
            }
            else
            {
                if let statusCode = results?.value(forKey: "status") as? Int, let jsonError = results?.value(forKey: "error") as? String
                {
                    completionHandler(nil, "\(statusCode): \(jsonError)")
                }
                
                else {
                    if let account = results?.value(forKey: OTMConstants.JSONResponseKeys.Account) as? [String:AnyObject], let id = account[OTMConstants.JSONResponseKeys.AccountID] as? String  {
                            completionHandler(id, nil)
                        }
                    else {
                        completionHandler(nil, "Could not parse getUdacityAccountID")
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

    func fetchStudentData(fromAccountID : String, completionHandler: @escaping (_ student: StudentUser?, _ error: String?) -> Void) {
        var method = OTMConstants.Udacity.getPublicUserData
        method = substituteKeyInMethod(method, key: OTMConstants.Udacity.URLKeys.UserID, value: fromAccountID)!
        let _ = taskForHTTPMethod(method, httpMethod: .GET, jsonBody: nil) { (results, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            else {
                
                if let statusCode = results?.value(forKey: "status") as? Int, let jsonError = results?.value(forKey: "error") as? String {
                    completionHandler(nil, "\(statusCode): \(jsonError)")
                }
                else {
                
                if let studentInfoArray = results?.value(forKey: "user") as? [String : AnyObject] {
                    if let firstname = studentInfoArray["first_name"] as? String, let lastname = studentInfoArray["last_name"] as? String {
                        
                        completionHandler(StudentUser(uniqueKey: fromAccountID, firstName: firstname, lastName: lastname, mediaURL: ""), nil)
                    }
                }
                else {
                    completionHandler(nil, "Could not parse fetchStudentData")
                }
            }
        }
    }
}
    
    
    func logout(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let _ = taskForHTTPMethod(OTMConstants.Udacity.Session, httpMethod: .DELETE, jsonBody: nil) { (results, error) in
            
            if let error = error {
                completionHandler(false, error)
            }
            else {
                completionHandler(true, nil)
                print("Logged out successfully!")
            }
            
        }
        
    }
}


    

