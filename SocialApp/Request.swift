//
//  Request.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/8/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

internal var selfRequest = Request()

protocol RequestType: RequestTimeSequenceType, FirebaseRequestIDable, Pushable
{
    var privateCreated:         Created!            { get set }
    var privateAccepted:        Accepted?           { get set }
    var privateCommunicated:    Communicated?       { get set }
    var privateService:         Service?            { get set }
    var privatePayed:           Payed?              { get set }
    var privateReviewed:        Reviewed?           { get set }
    
    var created:                Created             { get }
    var accepted:               Accepted?           { get }
    var communicated:           Communicated?       { get }
    var service:                Service?            { get }
    var payed:                  Payed?              { get }
    var reviewed:               Reviewed?           { get }
    
    init    ()
    init    (
        withFirebaseRID
        firebaseRID:    String,
        byStudent:      String,
        forGym:         String
            )
    init    (
        byStudent:      String,
        forGym:         String
            )
    init    (
        internallyWithFirebaseRID
        firebaseRID:    String,
        created:        Created,
        accepted:       Accepted?,
        communicated:   Communicated?,
        service:        Service?,
        payed:          Payed?,
        reviewed:       Reviewed?
    )
    init?   (
        fromServerWithFirebaseRID
        firebaseRID:    String
        )
    
    func push()
    
    mutating func accept(byCoach: String, atTheGym: String, timeToReach: String)
    mutating func communicate(byCallOrText: String, byCoachOrNot: String)
    mutating func start()
    mutating func stop()
    mutating func pay(withTip tip: String)
    mutating func review(withRating rating: String, withReview review: String)
}
extension RequestType
{
    var created: Created
    {
        return privateCreated
    }
    var accepted: Accepted?
    {
        return privateAccepted
    }
    var communicated: Communicated?
    {
        return privateCommunicated
    }
    var service: Service?
    {
        return privateService
    }
    var payed: Payed?
    {
        return privatePayed
    }
    var reviewed: Reviewed?
    {
        return privateReviewed
    }
    
    var intervalToCreate: TimeInterval
    {
        return intervalCalculator(start: created.student.logInDateAndTime, end: created.atDateAndTime)
    }
    var intervalToAccept: TimeInterval
    {
        return intervalCalculator(start: created.atDateAndTime, end: accepted?.atDateAndTime)
    }
    var intervalToCommunicate: TimeInterval
    {
        return intervalCalculator(start: accepted?.atDateAndTime, end: communicated?.atDateAndTimes[0])
    }
    var intervalToStart: TimeInterval
    {
        if let communicated = communicated
        {
            return intervalCalculator(start: communicated.atDateAndTimes[0], end: service?.startedAtDateAndTime)
        }
        else
        {
            return intervalCalculator(start: accepted?.atDateAndTime, end: service?.startedAtDateAndTime)
        }
    }
    var intervalToPay: TimeInterval
    {
        return intervalCalculator(start: service?.endedAtDateAndTime, end: payed?.atDateAndTime)
    }
    var intervalToReview: TimeInterval
    {
        return intervalCalculator(start: payed?.atDateAndTime, end: reviewed?.atDateAndTime)
    }
    
    func push()
    {
        created         .push()
        accepted?       .push()
        communicated?   .push()
        service?        .push()
        payed?          .push()
        reviewed?       .push()
        requestTimeRef  .updateChildValues(time)
    }
    
    mutating func accept(byCoach: String, atTheGym: String, timeToReach: String)
    {
        self.privateAccepted                = Accepted(internallyWithFirebaseRID: firebaseRID, byCoach: byCoach, whoIsAtTheGym: atTheGym, andWillTake: timeToReach)
    }
    mutating func communicate(byCallOrText: String, byCoachOrNot: String)
    {
        if communicated != nil
        {
            privateCommunicated!.stampCommunication(byCallOrText: byCallOrText, byCoachOrNot: byCoachOrNot)
        }
        else
        {
            let atTime                      = timeStamp().stampNanoseconds
            self.privateCommunicated        = Communicated(internallyWithFirebaseRID: firebaseRID, communicatedAtTimes: atTime, usingCallOrText: byCallOrText, initiatedByCoachOrNot: byCoachOrNot)
        }
    }
    mutating func start()
    {
        let atTime                          = timeStamp().stampNanoseconds
        self.privateService                 = Service(internallyWithFirebaseRID: firebaseRID, startedAtTime: atTime, endedAtTime: atTime)
    }
    mutating func stop()
    {
        let atTime                          = timeStamp().stampNanoseconds
        self.service?.privateHasEnded       = YesOrNo.Yes.string
        self.service?.privateEndedAtTime    = atTime
    }
    mutating func pay(withTip tip: String)
    {
        let atTime                          = timeStamp().stampNanoseconds
        self.privatePayed                   = Payed(internallyWithFirebaseRID: firebaseRID, service: service!, tip: tip)
    }
    mutating func review(withRating rating: String, withReview review: String)
    {
        let atTime                              = timeStamp().stampNanoseconds
        self.privateReviewed                    =
            Reviewed(internallyWithFirebaseRID: firebaseRID, atTime: atTime, rating: rating, review: review)
        self.privateCreated.privateEndedAtTime  = atTime
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.RequestType.keys
    }
}

class Request: RequestType
{
    var privateFirebaseRID:     String!
    var privateCreated:         Created!
    var privateAccepted:        Accepted?       = nil
    var privateCommunicated:    Communicated?   = nil
    var privateService:         Service?        = nil
    var privatePayed:           Payed?          = nil
    var privateReviewed:        Reviewed?       = nil
    
    required init()
    {
        self.privateFirebaseRID = timeStamp().stampNanoseconds
        self.privateCreated     = Created()
    }
    
    required convenience init   (
        withFirebaseRID
        firebaseRID: String,
        byStudent: String,
        forGym: String
                                )
    {
        self.init()
        self.privateFirebaseRID = firebaseRID
        self.privateCreated     = Created   (
            internallyWithFirebaseRID:  firebaseRID,
            byStudent:                  byStudent,
            forGymWith:                 forGym
        )
    }
    
    required convenience init   (
        byStudent:      String,
        forGym:         String
                                )
    {
        self.init()
        self.privateCreated     =   Created (
                                    internallyWithFirebaseRID:  privateFirebaseRID,
                                    byStudent:                  byStudent,
                                    forGymWith:                 forGym
                                            )
    }
    
    required convenience init   (
        internallyWithFirebaseRID
        firebaseRID:    String,
        created:        Created,
        accepted:       Accepted?,
        communicated:   Communicated?,
        service:        Service?,
        payed:          Payed?,
        reviewed:       Reviewed?
                                )
    {
        self.init()
        self.privateCreated         = created
        self.privateAccepted        = accepted
        self.privateCommunicated    = communicated
        self.privateService         = service
        self.privatePayed           = payed
        self.privateReviewed        = reviewed
        self.privateFirebaseRID     = firebaseRID
    }
    
    required convenience init?  (
        fromServerWithFirebaseRID
        firebaseRID:    String
                                )
    {
        guard   let created         =   Created       (fromServerWithFirebaseRID: firebaseRID)
            else
        {
            return nil
        }
        let accepted        =   Accepted      (fromServerWithFirebaseRID: firebaseRID)
        let communicated    =   Communicated  (fromServerWithFirebaseRID: firebaseRID)
        let service         =   Service       (fromServerWithFirebaseRID: firebaseRID)
        let payed           =   Payed         (fromServerWithFirebaseRID: firebaseRID)
        let reviewed        =   Reviewed      (fromServerWithFirebaseRID: firebaseRID)
        self.init   (
            internallyWithFirebaseRID:  firebaseRID,
            created:                    created,
            accepted:                   accepted,
            communicated:               communicated,
            service:                    service,
            payed:                      payed,
            reviewed:                   reviewed
        )
    }
}
