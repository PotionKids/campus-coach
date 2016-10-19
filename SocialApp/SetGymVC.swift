//
//  SetGymVC.swift
//  Coach
//
//  Created by Kris Rajendren on Sep/27/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//



import UIKit
import MapKit

import SwiftKeychainWrapper

import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

import Alamofire

class SetGymVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var coachOnTheWay = false
    var locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var gymButtonClicked: String?
    var userLocation: CLLocationCoordinate2D = Constants.Map.Location.BaseInitializer
    
    
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
    
    private func CURLscrapeWebPage(link: String) {
        let CURLscraping = ConstantsDictionary[Constants.Mirror.Key.CURLscraping]!
        let headers = CURLscraping[Constants.Mirror.CURLscraping.Key.HeadersPSUFitness]!
        var result: GymStat?
        
        Alamofire.request(link, headers: headers).responseJSON { [weak weakSelf = self] (response) in
            DispatchQueue.main.async {
                let string = "\(response)"
                Gym.statistics = stringParser(string: string)
                
                let whiteBldgStats = Gym.statistics[Constants.Gym.Name.WhiteBldg]!
                let whiteBldgOccupancy = Int(whiteBldgStats[Constants.Gym.Parsing.CurrentVal]!)
                let whiteBldgCapacity = Int(whiteBldgStats[Constants.Gym.Parsing.MaxVal]!)
                let whiteBldgOccupancyPercentage = Int(whiteBldgOccupancy! * 100 / whiteBldgCapacity!)
                
                let recHallStats = Gym.statistics[Constants.Gym.Name.RecHall]!
                let recHallOccupancy = Int(recHallStats[Constants.Gym.Parsing.CurrentVal]!)
                let recHallCapacity = Int(recHallStats[Constants.Gym.Parsing.MaxVal]!)
                let recHallOccupancyPercentage = Int(recHallOccupancy! * 100 / recHallCapacity!)
                
                let imBldgStats = Gym.statistics[Constants.Gym.Name.IMBldg]!
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
                
                weakSelf?.gymFirstChoiceLabel.text = "\(gymStatisticsDisplay[0].name)"
                weakSelf?.gymSecondChoiceLabel.text = "\(gymStatisticsDisplay[1].name)"
                weakSelf?.gymThirdChoiceLabel.text = "\(gymStatisticsDisplay[2].name)"
                
                weakSelf?.gymFirstChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[0].occupancy) %"
                weakSelf?.gymSecondChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[1].occupancy) %"
                weakSelf?.gymThirdChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[2].occupancy) %"
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location?.coordinate
        {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            if coachOnTheWay == false
            {
                let region = MKCoordinateRegionMakeWithDistance(userLocation, Constants.Map.Distance.SpanHeight, Constants.Map.Distance.SpanWidth)
                
                self.userLocationMap.setRegion(region, animated: true)
                
                self.userLocationMap.removeAnnotations(self.userLocationMap.annotations)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = userLocation
                
                annotation.title = Constants.Map.Annotation.TitleForCurrentLocation
                
                self.userLocationMap.addAnnotation(annotation)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        DataService.ds.refLocations.observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                var counter = 0
                for snap in snapshots
                {
                    counter += 1
                    print("KRIS: Snap Number \(counter) = \(snap.value)")
                }
            }
        })
        
        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
       
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
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        if let location = userLocation.location
        {
            if !mapHasCenteredOnce
            {
                translateMapCenter(toLocation: location)
                //mapHasCenteredOnce = true
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
