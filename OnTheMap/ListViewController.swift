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
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsInfoTableView.delegate = self
        studentsInfoTableView.dataSource = self
        studentsInfoTableView.reloadData()
       NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: "refreshPressed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tableViewReloadData), name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
        self.activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
        self.activityIndicatorView.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        self.activityIndicatorView.color = UIColor.black
        self.activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        self.activityIndicatorView.isHidden = false
        view.addSubview(self.activityIndicatorView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forUseAsDataSource()
        tableViewReloadData()
    }
    
    func tableViewReloadData() {
        DispatchQueue.main.async {
            self.studentsInfoTableView.reloadData()
        }
    }
    
    private func forUseAsDataSource() {
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.activityIndicatorView.startAnimating()
        }
               ParseClient.sharedInstance().getStudentLocations { (students, error) in
            if let error = error {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStudentLocations Error"), object: error)
                self.alertShow(title: "", message: error)
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
                
            else {
                guard let students = students else { return }
                Storage.shared.arrayofStudents = students
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getStudentLocations Finished"), object: nil)
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
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
    

