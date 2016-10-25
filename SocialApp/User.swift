////
////  User.swift
////  SocialApp
////
////  Created by Kris Rajendren on Oct/22/16.
////  Copyright © 2016 Campus Coach. All rights reserved.
////
//
//import Foundation
//typealias FirebaseRawData = [String : Any]
//
//protocol UserType
//{
//    var privateFirebaseID: String? { get set }
//    var privateFacebookID: String? { get set }
//    
//    var privateFullName: String? { get set }
//    
//    var privateCell: String? { get set }
//    var privateImageURL: String? { get set }
//    
//    var privateLocationID: String? { get set }
//    
//    var firebaseID: String? { get }
//    var facebookID: String? { get }
//    
//    var fullName: String? { get }
//    var firstName: String? { get }
//    
//    var cell: String? { get }
//    var imageURL: String? { get }
//    
//    var locationID: String? { get }
//
//    init()
//    
//    func parseFirstName() -> String?
//}
//
//extension UserType
//{
//    func parseFirstName() -> String?
//    {
//        let names = self.fullName?.components(separatedBy: NSCharacterSet.whitespaces)
//        if let names = names { return names.first }
//        else { return nil }
//    }
//    
//    init(firebaseID: String? = nil, facebookID: String? = nil, name: String?, cell: String?, imageURL: String?)
//    {
//        self.init()
//        self.privateFirebaseID = firebaseID
//        self.privateFacebookID = facebookID
//        self.privateFullName = name
//        self.privateCell = cell
//        self.privateImageURL = imageURL
//    }
//    
//    init(firebaseID: String, profile: FirebaseRawData)
//    {
//        let facebookID = profile[Constants.Facebook.Key.UID] as? String
//        let fullName = profile[Constants.Facebook.Key.Name] as? String
//        let cell = profile[Constants.DataService.User.Cell] as? String
//        let imageURL = profile[Constants.Facebook.Key.ImageURLString] as? String
//        self.init(firebaseID: firebaseID, facebookID: facebookID, name: fullName, cell: cell, imageURL: imageURL)
//    }
//}
//
//class User: UserType
//{
//    internal var privateFirebaseID: String?
//    internal var privateFacebookID: String?
//    
//    internal var privateFullName: String?
//    internal var privateCell: String?
//    internal var privateImageURL: String?
//    
//    internal var privateLocationID: String?
//    
//    var firebaseID: String?
//    {
//        return privateFirebaseID
//    }
//    var facebookID: String?
//    {
//        return privateFacebookID
//    }
//    
//    var fullName: String?
//    {
//        return privateFullName
//    }
//    var firstName: String?
//    {
//        return parseFirstName()
//    }
//    var cell: String?
//    {
//        return privateCell
//    }
//    var imageURL: String?
//    {
//        return privateImageURL
//    }
//    
//    var locationID: String?
//    {
//        return privateLocationID
//    }
//    
//    required init() {}
//}
