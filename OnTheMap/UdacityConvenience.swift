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
    
    func getUdacitySessionID(email : String, password : String, completionHandler: @escaping (_ sessionID: String?, _ error: String?) -> Void) {
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        let _ = taskForPOSTMethod(OTMConstants.Udacity.Session, jsonBody: jsonBody) { (results, error) in
            if let error = error
            {
                completionHandler(nil, error)
            }
            else
            {
                if let statusCode = results?.value(forKey: "status") as? Int, let jsonError = results?.value(forKey: "error") as? String {
                    completionHandler(nil,"\(statusCode): \(jsonError) ")
                }

                if let session = results?.value(forKey: OTMConstants.JSONResponseKeys.Session) as? [String:AnyObject] {
                    if let id = session[OTMConstants.JSONResponseKeys.SessionID] as? String {
                        print(id)
                        print("YESSS")
                        completionHandler(id, nil)
                    }
                }
            }
            
        }
    }
}



    
    /* func getUdacitySessionIDWithFacebook (accessToken: String) {
        
        let jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}"
 
        
    } */
   

    

