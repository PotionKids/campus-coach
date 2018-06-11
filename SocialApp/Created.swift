//
//  Created.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/7/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

protocol Creatable: StudentInitiatable, Ending, FirebaseRequestIDable, Pushable
{
    var privateForGym:      String!         { get set }
    var forGym:             String          { get }
    var gym:                Gym             { get }
    var timeIntervalOfLife: TimeInterval    { get }
    var lengthOfLife:       String          { get }
    
    init    ()
    
    init    (
        internallyWithFirebaseRID
        firebaseRID:    String,
        byStudent:      String,
        withName
        fullName:       String,
        forGymWith
        gymName:        String
            )
    init?   (
        withFirebaseRID
        firebaseRID:    String,
        fromData
        data:           AnyDictionary
            )
    init?   (
        fromData
        data:           AnyDictionary
            )
}
extension Creatable
{
    var firebaseID: String
    {
        return firebaseRID
    }

    var forGym: String
    {
        return privateForGym
    }
    var gym: Gym
    {
        return Gym(withNameOf: forGym)
    }
    var timeIntervalOfLife: TimeInterval
    {
        return intervalCalculator(start: atDateAndTime, end: endedAtDateAndTime)
    }
    var lengthOfLife: String
    {
        return componentsFormatter.string(from: timeIntervalOfLife)!
    }
    
    func push()
    {
        pushValuesToFirebase(forKeys: firebaseKeys, at: requestCreatedRef)
    }
    
    static var keys: KeysType
    {
        return Constants.Protocols.Creatable.keys
    }
}

class Created: Creatable
{
    static var setObject:   Firebase.Object!    = Firebase.Object   .none
    static var setChildOf:  Firebase.Object!    = Firebase.Object   .requests
    static var setChild:    Firebase.Child!     = Firebase.Child    .created
    
    var privateOrNot:       String!             = YesOrNo.Yes       .string
    var privateHasEnded:    String!             = YesOrNo.No        .string
    var privateForGym:      String!             = Building.White    .name
    var privateByStudent:   String!             = Constants.DataService.User.DefaultFirebaseUID
    var privateFullName:    String!             = Constants.DataService.User.DefaultUserName
    var privateAtTime:      String!
    var privateEndedAtTime: String!
    var privateFirebaseRID: String!
    
    required init()
    {
        self.privateAtTime                      = timeStamp().stampNanoseconds
        self.privateFirebaseRID                 = self.privateAtTime
        self.privateEndedAtTime                 = self.privateAtTime
    }
    
    required convenience init   (
        internallyWithFirebaseRID
        firebaseRID:        String,
        byStudent:          String,
        withName
        fullName:           String,
        forGymWith
        gymName:            String
                                )
    {
        self.init()
        self.privateFirebaseRID                 = firebaseRID
        self.privateAtTime                      = firebaseRID
        self.privateEndedAtTime                 = firebaseRID
        self.privateByStudent                   = byStudent
        self.privateFullName                    = fullName
        self.privateHasEnded                    = YesOrNo.No.string
        self.privateEndedAtTime                 = firebaseRID
        self.privateFirebaseRID                 = firebaseRID
        self.privateForGym                      = gymName
    }
    
    required convenience init?  (
        withFirebaseRID
        firebaseRID:    String,
        fromData
        data:           AnyDictionary
                                )
    {
        guard   let atTime                      =
                data[Constants.Protocols.HappenedType         .atTime       ] as? String,
                let byStudent                   =
                data[Constants.Protocols.StudentInitiatable   .byStudent    ] as? String,
                let fullName                    =
                data[Constants.Protocols.Nameable             .fullName     ] as? String,
                let hasEnded                    =
                data[Constants.Protocols.Ending               .hasEnded     ] as? String,
                let endedAtTime                 =
                data[Constants.Protocols.Ending               .endedAtTime  ] as? String,
                let firebaseRID                 =
                data[Constants.Protocols.FirebaseRequestIDable.firebaseRID  ] as? String,
                let forGym                      =
                data[Constants.Protocols.Creatable            .forGym       ] as? String
        else
        {
            return nil
        }
        self.init   (
                internallyWithFirebaseRID:  firebaseRID,
                byStudent:                  byStudent,
                withName:                   fullName,
                forGymWith:                 forGym
                    )
        self.privateAtTime                      = atTime
        self.privateHasEnded                    = hasEnded
        self.privateEndedAtTime                 = endedAtTime
    }
    
    required convenience init?  (
        fromData
        data:           AnyDictionary
                                )
    {
        guard   let firebaseRID                 =
                data[Constants.Protocols.FirebaseRequestIDable.firebaseRID  ] as? String
        else
        {
                return nil
        }
        self.init   (
                withFirebaseRID:    firebaseRID,
                fromData:           data
                    )
    }
}
