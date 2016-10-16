//
//  Constants.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/15/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit
import MapKit

struct Constants {
    struct ViewController
    {
        struct Segue
        {
            static let LogInToRiderOnMap = "ShowRiderOnMap"
            static let Logout = "Logout"
            static let LogInToDriverViewController = "ShowDriverViewController"
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
            static let SuccessfullyCalledCoach = "Coach Assigned"
            static let FailedToCallCoach = "Coach Unreachable."
            static let CurrentLocationNotFound = "Current Location Undetected"
        }
        struct Message
        {
            static let SignUpFailed = "Sorry, the sign up attempt was not successful."
            static let LogInFailed = "Sorry, the log in attempt was not successful."
            static let EmptyUserName = "How would you like to be called? Please enter a username of your choice."
            static let EmptyPassword = "Your account security is our priority. Please enter a secure password."
            static let EmptyUserNameAndPassword = "Your account security is our priority. Please enter a user name and password."
            static let SuccessfullyCalledCoach = Constants.Display.Message.SuccessfullyCalledCoach
            static let FailedToCallCoach = Constants.Display.Message.FailedToCallCoach
            static let CurrentLocationNotFound = "Your current location could not be detected. Please try again in a few moments."
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
        }
    }
    
    struct Map
    {
        struct Distance
        {
            static let SpanWidth = 1000.00
            static let SpanHeight = 1000.00
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
}


let ConstantsDict: [String: [String: [String: String]]] = [
    Constants.Mirror.Key.Display: [
        Constants.Mirror.Key.Message: [
            Constants.Mirror.Key.LogInSuccessful: Constants.Display.Message.LogInSuccessful,
            Constants.Mirror.Key.SignUpSuccessful: Constants.Display.Message.SignUpSuccessful
        ]
    ]
]