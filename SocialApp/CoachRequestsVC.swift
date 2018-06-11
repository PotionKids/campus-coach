//
//  ViewController.swift
//  TableVCPractice
//
//  Created by Kris Rajendren on Oct/23/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseAuth

import SwiftKeychainWrapper

import Alamofire

class CoachRequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    private var startingVC  = ViewController.CoachRequests
    
    @IBOutlet weak var gymFirstChoiceCoachLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceCoachLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceCoachLabel: UILabel!
    
    @IBOutlet weak var gymFirstCoachOccupancy: UILabel!
    @IBOutlet weak var gymSecondCoachOccupancy: UILabel!
    @IBOutlet weak var gymThirdCoachOccupancy: UILabel!
    
    @IBOutlet weak var gymFirstCoachHours: UILabel!
    @IBOutlet weak var gymSecondCoachHours: UILabel!
    @IBOutlet weak var gymThirdCoachHours: UILabel!
    
    
    @IBAction func gymFirstSelectCoach(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func gymSecondSelectCoach(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func gymThirdSelectCoach(_ sender: AnyObject)
    {
        
    }
    
    
    @IBAction func signOutCoach(_ sender: AnyObject)
    {
        signOutOf(vc: self, viewController: startingVC)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private func CURLscrapeWebPage(link: String) {
        let CURLscraping = ConstantsDictionary[Constants.Mirror.Key.CURLscraping]!
        let headers = CURLscraping[Constants.Mirror.CURLscraping.Key.HeadersPSUFitness]!
        
        Alamofire.request(link, headers: headers).responseJSON { [weak weakSelf = self] (response) in
            DispatchQueue.main.async {
                let string = "\(response)"
                Gym.privateAllStats = stringParser(string: string)
                
                let whiteBldgStats = Gym.allStats[Constants.Gym.Name.WhiteBldg]!
                let whiteBldgOccupancy = Int(whiteBldgStats[Constants.Gym.Parsing.CurrentVal]!)
                let whiteBldgCapacity = Int(whiteBldgStats[Constants.Gym.Parsing.MaxVal]!)
                let whiteBldgOccupancyPercentage = Int(whiteBldgOccupancy! * 100 / whiteBldgCapacity!)
                
                let recHallStats = Gym.allStats[Constants.Gym.Name.RecHall]!
                let recHallOccupancy = Int(recHallStats[Constants.Gym.Parsing.CurrentVal]!)
                let recHallCapacity = Int(recHallStats[Constants.Gym.Parsing.MaxVal]!)
                let recHallOccupancyPercentage = Int(recHallOccupancy! * 100 / recHallCapacity!)
                
                let imBldgStats = Gym.allStats[Constants.Gym.Name.IMBldg]!
                let imBldgOccupancy = Int(imBldgStats[Constants.Gym.Parsing.CurrentVal]!)
                let imBldgCapacity = Int(imBldgStats[Constants.Gym.Parsing.MaxVal]!)
                let imBldgOccupancyPercentage = Int(imBldgOccupancy! * 100 / imBldgCapacity!)
                
                var gymStatisticsDisplay: [(name: String, occupancy: Int)] = [
                    (Constants.Gym.Name.WhiteBldg, whiteBldgOccupancyPercentage),
                    (Constants.Gym.Name.RecHall, recHallOccupancyPercentage),
                    (Constants.Gym.Name.IMBldg, imBldgOccupancyPercentage)
                ]
                
                gymStatisticsDisplay = gymStatisticsDisplay.sorted(by: { (first, second) -> Bool in
                    first.occupancy <= second.occupancy
                })
                
                weakSelf?.gymFirstChoiceCoachLabel.text = "\(gymStatisticsDisplay[0].name)"
                weakSelf?.gymSecondChoiceCoachLabel.text = "\(gymStatisticsDisplay[1].name)"
                weakSelf?.gymThirdChoiceCoachLabel.text = "\(gymStatisticsDisplay[2].name)"
                
                weakSelf?.gymFirstCoachOccupancy.text = "\(gymStatisticsDisplay[0].occupancy) %"
                weakSelf?.gymSecondCoachOccupancy.text = "\(gymStatisticsDisplay[1].occupancy) %"
                weakSelf?.gymThirdCoachOccupancy.text = "\(gymStatisticsDisplay[2].occupancy) %"
            }
        }
    }
    
    internal var selfRequests   = [Request]()
    var requestArray            = [Request]()
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    var requestsRef         = FirebaseRequestsURL
    var _requestsRefHandle: FIRDatabaseHandle!
    var studentRef:         FIRDatabaseReference!
    var _studentRefHandle:  FIRDatabaseHandle!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("KRIS: Just curled.")
        
        tableView.delegate              = self
        tableView.dataSource            = self
        tableView.estimatedRowHeight    = tableView.rowHeight
        tableView.rowHeight             = UITableViewAutomaticDimension
        
        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
        
        _requestsRefHandle = requestsRef.observe(.value, with: { (snapshot) in
            if let snaps    = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snaps
                {
                    print("KRIS: \(snap)")
                    if let data = snap.value as? AnyDictionary
                    {
                        print("KRIS: Data \(data)")
                        let firebaseRID = snap.key
                        if let createdData = data[Constants.Protocols.RequestType.created] as? AnyDictionary
                        {
                            print("KRIS: Created Data \(createdData.forcedStringLiteral)")
                            let created     = Created(withFirebaseRID: firebaseRID, fromData: createdData)!
                            let request     = Request(created: created, accepted: nil, communicated: nil, service: nil, payed: nil, reviewed: nil)
                            print("KRIS: Request Object \(request.created.toStringDictionaryForSpecific(keys: created.firebaseKeys))")
                            self.requestArray.append(request)
                            print("KRIS: Requests \(self.requestArray)")
                        }
                    }
                }
            }
        })
        print("KRIS: Requests \(self.requestArray)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("KRIS: Requests \(requestArray)")
        print("KRIS: Requests Count = \(requestArray.count)")

        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CoachRequestsVC.Cell.Request, for: indexPath) as? RequestCell
        {
            let request = requestArray[indexPath.row]
            cell.updateUI(request: request)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        studentRef          = Persistence.shared.studentRef!
        _studentRefHandle   = studentRef.observe(.value, with:
            {(snapshot) in
                print("KRIS: Snap \(snapshot)")
                print("KRIS: Default selfStudent \(Persistence.shared.student?.stringDictionary)")
                if let data = snapshot.value as? AnyDictionary
                {
                    Persistence.shared.privateStudent = Student(fromUserData: data)!
                    //selfStudent.saveAnyDictionary()
                    print("KRIS: Accepted Request Created by Student \(Persistence.shared.student?.stringDictionary))")
                }
            })
        
        let startingVC      = ViewController.CoachRequests
        let endingVC        = ViewController.CoachService
        let segueIdentifier = startingVC.segueIdentifier(toEndingVC: endingVC)
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return requestArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let serviceVC = segue.destination as? CoachServiceVC
        {
            serviceVC.gymBldg           = Persistence.shared.created?.forGym
            print("KRIS: Gym \(Persistence.shared.created?.forGym)")
            serviceVC.studentName       = Persistence.shared.student?.firstName
            serviceVC.studentImageURL   = Persistence.shared.student?.facebookImageURLString
            serviceVC.studentCell       = Persistence.shared.student?.cell
            print("KRIS: Student Name \(Persistence.shared.student?.firstName)")
        }
    }
    
    deinit
    {
        requestsRef .removeObserver(withHandle: _requestsRefHandle)
        studentRef  .removeObserver(withHandle: _studentRefHandle)
    }
}

