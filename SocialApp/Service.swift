//
//  Service.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/7/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase


protocol ActivityType: Starting, Ending, TimeIntervalCalculable, FirebaseRequestIDable, Pushable
{
    var timeInterval:   TimeInterval    { get }
    var duration:       String          { get }
    
    init    ()
    
    init    (
        internallyWithFirebaseRID
        firebaseRID:    String,
        startedAtTime:  String,
        hasEnded:       String,
        endedAtTime:    String
    )
    
//    init?   (
//        fromServerWithFirebaseRID
//        firebaseRID:    String
//    )
    
}
extension ActivityType
{
    var firebaseID: String
    {
        return firebaseRID
    }
    
    var timeInterval: TimeInterval
    {
        return intervalCalculator(start: startedAtDateAndTime, end: endedAtDateAndTime)
    }
    var duration: String
    {
        return componentsFormatter.string(from: timeInterval)!
    }
    
    func push()
    {
        pushValuesToFirebase(forKeys: Self.keys.firebase, at: requestServiceRef)
    }
    
    static var keys: KeysType
    {
        return Constants.Protocols.ActivityType.keys
    }
}

class Service: ActivityType
{
    static var setObject:              Firebase.Object!    = Firebase.Object   .none
    static var setChildOf:             Firebase.Object!    = Firebase.Object   .requests
    static var setChild:               Firebase.Child!     = Firebase.Child    .service
    
    var privateHasStarted:      String!             = YesOrNo.Yes.string
    var privateStartedAtTime:   String!
    var privateHasEnded:        String!             = YesOrNo.No.string
    var privateEndedAtTime:     String!
    var privateFirebaseRID:     String!
    
    required init               ()
    {
        self.privateStartedAtTime   = timeStamp().stampNanoseconds
        self.privateEndedAtTime     = self.privateStartedAtTime
        self.privateFirebaseRID     = self.privateStartedAtTime
    }
    
    required convenience init   (
        internallyWithFirebaseRID
        firebaseRID:    String,
        startedAtTime:  String,
        hasEnded:       String = YesOrNo.No.string,
        endedAtTime:    String
        )
    {
        self.init()
        self.privateStartedAtTime   = startedAtTime
        self.privateHasEnded        = hasEnded
        self.privateEndedAtTime     = endedAtTime
        self.privateFirebaseRID     = firebaseRID
    }
    
//    required convenience init?   (
//        fromServerWithFirebaseRID
//        firebaseRID:    String
//        )
//    {
//        let data            = fetchFirebaseObject(from: firebaseRID.requestServiceRef)
//        guard   let startedAtTime   = data[Constants.Protocols.Starting .startedAtTime] as? String,
//            let hasEnded        = data[Constants.Protocols.Ending   .hasEnded]      as? String,
//            let endedAtTime     = data[Constants.Protocols.Ending   .endedAtTime]   as? String
//            else
//        {
//            return nil
//        }
//        self.init   (
//            internallyWithFirebaseRID:  firebaseRID,
//            startedAtTime:              startedAtTime,
//            hasEnded:                   hasEnded,
//            endedAtTime:                endedAtTime
//        )
//    }
}
