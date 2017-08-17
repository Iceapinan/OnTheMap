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
    
    func forUseAsDataSource() {
        ParseClient.sharedInstance().getStudentLocations { (students, error) in
            if let error = error {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStudentLocations Error"), object: error)
            }
            else {
            guard let students = students else { return }
            Storage.shared.arrayofStudents = students
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
        }
     }
  }
}
