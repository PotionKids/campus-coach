//
//  ViewController.swift
//  UpcomingMetalShows
//
//  Created by Sam Agnew on 7/25/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import Alamofire

import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    private var gymStats: GymStat = [:]
    
    @IBAction func signOut(_ sender: AnyObject)
    {
        KeychainWrapper.standard.removeObject(forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: Constants.ViewController.Segue.SetGymToSignIn, sender: nil)
    }
    @IBOutlet weak var whiteBldg: UILabel!
    @IBOutlet weak var recHall: UILabel!
    @IBOutlet weak var IMBldg: UILabel!
    
    private func CURLscrapeWebPage(link: String) {
        let CURLscraping = ConstantsDictionary[Constants.Mirror.Key.CURLscraping]!
        let headers = CURLscraping[Constants.Mirror.CURLscraping.Key.HeadersPSUFitness]!
        var result: GymStat?
        
        Alamofire.request(link, headers: headers).responseJSON { [weak weakSelf = self] (response) in
            DispatchQueue.main.async {
                let string = "\(response)"
                Gym.statistics = stringParser(string: string)
                let whiteBldgStats = Gym.statistics[Constants.Gym.Name.WhiteBldg]!
                let whiteBldgOccupancy = Gym.statistics[Constants.Gym.Name.WhiteBldg]![Constants.Gym.Parsing.CurrentVal]!
                weakSelf?.whiteBldg.text = Gym.statistics[Constants.Gym.Name.WhiteBldg]![Constants.Gym.Parsing.CurrentVal]!
                weakSelf?.IMBldg.text = Gym.statistics[Constants.Gym.Name.IMBldg]![Constants.Gym.Parsing.CurrentVal]!
                weakSelf?.recHall.text = Gym.statistics[Constants.Gym.Name.RecHall]![Constants.Gym.Parsing.CurrentVal]!
            }
        }
    }

    
    
    @IBAction func fetch(_ sender: AnyObject)
    {
        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
