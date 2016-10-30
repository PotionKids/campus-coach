//
//  User.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/22/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
typealias FirebaseRawData = [String : Any]

protocol UserType: StringDictionarizable
{
    var privateFirebaseID: String! { get set }
    var privateCell: String! { get set }
    var privateFacebookID: String? { get set }
    var privateFullName: String? { get set }
    
    var privateImageURL: String? { get set }
    
    
    var firebaseID: String { get }
    var facebookID: String? { get }
    var fullName: String? { get }
    var firstName: String? { get }
    var cell: String { get }
    var imageURL: String? { get }
    
    var location: CLLocation? { get set }
    
    var requestID: String? { get set }

    init()
    
    func parseFirstName() -> String?
    
    func createFirebaseData() -> FirebaseData
}

extension UserType
{
    func parseFirstName() -> String?
    {
        let names = self.fullName?.components(separatedBy: NSCharacterSet.whitespaces)
        if let names = names { return names.first }
        else { return nil }
    }
    
    func createFirebaseData() -> FirebaseData
    {
        var firebaseUserData: FirebaseData = [:]
        firebaseUserData.updateValue(self.firebaseID, forKey: Constants.DataService.User.UID)
        firebaseUserData.updateValue(self.cell, forKey: Constants.DataService.User.Cell)
        if let facebookID = self.facebookID
        {
            firebaseUserData.updateValue(facebookID, forKey: Constants.DataService.User.FacebookID)
        }
        if let fullName = self.fullName
        {
            firebaseUserData.updateValue(fullName, forKey: Constants.DataService.User.Name)
        }
        if let imageURL = self.imageURL
        {
            firebaseUserData.updateValue(imageURL, forKey: Constants.DataService.User.ImageURLString)
        }
        if let location = self.location
        {
            firebaseUserData.updateValue("\(location.coordinate.latitude)", forKey: Constants.DataService.User.Latitude)
            firebaseUserData.updateValue("\(location.coordinate.longitude)", forKey: Constants.DataService.User.Longitude)
        }
        if let requestID = self.requestID
        {
            firebaseUserData.updateValue(requestID, forKey: Constants.DataService.User.RequestID)
        }
    }
    
    init(firebaseID: String, facebookID: String? = nil, name: String? = nil, cell: String, imageURL: String? = nil, location: CLLocation? = nil, requestID: String? = nil)
    {
        self.init()
        self.privateFirebaseID = firebaseID
        self.privateFacebookID = facebookID
        self.privateFullName = name
        self.privateCell = cell
        self.privateImageURL = imageURL
        self.location = location
        self.requestID = requestID
    }
    
    init(firebaseID: String, profile: FirebaseRawData)
    {
        let facebookID = profile[Constants.Facebook.Key.UID] as? String
        let fullName = profile[Constants.DataService.User.Name] as? String
        let cell = profile[Constants.DataService.User.Cell] as? String
        let imageURL = profile[Constants.DataService.User.ImageURLString] as? String
        let location = profile[Constants.DataService.User.Location] as? [String : String]
        var clLocation: CLLocation? = nil
        if let location = location
        {
            let latitude = CLLocationDegrees(location[Constants.DataService.User.Latitude]!)
            let longitude = CLLocationDegrees(location[Constants.DataService.User.Longitude]!)
            clLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        }
        let requestID = profile[Constants.DataService.User.RequestID] as? String
        
        self.init(firebaseID: firebaseID, facebookID: facebookID, name: fullName, cell: cell, imageURL: imageURL, location: clLocation, requestID: requestID)
    }
}

class User: UserType
{
    internal var privateFirebaseID: String?
    internal var privateFacebookID: String?
    internal var privateFullName: String?
    internal var privateCell: String?
    internal var privateImageURL: String?
    
    var firebaseID: String?
    {
        return privateFirebaseID
    }
    var facebookID: String?
    {
        return privateFacebookID
    }
    
    var fullName: String?
    {
        return privateFullName
    }
    var firstName: String?
    {
        return parseFirstName()
    }
    var cell: String?
    {
        return privateCell
    }
    var imageURL: String?
    {
        return privateImageURL
    }
    
    var location: CLLocation? = nil
    
    var requestID: String? = nil
    
    required init() {}
}
