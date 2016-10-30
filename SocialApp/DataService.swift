//
//  DataService.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/17/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

typealias FirebaseData = [String : String]

let FirebaseBaseURL = FIRDatabase.database().reference()

struct Firebase
{
    enum Object: String
    {
        case Base
        case Users
        case Coaches
        case Locations
        case Requests
        
        var ObjectKey: String
        {
            switch self
            {
            case .Base:
                return Constants.DataService.Firebase.Base
            case .Users:
                return Constants.DataService.Firebase.Users
            case .Coaches:
                return Constants.DataService.Firebase.Coaches
            case .Locations:
                return Constants.DataService.Firebase.Locations
            case .Requests:
                return Constants.DataService.Firebase.Requests
            }
        }
        
        var DatabaseReference: FIRDatabaseReference
        {
            switch self
            {
            case .Base:
                return FirebaseBaseURL
            case .Users:
                return FirebaseBaseURL.child(Firebase.Users.ObjectKey)
            case .Coaches:
                return FirebaseBaseURL.child(Firebase.Coaches.ObjectKey)
            case .Locations:
                return FirebaseBaseURL.child(Firebase.Locations.ObjectKey)
            case .Requests:
                return FirebaseBaseURL.child(Firebase.Requests.ObjectKey)
            }
        }
    }
    static let Base: Object = .Base
    static let Users: Object = .Users
    static let Coaches: Object = .Coaches
    static let Locations: Object = .Locations
    static let Requests: Object = .Requests
}

class DataService
{
    static let ds = DataService()
    
    private var RefBasePrivate = Firebase.Base.DatabaseReference
    
    var refBase: FIRDatabaseReference
    {
        return RefBasePrivate
    }
    
    func createFirebaseObject(object: Firebase.Object, instanceID: String, data: FirebaseData)
    {
        object.DatabaseReference.child(instanceID).updateChildValues(data)
    }
}
