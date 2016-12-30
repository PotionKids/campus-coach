//
//  Accepted.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/7/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

protocol Acceptable: CoachInitiatable, FirebaseRequestIDable, Pushable
{
    var privateAndIsAtTheGym:   String!         { get set }
    var privateAndTimeToReach:  String!         { get set }
    
    var andIsAtTheGym:          String          { get }
    var andTimeToReach:         String          { get }
    
    var atTheGym:               Bool            { get }
    var timeIntervalToReach:    TimeInterval    { get }
    
    init    ()
    
    init    (
        internallyWithFirebaseRID
        firebaseRID:    String,
        byCoach:        String,
        withName
        fullName:       String,
        whoIsAtTheGym
        andIsAtTheGym:  String,
        andWillTake
        andTimeToReach: String
    )
    
    init?  (
        withFirebaseRID
        firebaseRID:    String,
        fromData
        data:           AnyDictionary
            )
    
    init?   (
        fromData
        data:           AnyDictionary
            )
    
//    init?   (
//        fromServerWithFirebaseRID
//        firebaseRID:    String
//            )
}
extension Acceptable
{
    var firebaseID: String
    {
        return firebaseRID
    }
    
    var andIsAtTheGym: String
    {
        return privateAndIsAtTheGym
    }
    var andTimeToReach: String
    {
        return privateAndTimeToReach
    }
    var atTheGym: Bool
    {
        return andIsAtTheGym.bool!
    }
    var timeIntervalToReach: TimeInterval
    {
        let times = DateAndTime.fromArrayOneStandardFormat  (
            ofStrings:
            [
                Constants.Calendar.Date.ReferenceTime_mm_ss,
                andTimeToReach
            ],
            withStandardFormat: .TimeToReach
            )!
        return intervalCalculator(start: times[0], end: times[1])
    }
    
    func push()
    {
        pushValuesToFirebase(forKeys: Self.keys.firebase, at: requestAcceptedRef)
    }
    
    static var keys: KeysType
    {
        return Constants.Protocols.Acceptable.keys
    }
}

class Accepted: Acceptable
{
    static var setObject:              Firebase.Object!    = Firebase.Object   .none
    static var setChildOf:             Firebase.Object!    = Firebase.Object   .requests
    static var setChild:               Firebase.Child!     = Firebase.Child    .accepted
    
    var privateOrNot:           String!             = YesOrNo.Yes.string
    var privateAtTime:          String!
    var privateByCoach:         String!             = Constants.DataService.User.DefaultFirebaseUID
    var privateFullName:        String!             = Constants.DataService.User.DefaultUserName
    var privateFirebaseRID:     String!
    var privateAndIsAtTheGym:   String!             = YesOrNo.Yes.string
    var privateAndTimeToReach:  String!             = Constants.Calendar.Date.ReferenceTime_mm_ss
    
    required init()
    {
        self.privateAtTime      = timeStamp().stampNanoseconds
        self.privateFirebaseRID = self.privateAtTime
    }
    
    required convenience init   (
        internallyWithFirebaseRID
        firebaseRID:    String,
        byCoach:        String,
        withName
        fullName:       String,
        whoIsAtTheGym
        andIsAtTheGym:  String = YesOrNo.Yes.string,
        andWillTake
        andTimeToReach: String = Constants.Calendar.Date.ReferenceTime_mm_ss
                                )
    {
        self.init()
        self.privateFirebaseRID     = firebaseRID
        self.privateByCoach         = byCoach
        self.privateFullName        = fullName
        self.privateAndIsAtTheGym   = andIsAtTheGym
        self.privateAndTimeToReach  = andTimeToReach
    }
    
    required convenience init?  (
        withFirebaseRID
        firebaseRID:    String,
        fromData
        data:           AnyDictionary
                                )
    {
        guard   let atTime      = data[Constants.Protocols.HappenedType.atTime]             as? String,
                let byCoach     = data[Constants.Protocols.CoachInitiatable.byCoach]        as? String,
                let fullName    = data[Constants.Protocols.Nameable.fullName]               as? String,
                let _ = data[Constants.Protocols.CoachInitiatable.afterTimeOf]    as? String,
                let isAtTheGym  = data[Constants.Protocols.Acceptable.andIsAtTheGym]        as? String,
                let timeToReach = data[Constants.Protocols.Acceptable.andTimeToReach]       as? String
        else
        {
            return nil
        }
        self.init   (
            internallyWithFirebaseRID:  firebaseRID,
            byCoach:                    byCoach,
            withName:                   fullName,
            whoIsAtTheGym:              isAtTheGym,
            andWillTake:                timeToReach
                    )
        self.privateAtTime  = atTime
    }
    
    required convenience init?  (
        fromData
        data:           AnyDictionary
        )
    {
        guard let firebaseRID = data[Constants.Protocols.FirebaseRequestIDable.firebaseRID] as? String
            else
        {
            return nil
        }
        self.init   (
            withFirebaseRID:    firebaseRID,
            fromData:           data
        )
    }
    
//    required convenience init?  (
//        fromServerWithFirebaseRID
//        firebaseRID:    String
//        )
//    {
//        let data        = fetchFirebaseObject(from: firebaseRID.requestAcceptedRef)
//        self.init   (
//            withFirebaseRID:    firebaseRID,
//            fromData:           data
//                    )
//    }
}
