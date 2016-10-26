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
    
    var coachOnTheWay = false
    var locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var gymButtonClicked: String?
    var userLocation: CLLocationCoordinate2D = Constants.Map.Location.BaseInitializer
    
    var geoFire: GeoFire!
    
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    {
        didSet
        {
            mapView.mapType = .standard
            mapView.delegate = self
        }
    }
    
    @IBOutlet weak var gymFirstChoiceLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceLabel: UILabel!
    
    @IBOutlet weak var gymFirstChoiceOccupancyLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceOccupancyLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceOccupancyLabel: UILabel!
    
    @IBOutlet weak var gymFirstChoiceHoursLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceHoursLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceHoursLabel: UILabel!
    
    @IBAction func mapLocation(_ sender: UILongPressGestureRecognizer)
    {
        if sender.state == .began
        {
            let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            let waypoint = EditableWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            waypoint.name = "White Bldg"
            mapView.addAnnotation(waypoint)
            print("KRIS: The Long Pressed Location Latitude = \(coordinate.latitude), Longitude = \(coordinate.longitude)")
        }
    }
    
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
                
                print("KRIS: GYM STATISTICS DISPLAY = \(gymStatisticsDisplay)")
                
                print("KRIS: White Building Occupancy = \(whiteBldgOccupancy)")
                
                weakSelf?.gymFirstChoiceLabel.text = "\(gymStatisticsDisplay[0].name)"
                weakSelf?.gymSecondChoiceLabel.text = "\(gymStatisticsDisplay[1].name)"
                weakSelf?.gymThirdChoiceLabel.text = "\(gymStatisticsDisplay[2].name)"
                
                weakSelf?.gymFirstChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[0].occupancy) %"
                weakSelf?.gymSecondChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[1].occupancy) %"
                weakSelf?.gymThirdChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[2].occupancy) %"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self)
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.Map.Annotation.TitleForUserLocation)
            annotationView?.image = UIImage(named: "User")
        }
        return annotationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userTrackingMode = .follow
        
        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
    }

    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, Constants.Map.Distance.SpanHeight, Constants.Map.Distance.SpanWidth)
        
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        if let location = userLocation.location
        {
            if !mapHasCenteredOnce
            {
                centerMapOnLocation(location: location)
                mapHasCenteredOnce = true
            }
        }
    }
}
