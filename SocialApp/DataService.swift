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

extension RawRepresentable
{
    var description: String
    {
        return "\(rawValue)"
    }
    var string: String
    {
        return "\(rawValue)"
    }
    var objectKey: String
    {
        return "\(rawValue)"
    }
    var key: String
    {
        return "\(rawValue)"
    }
    var rootNode: String
    {
        return "\(rawValue)"
    }
    var node: String
    {
        return "\(rawValue)"
    }
    var subNode: String
    {
        return "\(rawValue)"
    }
    var DatabaseReference: FIRDatabaseReference
    {
        return FirebaseBaseURL.child(rootNode)
    }
}

struct Firebase
{
    enum Object: String
    {
        case users
        case coaches
        case locations
        case requests
    }
    static let Users:       Object = .users
    static let Coaches:     Object = .coaches
    static let Locations:   Object = .locations
    static let Requests:    Object = .requests
}

class DataService
{
    static let ds = DataService()
    
    private var RefBasePrivate = FirebaseBaseURL
    
    var refBase: FIRDatabaseReference
    {
        return RefBasePrivate
    }
    
    func createFirebaseObject(object: Firebase.Object, instanceID: String, data: FirebaseData)
    {
        object.DatabaseReference.child(instanceID).updateChildValues(data)
    }
}

extension String
{
    var firebaseUserRef: FIRDatabaseReference
    {
        return Firebase.Object.users.DatabaseReference.child(self)
    }
    var firebaseCoachRef: FIRDatabaseReference
    {
        return Firebase.Object.coaches.DatabaseReference.child(self)
    }
    var firebaseLocationRef: FIRDatabaseReference
    {
        return Firebase.Object.locations.DatabaseReference.child(self)
    }
    var firebaseRequestRef: FIRDatabaseReference
    {
        return Firebase.Object.requests.DatabaseReference.child(self)
    }
}

/*
extension String
{
    var firebaseAllUsersRef: FIRDatabaseReference
    {
        return FirebaseAllUsersURL.child(self)
    }
    var firebaseStudentRef: FIRDatabaseReference
    {
        return FirebaseStudentsURL.child(self)
    }
    
    var firebaseCoachRef: FIRDatabaseReference
    {
        return FirebaseCoachesURL.child(self)
    }
    
    var firebaseLocationRef: FIRDatabaseReference
    {
        return FirebaseLocationsURL.child(self)
    }
    
    var firebaseRequestRef: FIRDatabaseReference
    {
        return FirebaseRequestsURL.child(self)
    }
    
    var requestCreatedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestCreatedBase.key)
    }
    
    var requestAcceptedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestAcceptedBase.key)
    }
    
    var requestCommunicatedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestCommunicatedBase.key)
    }
    
    var requestServiceRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestServiceBase.key)
    }
    
    var requestPayedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestPayedBase.key)
    }
    
    var requestReviewedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestReviewedBase.key)
    }
    
    var requestTimeRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestTimeBase.key)
    }
    
    func getRequestCreatedRefAt(subNode: Firebase.Object.Requests.Created) -> FIRDatabaseReference
    {
        return requestCreatedRef.child(subNode.key)
    }
    
    func getRequestAcceptedRefAt(subNode: Firebase.Object.Requests.Accepted) -> FIRDatabaseReference
    {
        return requestAcceptedRef.child(subNode.key)
    }
    
    func getRequestCommunicatedRefAt(subNode: Firebase.Object.Requests.Communicated) -> FIRDatabaseReference
    {
        return requestCommunicatedRef.child(subNode.key)
    }
    
    func getRequestServiceRefAt(subNode: Firebase.Object.Requests.Service) -> FIRDatabaseReference
    {
        return requestServiceRef.child(subNode.key)
    }
    
    func getRequestPayedRefAt(subNode: Firebase.Object.Requests.Payed) -> FIRDatabaseReference
    {
        return requestPayedRef.child(subNode.key)
    }
    
    func getRequestReviewedRefAt(subNode: Firebase.Object.Requests.Reviewed) -> FIRDatabaseReference
    {
        return requestReviewedRef.child(subNode.key)
    }
    
    func getRequestTimeRefAt(subNode: Firebase.Object.Requests.Time) -> FIRDatabaseReference
    {
        return requestTimeRef.child(subNode.key)
    }
}
*/
