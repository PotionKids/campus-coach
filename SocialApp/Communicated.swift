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
    init    ()
    
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

extension Communicable
{
    var firebaseID: String
    {
        return firebaseRID
    }
    
    func push()
    {
        pushValuesToFirebase(forKeys: Self.keys.firebase, at: requestCommunicatedRef)
    }
    
    mutating func stampCommunication(byCallOrText: String, byCoachOrNot: String)
    {
        let atTime                                  = timeStamp().stampNanoseconds
        self.privateAtTimes                         = "\(self.atTimes) \(atTime)"
        self.privateByCallOrText                    = "\(self.byCallOrText) \(byCallOrText)"
        self.privateByCoachOrNot                    = "\(self.byCoachOrNot) \(byCoachOrNot)"
    }
    
    static var keys: KeysType
    {
        return Constants.Protocols.Communicable.keys
    }
}

class Communicated: Communicable
{
    static var setObject:       Firebase.Object!    = Firebase.Object   .none
    static var setChildOf:      Firebase.Object!    = Firebase.Object   .requests
    static var setChild:        Firebase.Child!     = Firebase.Child    .communicated
    
    var privateOrNot:           String!             = YesOrNo.Yes.string
    var privateAtTimes:         String!
    var privateByCallOrText:    String!             = CallOrText.none.string
    var privateByCoachOrNot:    String!             = YesOrNo.No.string
    var privateFirebaseRID:     String!             = Constants.Literal.Empty
    
    required init()
    {
        self.privateAtTimes                         = timeStamp().stampNanoseconds
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
        self.privateFirebaseRID                     = firebaseRID
        self.privateAtTimes                         = atTimes
        self.privateByCallOrText                    = byCallOrText
        self.privateByCoachOrNot                    = byCoachOrNot
    }
    
    required convenience init?  (
        withFirebaseRID
        firebaseRID:    String,
        fromData
        data:           AnyDictionary
                                )
    {
        guard   let atTimes                         =
                data[Constants.Protocols.HappenedSequenceType.atTimes           ] as? String,
                let byCallOrText                    =
                data[Constants.Protocols.CallOrTextSequenceType.byCallOrText    ] as? String,
                let byCoachOrNot                    =
                data[Constants.Protocols.CoachOrNotSequenceType.byCoachOrNot    ] as? String
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
    
    required convenience init?  (
        fromData
        data:           AnyDictionary
                                )
    {
        guard   let firebaseRID =
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
