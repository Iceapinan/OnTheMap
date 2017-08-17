//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by IceApinan on 7/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var studentsInfoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsInfoTableView.delegate = self
        studentsInfoTableView.dataSource = self
        studentsInfoTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: NSNotification.Name(rawValue: "refreshPressed"), object: nil)

    }
    
    func tableViewReloadData() {
        DispatchQueue.main.async {
        self.studentsInfoTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.shared.arrayofStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! OTMTableViewCell
        let student = Storage.shared.arrayofStudents[indexPath.row]
        cell.fullnameLabel?.text = "\(student.lastName) \(student.firstName)"
        cell.websiteLabel?.text = "\(student.mediaURL)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Storage.shared.arrayofStudents[indexPath.row]
        if student.mediaURL != "" && UIApplication.shared.canOpenURL(URL(string: student.mediaURL)!) {
        UIApplication.shared.openURL(URL(string: student.mediaURL)!)
        } else {
            alertShow(title: "", message: "Invalid Link")
        }
        
    }
    
    
    
}
    

