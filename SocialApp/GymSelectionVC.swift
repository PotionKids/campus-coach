//
//  GymSelectionVC.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/8/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import SwiftKeychainWrapper

import Alamofire

class GymSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    private var startingVC  = ViewController.GymSelection
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
                
                weakSelf?.gymFirstChoiceCoachLabel.text     = "\(gymStatisticsDisplay[0].name)"
                weakSelf?.gymSecondChoiceCoachLabel.text    = "\(gymStatisticsDisplay[1].name)"
                weakSelf?.gymThirdChoiceCoachLabel.text     = "\(gymStatisticsDisplay[2].name)"
                
                weakSelf?.gymFirstCoachOccupancy.text       = "\(gymStatisticsDisplay[0].occupancy) %"
                weakSelf?.gymSecondCoachOccupancy.text      = "\(gymStatisticsDisplay[1].occupancy) %"
                weakSelf?.gymThirdCoachOccupancy.text       = "\(gymStatisticsDisplay[2].occupancy) %"
            }
        }
    }
    
    var gyms = Gym.allGyms
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
        
        //let testURL = "https://graph.facebook.com/10210569767665956/picture?type=large&w‌ idth=1000&height=1000"
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.GymSelection.Cell.GymCellIdentifier, for: indexPath) as? GymCell
        {
            let gym = gyms[indexPath.row]
            cell.updateUI(gym: gym)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let gym     = gyms[indexPath.row]
        let time    = timeStamp().stampNanoseconds
        let created = Created(internallyWithFirebaseRID: time, byStudent: Persistence.shared.firebaseUID!, withName: Persistence.shared.user!.fullName, forGymWith: gym.name)
        let request = Request(created: created)
        let _       = Persistence.shared.registerRequest(request: request)
        request.push()
        let startingVC  = ViewController.GymSelection
        let endingVC    = ViewController.StudentService
        
        performSegue(withIdentifier: startingVC.segueIdentifier(toEndingVC: endingVC), sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let serviceVC = segue.destination as? StudentServiceVC
        {
            serviceVC.request               = Persistence.shared.request
            serviceVC.requestRef            = Persistence.shared.requestRef!
        }
    }
}
