//
//  ViewController.swift
//  TableVCPractice
//
//  Created by Kris Rajendren on Oct/23/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import SwiftKeychainWrapper

class CoachRequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func signOutCoach(_ sender: AnyObject)
    {
        KeychainWrapper.standard.removeObject(forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: Constants.CoachRequestsVC.Segue.CoachRequestsToSignUp, sender: nil)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var requests = [Request]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let testURL = "https://graph.facebook.com/10210569767665956/picture?type=large&w‌ idth=1000&height=1000"
        
        let testRequestA = Request(gymName: "Rec Hall", action: "Accept", user: "Kris", imageURL: testURL)
        let testRequestB = Request(gymName: "IM Bldg", action: "Accepted", user: "Katie", imageURL: testURL)
        let testRequestC = Request(gymName: "White Bldg", action: "Accept", user: "Lisa", imageURL: testURL)
        
        requests =  [
                        testRequestA,
                        testRequestB,
                        testRequestC
                    ]
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Request", for: indexPath) as? RequestCell
        {
            let request = requests[indexPath.row]
            cell.updateUI(request: request)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return requests.count
    }
}

