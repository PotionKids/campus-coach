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
    var userLocation: CLLocationCoordinate2D = Constants.Map.Location.BaseInitializer
    
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    var gymChoiceSelected: Int = 0
    
    //MARK: Firebase Reference Handles and Observers

    fileprivate var _requestCreatedHandle:      FIRDatabaseHandle!
    fileprivate var _requestAcceptedHandle:     FIRDatabaseHandle!
    fileprivate var _requestCommunicatedHandle: FIRDatabaseHandle!
    fileprivate var _requestStartedHandle:      FIRDatabaseHandle!
    fileprivate var _requestStoppedHandle:      FIRDatabaseHandle!
    fileprivate var _requestPayedHandle:        FIRDatabaseHandle!
    fileprivate var _requestReviewedHandle:     FIRDatabaseHandle!
    
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    {
        didSet
        {
            mapView.mapType = .standard
            mapView.delegate = self
            mapView.userTrackingMode = .follow
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
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            createSighting(for: location)
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
        if gymChoiceSelected != 1
        {
            gymChoiceSelected = 1
        }
    }
    
    @IBAction func gymSecondChoiceSelected(_ sender: AnyObject)
    {
        if gymChoiceSelected != 2
        {
            gymChoiceSelected = 2
        }
    }
    
    @IBAction func gymThirdChoiceSelected(_ sender: AnyObject)
    {
        if gymChoiceSelected != 3
        {
            gymChoiceSelected = 3
        }
    }
    
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
                
                Gym.privateAllOccupancy =   [
                    Constants.Gym.Name.WhiteBldg : "\(whiteBldgOccupancyPercentage)",
                    Constants.Gym.Name.RecHall : "\(recHallOccupancyPercentage)",
                    Constants.Gym.Name.IMBldg : "\(imBldgOccupancyPercentage)"
                                            ]
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        print("KRIS: The GeoFire Database Reference for Pokefinder is = \(geoFireRef)")
        
        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
    }
    
    deinit
    {
        
    }
    
    func configureDatabase()
    {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
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
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, Constants.Map.Distance.SpanHeight, Constants.Map.Distance.SpanWidth)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        _ = geoFire.query(with: coordinateRegion)
        
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location
        {
            if !mapHasCenteredOnce
            {
                centerMapOnLocation(location: location)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoIdentifier = Constants.Map.Annotation.IdentifierGym
        var annotationView: MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self)
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.Map.Annotation.IdentifierUser)
            annotationView?.image = UIImage(named: "210")
        }
        else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier)
        {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        }
        else
        {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? GymAnnotation
        {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "200")
            let button = UIButton()
            button.frame = Constants.Map.Annotation.ButtonFrame
            button.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = button
        }
        return annotationView
    }
    
    //MARK: Spotting and Tagging Gyms
    
    func createSighting(for location: CLLocation)
    {
        switch gymChoiceSelected
        {
        case 1: geoFire.setLocation(location, forKey: gymFirstChoiceLabel.text)
        case 2: geoFire.setLocation(location, forKey: gymSecondChoiceLabel.text)
        case 3: geoFire.setLocation(location, forKey: gymThirdChoiceLabel.text)
        default: displayAlert(self, title: Constants.Alert.Title.GymNotSelected, message: Constants.Alert.Message.GymNotSelected)
        }
        
    }
    
    func showSightingsOnMap(location: CLLocation)
    {
        let circleQuery = geoFire!.query(at: location, withRadius: Constants.Map.GeoFire.QueryRadius)
        _ = circleQuery?.observe(.keyEntered, with: { (key, location) in
            if let key = key, let location = location
            {
                //self.geoFire.removeKey(key)
                let message = "\(Gym.allOccupancy[key]!) % Full."
                let anno = GymAnnotation(coordinate: location.coordinate, gymName: key, message: message)
                print("KRIS: \(key) Gym is located at latitude: \(location.coordinate.latitude) and longitude: \(location.coordinate.longitude) ")
                self.mapView.addAnnotation(anno)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool)
    {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showSightingsOnMap(location: location)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? GymAnnotation
        {
            var place: MKPlacemark!
            if #available(iOS 10.0, *)
            {
                place = MKPlacemark(coordinate: anno.coordinate)
            }
            else
            {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            let destination = MKMapItem(placemark: place)
            destination.name = Constants.Map.PlaceMark.DestinationNameToGym
            let regionDistance: CLLocationDistance = Constants.Map.Distance.RegionDistance
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            let options = [
                            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
                            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
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
