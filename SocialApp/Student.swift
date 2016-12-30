//
//  Student.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/22/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

protocol StudentType: UserType, RevieweeArchivable {}
extension StudentType
{
    static var keys: KeysType
    {
        return Constants.Protocols.StudentType.keys
    }
}
class Student: StudentType
{
    static var setObject        : Firebase.Object!  = Firebase.Object.students
    static var setChildOf       : Firebase.Object!  = Firebase.Object.none
    static var setChild         : Firebase.Child!   = Firebase.Child.none
    
    var privateFirebaseUID:     String!             = Constants.Literal.Empty
    var privateIsCoach:         String!             = YesOrNo.None.string
    var privateProvider:        String!             = Constants.Literal.Empty
    var privateLoggedInAtTime:  String!
    var privateFacebookUID:     String!             = Constants.DataService.User.DefaultFacebookUID
    var privateFullName:        String!             = Constants.DataService.User.DefaultUserName
    var privateEmail:           String!             = Constants.DataService.User.DefaultEmail
    var privateCell:            String!             = Constants.DataService.User.DefaultCell
    var privateFirebaseRID:     String!             = Constants.Literal.Empty
    {
        willSet
        {
            privateRequests = "\(requests) \(newValue)"
        }
    }
    var privateRequests:        String!
    var privateFirebaseUIDs:    String! = Constants.DataService.User.DefaultFirebaseUID
    var privateRating:          String! = Constants.DataService.User.DefaultRating.string
    var privateRatings:         String! = Constants.DataService.User.DefaultRating.string
    var privateReviews:         String! = Constants.Literal.Empty
    
    required init()
    {
        self.privateLoggedInAtTime  = timeStamp().stampNanoseconds
        self.privateIsCoach         = IsCoach.no.string
    }
    
    required convenience init   (
        internallyWithFirebaseUID
        firebaseUID:    String,
        whoIsACoachOrNot
        isCoach:        String,
        withProvider
        provider:       String,
        whoLoggedInAt
        loggedInAtTime: String,
        withFacebookUID
        facebookUID:    String,
        whoseFullNameIs
        fullName:       String,
        andEmailIs
        email:          String,
        andCellNumberIs
        cell:           String,
        withActiveRequestWithFirebaseRID
        firebaseRID:    String,
        withPastRequests
        requests:       String,
        andHasRatedOrBeenRatedBy
        firebaseUIDs:   String,
        withAnAverageRatingOf
        rating:         String,
        withAllRatings
        ratings:        String,
        andAllReviews
        reviews:        String
        )
    {
        self.init()
        self.privateFirebaseUID         = firebaseUID
        self.privateIsCoach             = isCoach
        self.privateProvider            = provider
        self.privateLoggedInAtTime      = loggedInAtTime
        self.privateFacebookUID         = facebookUID
        self.privateFullName            = fullName
        self.privateEmail               = email
        self.privateCell                = cell
        self.privateFirebaseRID         = firebaseRID
        self.privateRequests            = requests
        self.privateFirebaseUIDs        = firebaseUIDs
        self.privateRating              = rating
        self.privateRatings             = ratings
        self.privateReviews             = reviews
        if isCoach.bool!
        {
            print("KRIS: The data being used to initialize is a coach's data. Please check and rectify the error.")
        }
    }
    
    required convenience init?  (
        fromUserData
        data:   AnyDictionary
        )
    {
        guard   let firebaseUID = data[Constants.Protocols.FirebaseUserIDable       .firebaseUID]       as? String,
            let isCoach     = data[Constants.Protocols.CoachTaggable            .isCoach]           as? String,
            let provider    = data[Constants.Protocols.ProviderSpecifiable      .provider]          as? String,
            let logInTime   = data[Constants.Protocols.LoginTimeStampable       .loggedInAtTime]    as? String,
            let facebookUID = data[Constants.Protocols.FacebookUserIDable       .facebookUID]       as? String,
            let fullName    = data[Constants.Protocols.Nameable                 .fullName]          as? String,
            let email       = data[Constants.Protocols.Emailable                .email]             as? String,
            let cell        = data[Constants.Protocols.Textable                 .cell]              as? String,
            let firebaseRID = data[Constants.Protocols.FirebaseRequestIDable    .firebaseRID]       as? String,
            let requests    = data[Constants.Protocols.RequestArchivable        .requests]          as? String,
            let userIDs     = data[Constants.Protocols.FirebaseUIDListType      .firebaseUIDs]
                as? String,
            let rating      = data[Constants.Protocols.RatingArchivable         .rating]            as? String,
            let ratings     = data[Constants.Protocols.RatingArchivable         .ratings]           as? String,
            let reviews     = data[Constants.Protocols.ReviewArchivable         .reviews]           as? String
            else
        {
            return nil
        }
        self.init   (
            internallyWithFirebaseUID:          firebaseUID,
            whoIsACoachOrNot:                   isCoach,
            withProvider:                       provider,
            whoLoggedInAt:                      logInTime,
            withFacebookUID:                    facebookUID,
            whoseFullNameIs:                    fullName,
            andEmailIs:                         email,
            andCellNumberIs:                    cell,
            withActiveRequestWithFirebaseRID:   firebaseRID,
            withPastRequests:                   requests,
            andHasRatedOrBeenRatedBy:           userIDs,
            withAnAverageRatingOf:              rating,
            withAllRatings:                     ratings,
            andAllReviews:                      reviews
        )
    }
    
//    required convenience init? (fromServerWithFirebaseUID firebaseUID: String, forUserWhoIsACoachOrNot isCoach: Bool)
//    {
//        var data = [Key : Value]()
//        if isCoach
//        {
//            data = fetchFirebaseObject(from: firebaseUID.firebaseCoachRef)
//            print("KRIS: Coach Data from Firebase = \(data)")
//        }
//        else
//        {
//            data = fetchFirebaseObject(from: firebaseUID.firebaseStudentRef)
//            print("KRIS: Student Data from Firebase = \(data)")
//            
//        }
//        self.init   (
//            fromUserData:   data
//        )
//    }
}
