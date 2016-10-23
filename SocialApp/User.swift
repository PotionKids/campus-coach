//
//  User.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/22/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
typealias FirebaseRawData = [String : Any]

protocol UserType
{
    var privateFirebaseID: String? { get set }
    var privateFacebookID: String? { get set }
    var privateFullName: String? { get set }
    var privateCell: String? { get set }
    var privateImageURL: String? { get set }
    
    var firebaseID: String? { get }
    var facebookID: String? { get }
    
    var fullName: String? { get }
    var firstName: String? { get }
    
    var cell: String? { get }
    var imageURL: String? { get }

    init()
    
    func parseFirstName() -> String?
}

extension UserType
{
    func parseFirstName() -> String?
    {
        let names = self.fullName?.components(separatedBy: NSCharacterSet.whitespaces)
        if let names = names { return names.first }
        else { return nil }
    }
    
    init(firebaseID: String? = nil, facebookID: String? = nil, name: String?, cell: String?, imageURL: String?)
    {
        self.init()
        self.privateFirebaseID = firebaseID
        self.privateFacebookID = facebookID
        self.privateFullName = name
        self.privateCell = cell
        self.privateImageURL = imageURL
    }
    
    init(firebaseID: String, profile: FirebaseRawData)
    {
//        self.privateFirebaseID = firebaseID
//        if let facebookID = profile[Constants.Facebook.Key.UID] as? String
//        {
//            self.privateFacebookID = facebookID
//        }
//        if let fullName = profile[Constants.Facebook.Key.Name] as? String
//        {
//            self.privateFullName = fullName
//        }
//        if let cell = profile[Constants.DataService.User.Cell] as? String
//        {
//            self.privateCell = cell
//        }
//        if let imageURL = profile[Constants.Facebook.Key.ImageURLString] as? String
//        {
//            self.privateImageURL = imageURL
//        }
        let facebookID = profile[Constants.Facebook.Key.UID] as? String
        let fullName = profile[Constants.Facebook.Key.Name] as? String
        let cell = profile[Constants.DataService.User.Cell] as? String
        let imageURL = profile[Constants.Facebook.Key.ImageURLString] as? String
        self.init(firebaseID: firebaseID, facebookID: facebookID, name: fullName, cell: cell, imageURL: imageURL)
    }
}
