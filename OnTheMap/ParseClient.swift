//
//  ParseClient.swift
//  OnTheMap
//
//  Created by IceApinan on 7/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }

    // MARK: POST/GET/PUT/DELETE
    
    func taskForHTTPMethod(_ method: String, parameters: [String:AnyObject],  httpMethod: HTTPMethod, jsonBody: String?, completionHandlerForHTTP: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method))
        
        request.httpMethod = httpMethod.rawValue
        request.addValue(OTMConstants.Parse.ParseApplicationID, forHTTPHeaderField: OTMConstants.Parse.ApplicationIDForHeaderField)
        request.addValue(OTMConstants.Parse.ApiKey, forHTTPHeaderField: OTMConstants.Parse.ApiKeyForHeaderField)
        
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
                /* Parse the data and use the data (happens in completion handler) */
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForHTTP)
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
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            completionHandlerForConvertData(parsedResult, nil)
        } catch {
            completionHandlerForConvertData(nil, "Could not parse the data as JSON: '\(data)'")
        }
        
    }


    private func urlFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = OTMConstants.ApiScheme
        components.host = OTMConstants.Parse.ApiHost
        components.path = OTMConstants.Parse.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

}
