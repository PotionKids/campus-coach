//
//  Service.swift
//  SocialApp
//
//  Created by Kris Rajendren on Nov/15/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

class Service: ActivityType
{
    var privateHasStarted:      String! = YesOrNo.Yes.string
    var privateStartedAtTime:   String!
    var privateHasEnded:        String! = YesOrNo.No.string
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
    
    required convenience init?   (
        fromServerWithFirebaseRID
        firebaseRID:    String
                                )
    {
                let data            = fetchFirebaseObject(from: firebaseRID.requestServiceRef)
        guard   let startedAtTime   = data[Constants.Protocols.Starting .startedAtTime] as? String,
                let hasEnded        = data[Constants.Protocols.Ending   .hasEnded]      as? String,
                let endedAtTime     = data[Constants.Protocols.Ending   .endedAtTime]   as? String
        else
        {
            return nil
        }
        self.init   (
            internallyWithFirebaseRID:  firebaseRID,
            startedAtTime:              startedAtTime,
            hasEnded:                   hasEnded,
            endedAtTime:                endedAtTime
                    )
    }
}









