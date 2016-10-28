//
//  Constants.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/15/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

//import UIKit
import MapKit

import Firebase

extension String
{
    func removeLast() -> String
    {
        var trimmed = self
        trimmed.remove(at: trimmed.index(before: trimmed.endIndex))
        return trimmed
    }
}

struct Constants {
    
    struct DataService
    {
        struct Firebase
        {
            static let BaseURL = FIRDatabase.database().reference()
            static let Provider = "firebase"
            static let Locations = "locations"
            static let Requests = "requests"
            static let Users = "users"
            static let Coaches = "coaches"
        }
        struct Mirror
        {
            static let Firebase = Constants.DataService.Firebase.Provider.capitalized
            static let Locations = Constants.DataService.Firebase.Locations.capitalized
            static let Requests = Constants.DataService.Firebase.Requests.capitalized
            static let Users = Constants.DataService.Firebase.Users.capitalized
            static let Coaches = Constants.DataService.Firebase.Coaches.capitalized
        }
        struct User
        {
            static let UID = Constants.Firebase.KeychainWrapper.KeyUID
            static let Location = Constants.DataService.Firebase.Locations.removeLast()
            static let Name = "name"
            static let Provider = "provider"
            static let Cell = "cellNumber"
            static let Email = Constants.Facebook.Key.Email
            static let Requests = Constants.DataService.Firebase.Requests
        }
    }
    
    struct Facebook
    {
        struct Profile
        {
            static let ImageURLPrefix = "https://graph.facebook.com/"
            static let ImageURLSuffix = "/picture?type=large&w‌ idth=1000&height=1000"
        }
        
        struct Key
        {
            static let Provider = "provider"
            static let Profile = "profile"
            static let Name = "name"
            static let Email = "email"
            static let UID = "facebookUID"
            static let ImageURLString = "imageURL"
        }
    }
    
    struct Firebase
    {
        struct KeychainWrapper
        {
            static let KeyUID = "uid"
        }
        struct Key
        {
            static let UID = "firebaseUID"
        }
    }
    
    struct SignUpVC
    {
        struct Segue
        {
            static let SignUpToSetGym = "SignUpToSetGym"
            static let SignUpToSetGymMap = "SignUpToSetGymMap"
            static let SignUpToSaveCellNumber = "SignUpToSaveCellNumber"
            static let SignUpToCoachRequests = "SignUpToCoachRequests"
        }
    }
    
    struct CoachRequestsVC
    {
        struct Segue
        {
            static let CoachRequestsToSignUp = "CoachRequestsToSignUp"
        }
        
        struct Cell
        {
            static let Request = "Request"
        }
    }
    
    struct SaveCellNumber
    {
        struct Segue
        {
            static let SaveCellNumberToSetGym = "SaveCellNumberToSetGym"
        }
    }
    
    struct ViewController
    {
        struct Segue
        {
            static let LogInToRiderOnMap = "ShowRiderOnMap"
            static let Logout = "Logout"
            static let LogInToDriverViewController = "ShowDriverViewController"
            static let SignUpToSetGym = "SignUpToSetGym"
            static let SetGymToSignIn = "SetGymToSignIn"
        }
    }
    
    struct SetGymVC
    {
        struct Segue
        {
            static let SetGymToSignIn = "SetGymMapToSignIn"
        }
    }
    
    struct RiderViewController
    {
        struct Segue
        {
            static let Logout = "Logout"
            static let Driver = Constants.ViewController.Segue.LogInToDriverViewController
        }
    }
    
    struct DriverViewController
    {
        struct Segue
        {
            static let Driver = Constants.ViewController.Segue.LogInToDriverViewController
            static let Logout = "LogOutDriver"
            static let ShowUserLocation = "ShowUserLocation"
        }
        struct TableView
        {
            static let DefaultNumberOfSections: Int = 1
            static let DefaultNumberOfRows: Int = 4
            static let DefaultCellTextLabelText = "Test"
            static let DefaultCellReuseIdentifier = "Cell"
        }
    }
    
    struct String
    {
        static let Empty = ""
    }
    struct Button
    {
        struct Title
        {
            static let LogIn = "Log In"
            static let SignUp = "Sign Up"
            static let SwitchToLogIn = "Switch to Log In"
            static let SwitchToSignUp = "Switch to Sign Up"
        }
    }
    struct Alert
    {
        struct Title
        {
            static let OK = "OK"
            static let Continue = "Continue"
            static let Cancel = "Cancel"
            static let SignUp = "Sign Up"
            static let LogIn = "Log In"
            static let SignUpFailed = "Sign Up Failed."
            static let LogInFailed = "Log In Failed."
            static let EmptyUserName = "User Name Not Captured"
            static let EmptyPassword = "Password Not Captured"
            static let EmptyUserNameAndPassword = "User Name and Password Not Captured"
            static let EmptyCellNumber = "Cell Number Not Captured"
            static let SuccessfullyCalledCoach = "Coach Assigned"
            static let FailedToCallCoach = "Coach Unreachable."
            static let CurrentLocationNotFound = "Current Location Undetected"
            static let GymNotSelected = "No Gym Selection Made"
            
        }
        struct Message
        {
            static let SignUpFailed = "Sorry, the sign up attempt was not successful."
            static let LogInFailed = "Sorry, the log in attempt was not successful."
            static let EmptyUserName = "How would you like to be called? Please enter a username of your choice."
            static let EmptyPassword = "Your account security is our priority. Please enter a secure password."
            static let EmptyUserNameAndPassword = "Your account security is our priority. Please enter a user name and password."
            static let EmptyCellNumber = "We require your cell phone for your coach to be able to reach you. Please enter a valid Cell Number."
            static let SuccessfullyCalledCoach = Constants.Display.Message.SuccessfullyCalledCoach
            static let FailedToCallCoach = Constants.Display.Message.FailedToCallCoach
            static let CurrentLocationNotFound = "Your current location could not be detected. Please try again in a few moments."
            static let GymNotSelected = "No gym has been selected for sighting. Please select the gym you want to spot on the map."
        }
    }
    struct Key
    {
        static let IsDriver = "isDriver"
        static let IsUser = "isUser"
        static let Error = "error"
        static let LogIn = "Log In"
        static let SignUp = "Sign Up"
    }
    struct Error
    {
        struct Message
        {
            static let TryAgain = "Please, try again later."
            static let DataRetrieval = "Sorry, the data could not be retrieved from the specified URL."
        }
    }
    struct Display
    {
        struct Message
        {
            static let LogInSuccessful = "You logged in successfully."
            static let SignUpSuccessful = "You signed up successfully."
            static let SuccessfullyCalledCoach = "Your coach is on the way."
            static let FailedToCallCoach = "Sorry, a coach could not be reached at this point."
            static let NoRequestsFound = "No user requests found at the moment."
            static let UserLocationNotConvertibleToCLLocation = "User location could not be converted to a CLLocationCoordinate2D object."
        }
    }
    struct Mirror
    {
        struct Key
        {
            static let Alert = "Alert"
            static let Key = "Key"
            static let Button = "Button"
            static let Title = "Title"
            static let Message = "Message"
            static let Error = "Error"
            static let Display = "Display"
            static let LogIn = Constants.Key.LogIn
            static let LogInSuccessful = "logInSuccessful"
            static let SignUpSuccessful = "signUpSuccessful"
            
            static let Gym = "Gym"
            static let Web = "Web"
            static let Scraping = "Scraping"
            static let CURLscraping = "CURLscraping"
        }
        
        struct Web
        {
            struct Key
            {
                static let Link = "Link"
            }
            
            struct Link
            {
                static let PSUfitnessScraping = "PSUfitnessScraping"
                static let PSUfitnessCURLscraping = "PSUfitnessCURLscraping"
            }
        }
        
        struct Scraping
        {
            struct Key
            {
                
            }
        }
        
        struct CURLscraping
        {
            struct Key
            {
                static let HeadersPSUFitness = "HeadersPSUFitness"
                static let HeaderValue = "HeaderValue"
            }
            
            struct Header {
                static let Accept = "Accept"
                static let XRequestedWith = "X-Requested-With"
                static let Connection = "Connection"
                static let Referer = "Referer"
            }
        }
        
        struct Gym
        {
            struct Key
            {
                static let Name = "Name"
                static let Statistic = "Statistic"
                static let Parsing = "Parsing"
                static let Synonyms = "Synonyms"
            }
            
            struct Name
            {
                static let WhiteBuilding = "WhiteBuilding"
                static let WhiteBldg = "WhiteBldg"
                static let RecHall = "RecHall"
                static let IMBuilding = "IMBuilding"
                static let IMBldg = "IMBldg"
                static let HepperFitness = "HepperFitness"
                static let IMWeightRoom = "IMWeightRoom"
                
            }
            
            struct Statistic
            {
                static let CurrentVal = Constants.Gym.Parsing.CurrentVal
                static let FullCapacityWaiTime = Constants.Gym.Parsing.FullCapacityWaiTime
                static let GUID = Constants.Gym.Parsing.GUID
                static let LocationDescription = Constants.Gym.Parsing.LocationDescription
                static let MaxVal = Constants.Gym.Parsing.MaxVal
            }
            
            struct Parsing
            {
                static let GymDataSeparator = "GymDataSeparator"
                static let GymParameterKeys = "GymParameterKeys"
            }
        }
    }
    
    struct Map
    {
        struct Distance
        {
            static let SpanWidth = 1000.00
            static let SpanHeight = 1000.00
            static let RegionDistance: CLLocationDistance = 1000.00
        }
        struct Location
        {
            static let BaseInitializer = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        struct Annotation
        {
            static let TitleForCurrentLocation = "Current Location"
            static let TitleForUserLocation = "You"
            static let TitleForCoachLocation = "Coach"
            
            static let IdentifierGym = "gym"
            static let IdentifierUser = "user"
            static let IdentifierCoach = "coach"
            static let ButtonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        
        struct PlaceMark
        {
            static let DestinationNameToGym = "Gym"
        }
        
        struct Display
        {
            static let DefaultLatitudeScaling = 2.00
            static let DefaultLongitudeScaling = 2.00
            static let DefaultLatitudeOffsetDegress = 0.005
            static let DefaultLongitudeOffsetDegrees = 0.005
            static let DefaultLatitudeOffsetMeters = 500.00
            static let DefaultLongitudeOffsetMeters = 500.00
        }
        
        struct Trax
        {
            static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
            static let AnnotationViewReuseIdentifier = "waypoint"
            static let ShowImageSegue = "Show Image"
            static let EditUserWaypoint = "Edit Waypoint"
            static let Dropped = "Dropped"
        }
        
        struct GeoFire
        {
            static let QueryRadius = 2.5
        }
    }
    
    struct Conversions
    {
        struct Distance
        {
            static let MetersInKilometers: Double = 1000.00
        }
    }
    struct Parse
    {
        struct Object
        {
            static let UserRequest = "UserRequest"
            static let CoachLocation = "CoachLocation"
            static let UserName = Constants.Parse.Properties.UserName
            static let Location = Constants.Parse.Properties.Location
        }
        struct Properties
        {
            static let UserName = "username"
            static let Location = "Location"
            static let CoachLocation = Constants.Parse.UserRequest.CoachLocation
        }
        struct UserRequest
        {
            static let UserName = Constants.Parse.Object.UserName
            static let Location = Constants.Parse.Object.Location
            static let CoachResponded = "coachResponded"
            static let CoachLocation = "coachLocation"
        }
        struct CoachLocation
        {
            static let UserName = Constants.Parse.Properties.UserName
            static let Location = Constants.Parse.Properties.Location
        }
        struct Query
        {
            static let DefaultLimit: Int = 10
        }
    }
    struct Web
    {
        struct Link
        {
            static let PSUfitnessScraping = "https://studentaffairs.psu.edu/CurrentFitnessAttendance/"
            static let PSUfitnessCURLscraping = "https://studentaffairs.psu.edu/CurrentFitnessAttendance/api/CounterAPI"
        }
    }
    
    struct Scraping
    {
        
    }
    
    /*
     
     "Accept": "application/json, text/javascript, /; q=0.01",
     "X-Requested-With": "XMLHttpRequest",
     "Connection": "keep-alive",
     "Referer": "https://studentaffairs.psu.edu/CurrentFitnessAttendance/"
     
     */
    
    struct CURLscraping
    {
        struct Header
        {
            static let Accept = "Accept"
            static let XRequestedWith = "X-Requested-With"
            static let Connection = "Connection"
            static let Referer = "Referer"
        }
        
        struct HeaderValue {
            static let Accept = "application/json, text/javascript, /; q=0.01"
            static let XRequestedWith = "XMLHttpRequest"
            static let Connection = "keep-alive"
            static let RefererPSUFitness = "https://studentaffairs.psu.edu/CurrentFitnessAttendance/"
        }
    }
    
    struct Parsing
    {
        
    }
    
    struct Gym
    {
        struct Statistic
        {
            static let CurrentVal = "Occupancy"
            static let FullCapacityWaiTime = "Wait Time"
            static let GUID = "GUID"
            static let LocationDescription = "Gym"
            static let MaxVal = "Capacity"
            static let numberOfParameters: Int = 5
        }
        
        struct Parsing
        {
            static let GymDataSeparator = " = "
            static let CurrentVal = "CurrentVal"
            static let FullCapacityWaiTime = "FullCapacityWaiTime"
            static let GUID = "GUID"
            static let LocationDescription = "LocationDescription"
            static let MaxVal = "MaxVal"        }
        
        struct Name
        {
            static let WhiteBuilding = "White Building"
            static let WhiteBldg = "White Bldg"
            static let RecHall = "Rec Hall"
            static let IMBuilding = "IM Building"
            static let IMBldg = "IM Bldg"
            static let HepperFitness = "Hepper Fitness Center"
            static let IMWeightRoom = "IM Weight Room"
        }
    }
}

let ConstantsDictionary: [String : [String : [String : String]]] = [
    Constants.Mirror.Key.Gym : [
        Constants.Mirror.Gym.Key.Statistic : [
            Constants.Mirror.Gym.Statistic.CurrentVal : Constants.Gym.Statistic.CurrentVal,
            Constants.Mirror.Gym.Statistic.FullCapacityWaiTime : Constants.Gym.Statistic.FullCapacityWaiTime,
            Constants.Mirror.Gym.Statistic.GUID : Constants.Gym.Statistic.GUID,
            Constants.Mirror.Gym.Statistic.LocationDescription : Constants.Gym.Statistic.LocationDescription,
            Constants.Mirror.Gym.Statistic.MaxVal : Constants.Gym.Statistic.MaxVal
        ],
        Constants.Mirror.Gym.Key.Synonyms : [
            Constants.Gym.Name.WhiteBuilding : Constants.Gym.Name.WhiteBldg,
            Constants.Gym.Name.HepperFitness : Constants.Gym.Name.RecHall,
            Constants.Gym.Name.IMWeightRoom : Constants.Gym.Name.IMBldg
        ]
    ],
    Constants.Mirror.Key.CURLscraping : [
        Constants.Mirror.CURLscraping.Key.HeadersPSUFitness : [
            Constants.Mirror.CURLscraping.Header.Accept : Constants.CURLscraping.HeaderValue.Accept,
            Constants.Mirror.CURLscraping.Header.XRequestedWith : Constants.CURLscraping.HeaderValue.XRequestedWith,
            Constants.Mirror.CURLscraping.Header.Connection : Constants.CURLscraping.HeaderValue.Connection,
            Constants.Mirror.CURLscraping.Header.Referer: Constants.CURLscraping.HeaderValue.RefererPSUFitness
        ]
    ],
    Constants.Mirror.Key.Display: [
        Constants.Mirror.Key.Message: [
            Constants.Mirror.Key.LogInSuccessful: Constants.Display.Message.LogInSuccessful,
            Constants.Mirror.Key.SignUpSuccessful: Constants.Display.Message.SignUpSuccessful
        ]
    ]
]
