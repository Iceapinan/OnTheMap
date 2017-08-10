//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by IceApinan on 5/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import Foundation

// MARK: Constants
struct OTMConstants {
    // MARK : General
    static let ApiScheme = "https"
    struct Parse
    {
        // MARK : URLs
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    
        // MARK: API Keys
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    
        // MARK : Headers
        static let ApplicationIDForHeaderField = "X-Parse-Application-Id"
        static let ApiKeyForHeaderField = "X-Parse-REST-API-Key"
    }
    struct Udacity
    {
        // MARK : URLs
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        // MARK : Methods
        static let Session = "/session"
        static let getPublicUserData = "/users/<user_id>"

    }
    
    struct JSONResponseKeys {
        // Udacity
        static let Session = "session"
        static let SessionID = "id"
        static let Account = "account"
        static let AccountID = "key"
        
        // Parse
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


    


    
    
