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
    
    func getUdacityAccountID(email : String, password : String, facebookToken: String?, completionHandler: @escaping (_ userID: String?, _ error: String?) -> Void) {
        
        var jsonBody = ""
        if let facebookToken = facebookToken {
            jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(facebookToken)\"}}"
        }
        else {
            jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        }
        let _ = taskForHTTPMethod(OTMConstants.Udacity.Session, httpMethod: .POST, jsonBody: jsonBody) { (results, error) in
            if let error = error
            {
                completionHandler(nil, error)
            }
            else
            {
                if let statusCode = results?.value(forKey: "status") as? Int, let jsonError = results?.value(forKey: "error") as? String {
                    completionHandler(nil, "\(statusCode): \(jsonError)")
                }
                
                if let account = results?.value(forKey: OTMConstants.JSONResponseKeys.Account) as? [String:AnyObject] {
                    if let id = account[OTMConstants.JSONResponseKeys.AccountID] as? String {
                       print(id)
                       completionHandler(id, nil)
                     
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

    func fetchStudentData(fromAccountID : String, completionHandler: @escaping (_ student: StudentModel?, _ error: String?) -> Void) {
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
                
                if let studentInfoArray = results?.value(forKey: "user") as? [String : AnyObject] {
                    if let firstname = studentInfoArray["first_name"] as? String, let lastname = studentInfoArray["last_name"] as? String {
                        completionHandler(StudentModel(uniqueKey: fromAccountID, firstName: firstname, lastName: lastname, mediaURL: ""), nil)
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



    
    /* func getUdacitySessionIDWithFacebook (accessToken: String) {
        
        let jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}"
 
        
    } */
   

    

