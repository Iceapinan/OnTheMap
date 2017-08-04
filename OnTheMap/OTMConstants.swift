//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by IceApinan on 2/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

extension OTMClient {
    
    // MARK: Constants
    struct Constants {
        
            // MARK : URLs
            static let ApiScheme = "https"
            static let ApiHost = "parse.udacity.com"
            static let ApiPath = "/parse/classes"
        
        // MARK : Parse API
         struct ParaseAPI {
            // MARK: API Keys
            static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            // MARK : Headers
            static let ApplicationIDForHeaderField = "X-Parse-Application-Id"
            static let ApiKeyForHeaderField = "X-Parse-REST-API-Key"
        }
            struct UdacityAPI {
            // MARK: URLs
            static let ApiHost = "www.udacity.com"
            static let ApiPath = "/api"
            static let PostSessionURL = "https://www.udacity.com/api/session"
            static let UserID = "user_id"
        }
        
        struct OptionalParameterKeys {
            static let Limit = "limit"
            static let Skip = "skip"
            static let Order = "order"
        }
        struct RequiredParameterKeys {
            
        }
       
    }
    
    struct Methods {
        static let PublicUserData = "/users/<user_id>"
    }
    
    struct JSONResponseKeys {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let ACL = "ACL"
    }
    
    
    
}
