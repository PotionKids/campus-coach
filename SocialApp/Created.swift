//
//  Created.swift
//  SocialApp
//
//  Created by Kris Rajendren on Nov/14/16.
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
        forGymWith
            gymName:        String
            )
    init?   (
        fromServerWithFirebaseRID
            firebaseRID:    String
            )
}
extension Creatable
{
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
        pushValuesToFirebase(forKeys: keys.firebase, at: requestCreatedRef)
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.Creatable.keys
    }
}

class Created: Creatable
{
    var privateOrNot:       String! = YesOrNo.Yes.string
    var privateAtTime:      String!
    var privateByStudent:   String! = Constants.DataService.User.DefaultFirebaseUID
    var privateHasEnded:    String! = YesOrNo.No.string
    var privateEndedAtTime: String!
    var privateFirebaseRID: String!
    var privateForGym:      String! = Building.White.name
    
    required init()
    {
        self.privateAtTime      = timeStamp().stampNanoseconds
        self.privateFirebaseRID = self.privateAtTime
        self.privateEndedAtTime = self.privateAtTime
    }
    
    required convenience init    (
        internallyWithFirebaseRID
        firebaseRID:        String,
        byStudent:          String,
        forGymWith
        gymName:            String
                                )
    {
        self.init()
        self.privateByStudent   = byStudent
        self.privateHasEnded    = YesOrNo.No.string
        self.privateEndedAtTime = firebaseRID
        self.privateFirebaseRID = firebaseRID
        self.privateForGym      = gymName
    }
    
    required convenience init?  (
        fromServerWithFirebaseRID
            firebaseRID:    String
                                )
    {
                let data        = fetchFirebaseObject(from: firebaseRID         .requestCreatedRef)
        guard   let atTime      = data[Constants.Protocols.HappenedType         .atTime]        as? String,
                let byStudent   = data[Constants.Protocols.StudentInitiatable   .byStudent]     as? String,
                let hasEnded    = data[Constants.Protocols.Ending               .hasEnded]      as? String,
                let endedAtTime = data[Constants.Protocols.Ending               .endedAtTime]   as? String,
                let firebaseRID = data[Constants.Protocols.FirebaseRequestIDable.firebaseRID]   as? String,
                let forGym      = data[Constants.Protocols.Creatable            .forGym]        as? String
        else
        {
            return nil
        }
        self.init   (
            internallyWithFirebaseRID:  firebaseRID,
            byStudent:                  byStudent,
            forGymWith:                 forGym
                    )
    }
}






