//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by IceApinan on 5/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
class UdacityClient: NSObject {
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
   
        let request = NSMutableURLRequest(url: udacityURLWithPath(withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if AppDelegate.reachability.currentReachabilityStatus
            == .notReachable
            {
                completionHandlerForPOST(nil, "The Internet connection appears to be offline.")
            }
        
            /* Was there any data returned? */
            if let data = data {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range)
                /* Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            }
                else {
                completionHandlerForPOST(nil, "No data was returned by the request!")
                return
            }
            
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: String?) -> Void) {
        
        var parsedResult: [String:AnyObject]! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            print(parsedResult)
        } catch {
            completionHandlerForConvertData(nil, "Could not parse the data as JSON: '\(data)'")
        }
       completionHandlerForConvertData(parsedResult as AnyObject, nil)
        
    }
    
    
    private func udacityURLWithPath(withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = OTMConstants.ApiScheme
        components.host = OTMConstants.Udacity.ApiHost
        components.path = OTMConstants.Udacity.ApiPath + (withPathExtension ?? "")
        return components.url!
    }
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

}
