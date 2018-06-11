//
//  Request.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/8/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

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
        withFirebaseRID firebaseRID:    String,
                        byStudent:      String,
                        withName:       String,
                        forGym:         String
            )
    init    (
                        byStudent:      String,
                        withName:       String,
                        forGym:         String
            )
    init    (
                        created:        Created,
                        accepted:       Accepted?,
                        communicated:   Communicated?,
                        service:        Service?,
                        payed:          Payed?,
                        reviewed:       Reviewed?
            )
    
    func push()
    
    mutating func acceptByCoach (
        withFirebaseUID firebaseUID:    String,
        withName        name:           String,
        whoIsAtTheGym   atTheGym:       String,
        andWillTake     timeToReach:    String
                                )
    mutating func accept        ()
    mutating func communicate   (
                        byCallOrText:   String,
                        byCoachOrNot:   String
                                )
    mutating func call          (
                        byCoachOrNot:   String
                                )
    mutating func text          (
                        byCoachOrNot:   String
                                )
    mutating func callStudent   ()
    mutating func callCoach     ()
    mutating func textStudent   ()
    mutating func textCoach     ()
    
    mutating func start         ()
    mutating func stop          ()
    mutating func pay           (
        withTip         tip:            String
                                )
    mutating func review        (
        withRating      rating:         String,
        withReview      review:         String
                                )
}
extension RequestType
{
    static var firebaseKeys: Keys
    {
        return Constants.Protocols.RequestType.keys.firebase
    }
    var firebaseID: String
    {
        return firebaseRID
    }
    
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
    
    mutating func acceptByCoach (
        withFirebaseUID firebaseUID:    String,
        withName        name:           String,
        whoIsAtTheGym   atTheGym:       String,
        andWillTake     timeToReach:    String
                                )
    {
        self.privateAccepted                        = Accepted  (
                                                internallyWithFirebaseRID:  firebaseRID     ,
                                                byCoach:                    firebaseUID     ,
                                                withName:                   name            ,
                                                whoIsAtTheGym:              atTheGym        ,
                                                andWillTake:                timeToReach
                                                                )
    }

    mutating func accept()
    {
        let user        = Persistence.shared.user!
        let firebaseUID = user.firebaseUID
        let name        = user.fullName
        
        acceptByCoach   (
            withFirebaseUID:    firebaseUID,
            withName:           name,
            whoIsAtTheGym:      YesOrNo.Yes.string,
            andWillTake:        Constants.Calendar.Date.ReferenceTime_mm_ss
                        )
    }
    
    mutating func communicate   (
                        byCallOrText:   String,
                        byCoachOrNot:   String
                                )
    {
        if communicated.isNotNil
        {
            privateCommunicated!.stampCommunication (
                        byCallOrText:   byCallOrText,
                        byCoachOrNot:   byCoachOrNot
                                                    )
        }
        else
        {
            let atTime                              = timeStamp().stampNanoseconds
            self.privateCommunicated                = Communicated  (
                                                internallyWithFirebaseRID:  firebaseRID ,
                                                communicatedAtTimes:        atTime      ,
                                                usingCallOrText:            byCallOrText,
                                                initiatedByCoachOrNot:      byCoachOrNot
                                                                    )
        }
    }
    
    mutating func call          (
        byCoachOrNot:   String
                                )
    {
        communicate             (
                        byCallOrText:   CallOrText.call.string,
                        byCoachOrNot:   byCoachOrNot
                                )
    }
    mutating func text          (
        byCoachOrNot:   String
                                )
    {
        communicate             (
                        byCallOrText:   CallOrText  .text   .string,
                        byCoachOrNot:   byCoachOrNot
                                )
    }
    mutating func callStudent   ()
    {
        call                    (
                        byCoachOrNot:   IsCoach     .yes    .string
                                )
    }
    mutating func callCoach     ()
    {
        call                    (
                        byCoachOrNot:   IsCoach     .no     .string
                                )
    }
    mutating func textStudent   ()
    {
        text                    (
                        byCoachOrNot:   IsCoach     .yes    .string
                                )
    }
    mutating func textCoach     ()
    {
        text                    (
                        byCoachOrNot:   IsCoach     .no     .string
                                )
    }
    
    mutating func start         ()
    {
        let atTime                                  = timeStamp().stampNanoseconds
        self.privateService                         = Service   (
                                                internallyWithFirebaseRID:  firebaseRID ,
                                                startedAtTime:              atTime      ,
                                                endedAtTime:                atTime
                                                                )
    }
    mutating func stop          ()
    {
        let atTime                                  = timeStamp().stampNanoseconds
        self.service?.privateHasEnded               = YesOrNo.Yes.string
        self.service?.privateEndedAtTime            = atTime
    }
    
    mutating func pay           (
            withTip     tip:            String
                                )
    {
        self.privatePayed                           = Payed     (
                                                internallyWithFirebaseRID:  firebaseRID ,
                                                service:                    service!    ,
                                                tip:                        tip
                                                                )
    }
    
    mutating func review        (
            withRating  rating:         String,
            withReview  review:         String
                                )
    {
        let atTime                                  = timeStamp().stampNanoseconds
        self.privateReviewed                        = Reviewed  (
                                                internallyWithFirebaseRID:  firebaseRID ,
                                                atTime:                     atTime      ,
                                                rating:                     rating      ,
                                                review:                     review
                                                                )
        self.privateCreated.privateEndedAtTime      = atTime
    }
    
    static var keys: KeysType
    {
        return Constants.Protocols.RequestType.keys
    }
}

class Request: RequestType
{
    static var setObject:       Firebase.Object!    = Firebase.Object   .requests
    static var setChildOf:      Firebase.Object!    = Firebase.Object   .none
    static var setChild:        Firebase.Child!     = Firebase.Child    .none
    
    var privateFirebaseRID:     String!
    var privateCreated:         Created!
    var privateAccepted:        Accepted?           = nil
    var privateCommunicated:    Communicated?       = nil
    var privateService:         Service?            = nil
    var privatePayed:           Payed?              = nil
    var privateReviewed:        Reviewed?           = nil
    
    required init()
    {
        self.privateFirebaseRID                     = Constants.Literal.Empty
        self.privateCreated                         = Created()
    }
    
    required convenience init   (
        withFirebaseRID
        firebaseRID:    String,
        byStudent:      String,
        withName:       String,
        forGym:         String
                                )
    {
        self.init()
        self.privateFirebaseRID                     = firebaseRID
        self.privateCreated                         = Created   (
                                                internallyWithFirebaseRID:  firebaseRID,
                                                byStudent:                  byStudent,
                                                withName:                   withName,
                                                forGymWith:                 forGym
                                                                )
    }
    
    required convenience init   (
        byStudent:      String,
        withName:       String,
        forGym:         String
                                )
    {
        self.init()
        self.privateCreated                         = Created   (
                                                internallyWithFirebaseRID:  firebaseRID,
                                                byStudent:                  byStudent,
                                                withName:                   withName,
                                                forGymWith:                 forGym
                                                                )
    }
    
    required convenience init   (
        created:        Created,
        accepted:       Accepted?                   = nil,
        communicated:   Communicated?               = nil,
        service:        Service?                    = nil,
        payed:          Payed?                      = nil,
        reviewed:       Reviewed?                   = nil
                                )
    {
        self.init()
        self.privateFirebaseRID                     = created.firebaseRID
        self.privateCreated                         = created
        self.privateAccepted                        = accepted
        self.privateCommunicated                    = communicated
        self.privateService                         = service
        self.privatePayed                           = payed
        self.privateReviewed                        = reviewed
    }
}
