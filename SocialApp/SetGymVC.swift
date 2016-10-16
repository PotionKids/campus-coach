//
//  SetGymVC.swift
//  Coach
//
//  Created by Kris Rajendren on Sep/27/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit
import MapKit

import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

import Alamofire

class SetGymVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var userLocationMap: MKMapView!
    
    @IBOutlet weak var gymFirstChoiceLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceLabel: UILabel!
    
    @IBOutlet weak var gymFirstChoiceOccupancyLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceOccupancyLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceOccupancyLabel: UILabel!
    
    @IBOutlet weak var gymFirstChoiceHoursLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceHoursLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceHoursLabel: UILabel!
    
    @IBAction func signOut(_ sender: AnyObject)
    {
        KeychainWrapper.standard.removeObject(forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: Constants.SetGymVC.Segue.SetGymToSignIn, sender: nil)
    }
    
    
    @IBAction func gymFirstChoiceSelected(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func gymSecondChoiceSelected(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func gymThirdChoiceSelected(_ sender: AnyObject)
    {
        
    }
    
    var locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var gymButtonClicked: String?
    
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
                weakSelf?.gymFirstChoiceOccupancyLabel.text = Gym.statistics[Constants.Gym.Name.WhiteBldg]![Constants.Gym.Parsing.CurrentVal]!
                weakSelf?.gymSecondChoiceOccupancyLabel.text = Gym.statistics[Constants.Gym.Name.IMBldg]![Constants.Gym.Parsing.CurrentVal]!
                weakSelf?.gymThirdChoiceOccupancyLabel.text = Gym.statistics[Constants.Gym.Name.RecHall]![Constants.Gym.Parsing.CurrentVal]!
            }
        }
    }

    
    private func locationManager(manager: CLLocationManager, didUpdateLocations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            
            let center = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            let region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000)
            self.userLocationMap.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "You"
            self.userLocationMap.addAnnotation(annotation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            userLocationMap.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            userLocationMap.showsUserLocation = true
        }
    }
    
    func translateMapCenter(toLocation location: CLLocation, latitudeRange: CLLocationDistance = 2000, longitudeRange: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, latitudeRange, longitudeRange)
        
        userLocationMap.setRegion(coordinateRegion, animated: true)
    }
    
    func userLocationMap(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        if let location = userLocation.location
        {
            if !mapHasCenteredOnce
            {
                translateMapCenter(toLocation: location)
                mapHasCenteredOnce = true
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
