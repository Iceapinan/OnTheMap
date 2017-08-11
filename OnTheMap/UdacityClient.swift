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
    
    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }
    
    // MARK: POST/GET/PUT/DELETE
    
    func taskForHTTPMethod(_ method: String, httpMethod: HTTPMethod, jsonBody: String?,  completionHandlerForHTTP: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        

        let request = NSMutableURLRequest(url: udacityURLWithPath(withPathExtension: method))
        request.httpMethod = httpMethod.rawValue
        if httpMethod == .DELETE {
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        if let jsonBody = jsonBody {
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandlerForHTTP(nil, error!.localizedDescription)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* Was there any data returned? */
            if let data = data {
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range)
                /* Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForHTTP)
            }
                else {
                completionHandlerForHTTP(nil, "No data was returned by the request!")
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
            completionHandlerForConvertData(parsedResult as AnyObject, nil)
        } catch {
            completionHandlerForConvertData(nil, "Could not parse the data as JSON: '\(data)'")
        }
        
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
