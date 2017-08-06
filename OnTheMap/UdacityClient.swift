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
    
    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
   
        let request = NSMutableURLRequest(url: udacityURLWithPath(withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* Was there any data returned? */
            if let data = data {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range)
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
                /* Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
            }
                else {
                sendError("No data was returned by the request!")
                return
            }
            
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
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
