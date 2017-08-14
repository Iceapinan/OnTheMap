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
    
    func forUseAsDataSource() {
        ParseClient.sharedInstance().getStudentLocations { (students, error) in
            guard let students = students else { return }
            Storage.shared.arrayofStudents = students
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
        }
    }
}
