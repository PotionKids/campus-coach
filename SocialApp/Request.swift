//
//  Request.swift
//  TableVCPractice
//
//  Created by Kris Rajendren on Oct/23/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation

protocol RequestType
{
    var privateGymName: String! { get set }
    var privateUser: User! { get set }
    
    var gymName: String { get }
    var user: User { get }
    var userID: String? { get }
    var requestID: String { get }
    
    var accepted: Bool { get }
    var coachID: String? { get }
    var coach: User? { get }
    
    var coachAction: String! { get }
    
    init()
    
    func accept()
}

extension RequestType
{
    func accept(coachID: String)
    {
        self.accepted = true
        self.coachID = coachID
        Firebase.Coaches.DatabaseReference.child(coachID).observe(.value, with:
        { (snapshot) in
            if let coachProfile = snapshot.value as? FirebaseRawData
            {
                self.coach = User(firebaseID: coachID, profile: coachProfile)
            }
        })
    }
    
    init(gymName: String, user: Student)
    {
        self.init()
        self.privateGymName = gymName
        self.user = user
        self.requestID = user.firebaseID
        
        //DataService.ds.createFirebaseObject(object: .Coaches, instanceID: id, data: userData)
    }
    
    init(requestID: String, requestData: FirebaseRawData)
    {
        self.requestID = requestID
        let userID = requestData[Constants.DataService.User.UID]
    }
}

class Request: RequestType
{
    private var privateGymName: String!
    private var privateUserID: String!
    
    
    
}
