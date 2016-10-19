//
//  DataService.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/17/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

typealias FirebaseData = [String : String]

protocol DataServiceType
{
    associatedtype DataServiceClass
    static var ds: DataServiceClass { get }
    
    func createFirebaseDBUser(uid: String, userData: FirebaseData)
}

let FirebaseBaseURL = FIRDatabase.database().reference()
class DataService: DataServiceType
{
    typealias DataServiceClass = DataService
    static let ds = DataService()
    
    private var RefBasePrivate = FirebaseBaseURL
    private var RefLocationsPrivate = FirebaseBaseURL.child(Constants.DataService.Firebase.Locations)
    private var RefRequestsPrivate = FirebaseBaseURL.child(Constants.DataService.Firebase.Requests)
    private var RefUsersPrivate = FirebaseBaseURL.child(Constants.DataService.Firebase.Users)
    private var RefCoachesPrivate = FirebaseBaseURL.child(Constants.DataService.Firebase.Coaches)
    
    var refBase: FIRDatabaseReference
    {
        return RefBasePrivate
    }
    
    var refLocations: FIRDatabaseReference
    {
        return RefLocationsPrivate
    }
    
    var refRequests: FIRDatabaseReference
    {
        return RefRequestsPrivate
    }
    
    var refUsers: FIRDatabaseReference
    {
        return RefUsersPrivate
    }
    
    var refCoaches: FIRDatabaseReference
    {
        return RefCoachesPrivate
    }
    
    func createFirebaseDBUser(uid: String, userData: FirebaseData)
    {
        refUsers.child(uid).updateChildValues(userData)
    }
}
