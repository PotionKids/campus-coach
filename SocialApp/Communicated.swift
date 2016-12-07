//
//  Communicated.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/7/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

protocol Communicable: HappenedSequenceType, CallOrTextSequenceType, CoachOrNotSequenceType, FirebaseRequestIDable, Pushable
{
    init()
    
    init    (
        internallyWithFirebaseRID
        firebaseRID:    String,
        communicatedAtTimes
        atTimes:        String,
        usingCallOrText
        byCallOrText:   String,
        initiatedByCoachOrNot
        byCoachOrNot:   String
    )
    
    init?   (
        fromServerWithFirebaseRID
        firebaseRID:    String
    )
}

extension Communicable
{
    func push()
    {
        pushValuesToFirebase(forKeys: keys.firebase, at: requestCommunicatedRef)
    }
    
    mutating func stampCommunication(byCallOrText: String, byCoachOrNot: String)
    {
        let atTime                  = timeStamp().stampNanoseconds
        self.privateAtTimes         = "\(self.atTimes) \(atTime)"
        self.privateByCallOrText    = "\(self.byCallOrText) \(byCallOrText)"
        self.privateByCoachOrNot    = "\(self.byCoachOrNot) \(byCoachOrNot)"
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.Communicable.keys
    }
}

class Communicated: Communicable
{
    var privateOrNot:           String! = YesOrNo.Yes.string
    var privateAtTimes:         String!
    var privateByCallOrText:    String! = CallOrText.none.string
    var privateByCoachOrNot:    String! = YesOrNo.No.string
    var privateFirebaseRID:     String!
    
    required init()
    {
        self.privateAtTimes     = timeStamp().stampNanoseconds
        self.privateFirebaseRID = self.privateAtTimes
    }
    
    required convenience init   (
        internallyWithFirebaseRID
        firebaseRID:    String,
        communicatedAtTimes
        atTimes:        String,
        usingCallOrText
        byCallOrText:   String,
        initiatedByCoachOrNot
        byCoachOrNot:   String
        )
    {
        self.init()
        self.privateAtTimes         = atTimes
        self.privateByCallOrText    = byCallOrText
        self.privateByCoachOrNot    = byCoachOrNot
        self.privateFirebaseRID     = firebaseRID
    }
    
    required convenience init?  (
        fromServerWithFirebaseRID
        firebaseRID:    String
        )
    {
        let data            = fetchFirebaseObject(from: firebaseRID.requestCommunicatedRef)
        guard   let atTimes         = data[Constants.Protocols.HappenedSequenceType     .atTimes]       as? String,
            let byCallOrText    = data[Constants.Protocols.CallOrTextSequenceType   .byCallOrText]  as? String,
            let byCoachOrNot    = data[Constants.Protocols.CoachOrNotSequenceType   .byCoachOrNot]  as? String
            else
        {
            return nil
        }
        self.init   (
            internallyWithFirebaseRID:  firebaseRID,
            communicatedAtTimes:        atTimes,
            usingCallOrText:            byCallOrText,
            initiatedByCoachOrNot:      byCoachOrNot
        )
    }
}
