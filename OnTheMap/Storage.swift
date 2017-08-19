//
//  Storage.swift
//  OnTheMap
//
//  Created by IceApinan on 13/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import Foundation

class Storage {
    
    static let shared = Storage()
    var arrayofStudents = [StudentInformation]()
    var studentLoggedIn : StudentUser?
    var objectId : String?
    
    // Udacity AccountID for getting a single student location 😃
    var uniqueKey : String?
    
}
