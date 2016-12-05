//
//  ServiceRequestActivityType.swift
//  SocialApp
//
//  Created by Kris Rajendren on Nov/5/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

//import Foundation
//import Firebase
//
//func timeStamp() -> DateAndTime
//{
//    return DateAndTime()
//}
//
//protocol CustomTimeStampable {}
//extension CustomTimeStampable
//{
//    mutating func timeStampEvent(occurred: inout Bool!, at date: DateAndTime? = nil, set internalDate: inout DateAndTime?)
//    {
//        occurred = true
//        if let date = date
//        {
//            internalDate = date
//        }
//        else
//        {
//            internalDate = timeStamp()
//        }
//    }
//}
//
//protocol TimeIntervalCalculable {}
//extension TimeIntervalCalculable: CustomTimeStampable
//{
//    func intervalCalculator(start: DateAndTime?, end: DateAndTime?) -> TimeInterval
//    {
//        guard let start = start, let end = end else { return 0.00 }
//        return end.date.timeIntervalSince(start.date)
//    }
//    
//    var componentsFormatter: DateComponentsFormatter
//    {
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        return formatter
//    }
//}
//
//protocol Fetchable {}
//extension Fetchable
//{
//    func fetchObjectFromFirebase() -> [Key : Value]
//    {
//        var result = [Key : Value]()
//        return result
//    }
//}
//
//protocol UserType
//{
//    var privateUserID:      String! { get set }
//    var privateIsCoach:     Bool!   { get set }
//    var privateName:        String! { get set }
//    var privateImageURL:    String! { get set }
//}
//
//extension UserType
//{
//    var userID:             String
//    {
//        return privateUserID
//    }
//    var isCoach:            Bool
//    {
//        return privateIsCoach
//    }
//    var name:               String
//    {
//        return privateName
//    }
//    var imageURL:           String
//    {
//        return privateImageURL
//    }
//    
//    func getFirebaseReference() -> FIRDatabaseReference
//    {
//        if isCoach
//        {
//            return FirebaseCoachesURL.child(userID)
//        }
//        else
//        {
//            return FirebaseUsersURL.child(userID)
//        }
//    }
//}
//
///*
// /*
// static let Base:                    Object = .Base
// static let Users:                   Object = .Users
// static let Coaches:                 Object = .Coaches
// static let Locations:               Object = .Locations
// static let Requests:                Object = .Requests
// */
// /*
// static let Created:                 Object = .Created
// static let Accepted:                Object = .Accepted
// static let Communicated:            Object = .Communicated
// static let Started:                 Object = .Started
// static let Stopped:                 Object = .Stopped
// static let Payed:                   Object = .Payed
// static let Reviewed:                Object = .Reviewed
// */
// /*
// static let HasBeenCreated:          Object = .HasBeenCreated
// static let CreatedByStudent:        Object = .CreatedByStudent
// static let CreatedAtTime:           Object = .CreatedAtTime
// static let TimeTakenToCreate:       Object = .TimeTakenToCreate
// static let CreatedForGym:           Object = .CreatedForGym
// static let StudentDistance:         Object = .StudentDistance
// static let HasEnded:                Object = .HasEnded
// static let EndedAtTime:             Object = .EndedAtTime
// static let LengthOfLife:            Object = .LengthOfLife
// */
// /*
// static let HasBeenAccepted:         Object = .HasBeenAccepted
// static let AcceptedByCoach:         Object = .AcceptedByCoach
// static let AcceptedAtTime:          Object = .AcceptedAtTime
// static let TimeTakenToAccept:       Object = .TimeTakenToAccept
// static let CoachDistance:           Object = .CoachDistance
// static let IsAtTheGym:              Object = .IsAtTheGym
// static let TimeToReachGym:          Object = .TimeToReachGym
// */
// /*
// static let HasCommunicated:         Object = .HasCommunicated
// static let TextedBy:                Object = .TextedBy
// static let TimeOfText:              Object = .TimeOfText
// static let CalledBy:                Object = .CalledBy
// static let TimeOfCall:              Object = .TimeOfCall
// */
// /*
// static let HasStarted:              Object = .HasStarted
// static let StartedAtTime:           Object = .StartedAtTime
// static let TimeTakenToStart:        Object = .TimeTakenToStart
// static let WasStartedOnTime:        Object = .WasStartedOnTime
// */
// /*
// static let HasBeenStopped:          Object = .HasBeenStopped
// static let StoppedAtTime:           Object = .StoppedAtTime
// static let TimeIntervalOfSession:   Object = .TimeIntervalOfSession
// static let Amount:                  Object = .Amount
// */
// /*
// static let HasBeenPayed:            Object = .HasBeenPayed
// static let PayedAtTime:             Object = .PayedAtTime
// static let TimeTakenToPay:          Object = .TimeTakenToPay
// static let Tip:                     Object = .Tip
// static let TotalPayed:              Object = .TotalPayed
// */
// /*
// static let HasBeenReviewed:         Object = .HasBeenReviewed
// static let ReviewedAtTime:          Object = .ReviewedAtTime
// static let TimeTakenToReview:       Object = .TimeTakenToReview
// static let Rating:                  Object = .Rating
// static let Review:                  Object = .Review
// */
//*/
//
///*
// /*
// var privateBase:                    Object = .Base
// var privateUsers:                   Object = .Users
// var privateCoaches:                 Object = .Coaches
// var privateLocations:               Object = .Locations
// var privateRequests:                Object = .Requests
// */
// /*
// var privateCreated:                 Object = .Created
// var privateAccepted:                Object = .Accepted
// var privateCommunicated:            Object = .Communicated
// var privateStarted:                 Object = .Started
// var privateStopped:                 Object = .Stopped
// var privatePayed:                   Object = .Payed
// var privateReviewed:                Object = .Reviewed
// */
// /*
// var privateHasBeenCreated:          Object = .HasBeenCreated
// var privateCreatedByStudent:        Object = .CreatedByStudent
// var privateCreatedAtTime:           Object = .CreatedAtTime
// var privateTimeTakenToCreate:       Object = .TimeTakenToCreate
// var privateCreatedForGym:           Object = .CreatedForGym
// var privateStudentDistance:         Object = .StudentDistance
// var privateHasEnded:                Object = .HasEnded
// var privateEndedAtTime:             Object = .EndedAtTime
// var privateLengthOfLife:            Object = .LengthOfLife
// */
// /*
// var privateHasBeenAccepted:         Object = .HasBeenAccepted
// var privateAcceptedByCoach:         Object = .AcceptedByCoach
// var privateAcceptedAtTime:          Object = .AcceptedAtTime
// var privateTimeTakenToAccept:       Object = .TimeTakenToAccept
// var privateCoachDistance:           Object = .CoachDistance
// var privateIsAtTheGym:              Object = .IsAtTheGym
// var privateTimeToReachGym:          Object = .TimeToReachGym
// */
// /*
// var privateHasCommunicated:         Object = .HasCommunicated
// var privateTextedBy:                Object = .TextedBy
// var privateTimeOfText:              Object = .TimeOfText
// var privateCalledBy:                Object = .CalledBy
// var privateTimeOfCall:              Object = .TimeOfCall
// */
// /*
// var privateHasStarted:              Object = .HasStarted
// var privateStartedAtTime:           Object = .StartedAtTime
// var privateTimeTakenToStart:        Object = .TimeTakenToStart
// var privateWasStartedOnTime:        Object = .WasStartedOnTime
// */
// /*
// var privateHasBeenStopped:          Object = .HasBeenStopped
// var privateStoppedAtTime:           Object = .StoppedAtTime
// var privateTimeIntervalOfSession:   Object = .TimeIntervalOfSession
// var privateAmount:                  Object = .Amount
// */
// /*
// var privateHasBeenPayed:            Object = .HasBeenPayed
// var privatePayedAtTime:             Object = .PayedAtTime
// var privateTimeTakenToPay:          Object = .TimeTakenToPay
// var privateTip:                     Object = .Tip
// var privateTotalPayed:              Object = .TotalPayed
// */
// /*
// var privateHasBeenReviewed:         Object = .HasBeenReviewed
// var privateReviewedAtTime:          Object = .ReviewedAtTime
// var privateTimeTakenToReview:       Object = .TimeTakenToReview
// var privateRating:                  Object = .Rating
// var privateReview:                  Object = .Review
// */
// */
//
///*
// /*
// var Base:                    Object = .Base
// var Users:                   Object = .Users
// var Coaches:                 Object = .Coaches
// var Locations:               Object = .Locations
// var Requests:                Object = .Requests
// */
// /*
// var Created:                 Object = .Created
// var Accepted:                Object = .Accepted
// var Communicated:            Object = .Communicated
// var Started:                 Object = .Started
// var Stopped:                 Object = .Stopped
// var Payed:                   Object = .Payed
// var Reviewed:                Object = .Reviewed
// */
// /*
// var HasBeenCreated:          Object = .HasBeenCreated
// var CreatedByStudent:        Object = .CreatedByStudent
// var CreatedAtTime:           Object = .CreatedAtTime
// var TimeTakenToCreate:       Object = .TimeTakenToCreate
// var CreatedForGym:           Object = .CreatedForGym
// var StudentDistance:         Object = .StudentDistance
// var HasEnded:                Object = .HasEnded
// var EndedAtTime:             Object = .EndedAtTime
// var LengthOfLife:            Object = .LengthOfLife
// */
// /*
// var HasBeenAccepted:         Object = .HasBeenAccepted
// var AcceptedByCoach:         Object = .AcceptedByCoach
// var AcceptedAtTime:          Object = .AcceptedAtTime
// var TimeTakenToAccept:       Object = .TimeTakenToAccept
// var CoachDistance:           Object = .CoachDistance
// var IsAtTheGym:              Object = .IsAtTheGym
// var TimeToReachGym:          Object = .TimeToReachGym
// */
// /*
// var HasCommunicated:         Object = .HasCommunicated
// var TextedBy:                Object = .TextedBy
// var TimeOfText:              Object = .TimeOfText
// var CalledBy:                Object = .CalledBy
// var TimeOfCall:              Object = .TimeOfCall
// */
// /*
// var HasStarted:              Object = .HasStarted
// var StartedAtTime:           Object = .StartedAtTime
// var TimeTakenToStart:        Object = .TimeTakenToStart
// var WasStartedOnTime:        Object = .WasStartedOnTime
// */
// /*
// var HasBeenStopped:          Object = .HasBeenStopped
// var StoppedAtTime:           Object = .StoppedAtTime
// var TimeIntervalOfSession:   Object = .TimeIntervalOfSession
// var Amount:                  Object = .Amount
// */
// /*
// var HasBeenPayed:            Object = .HasBeenPayed
// var PayedAtTime:             Object = .PayedAtTime
// var TimeTakenToPay:          Object = .TimeTakenToPay
// var Tip:                     Object = .Tip
// var TotalPayed:              Object = .TotalPayed
// */
// /*
// var HasBeenReviewed:         Object = .HasBeenReviewed
// var ReviewedAtTime:          Object = .ReviewedAtTime
// var TimeTakenToReview:       Object = .TimeTakenToReview
// var Rating:                  Object = .Rating
// var Review:                  Object = .Review
// */
// */
//
//
//protocol Creatable: TimeIntervalCalculable
//{
//    var privateHasBeenCreated:      Bool!           { get set }
//    var privateCreatedByStudent:    UserType!       { get set }
//    var privateCreatedAtTime:       DateAndTime!    { get set }
//    var privateTimeTakenToCreate:   TimeInterval?   { get set }
//    var privateCreatedForGym:       GymType!        { get set }
//    
//    
//    var privateHasEnded:            Bool?           { get set }
//    var privateEndedAtTime:         DateAndTime?    { get set }
//}
//extension Creatable
//{
//    var hasBeenCreated: Bool
//    {
//        return privateHasBeenCreated
//    }
//    var createdByStudent: UserType
//    {
//        return privateCreatedByStudent
//    }
//    var createdAtTime: DateAndTime?
//    {
//        return privateCreatedAtTime
//    }
//    var createdForGym: GymType
//    {
//        return privateCreatedForGym
//    }
//    
//    var ended: Bool?
//    {
//        return privateHasEnded
//    }
//    var endedAtTime: DateAndTime?
//    {
//        return privateEndedAtTime
//    }
//    
//    var timeIntervalOfLife: TimeInterval
//    {
//        return intervalCalculator(start: createdAtTime, end: endedAtTime)
//    }
//    var lengthOfLife: String
//    {
//        return componentsFormatter.string(from: timeIntervalOfLife)!
//    }
//    
//    mutating func timeStampCreation()
//    {
//        self.privateHasBeenCreated = true
//        self.privateCreatedAtTime = timeStamp()
//    }
//    mutating func timeStampEnding()
//    {
//        self.privateHasEnded = true
//        self.privateEndedAtTime = timeStamp()
//    }
//
//}
//
//protocol Acceptable: CustomTimeStampable
//{
//    var privateAccepted:                Bool!           { get set }
//    var privateDateAndTimeAccepted:     DateAndTime?    { get set }
//}
//extension Acceptable
//{
//    var accepted: Bool
//    {
//        return privateAccepted
//    }
//    var dateAndTimeAccepted: DateAndTime?
//    {
//        return privateDateAndTimeAccepted
//    }
//    mutating func timeStampAccept()
//    {
//        self.privateAccepted = true
//        self.privateDateAndTimeAccepted = timeStamp()
//    }
//}
//
//protocol ActivityType: TimeIntervalCalculable
//{
//    var privateStarted:                 Bool!           { get set }
//    var privateStopped:                 Bool!           { get set }
//    var privateDateAndTimeStarted:      DateAndTime?    { get set }
//    var privateDateAndTimeStopped:      DateAndTime?    { get set }
//}
//extension ActivityType
//{
//    var started: Bool
//    {
//        return privateStarted
//    }
//    var stopped: Bool
//    {
//        return privateStopped
//    }
//    mutating func timeStampStart()
//    {
//        self.privateStarted = true
//        self.privateDateAndTimeStarted = timeStamp()
//    }
//    mutating func timeStampStop()
//    {
//        self.privateStopped = true
//        self.privateDateAndTimeStopped = timeStamp()
//    }
//    var dateAndTimeStarted: DateAndTime?
//    {
//        return privateDateAndTimeStarted
//    }
//    var dateAndTimeStopped: DateAndTime?
//    {
//        return privateDateAndTimeStopped
//    }
//    
//    var timeIntervalOfActivity: TimeInterval
//    {
//        return intervalCalculator(start: dateAndTimeStarted, end: dateAndTimeStopped)
//    }
//    var timeOfActivity: String
//    {
//        return componentsFormatter.string(from: timeIntervalOfActivity)!
//    }
//}
//
//protocol Payable: CustomTimeStampable
//{
//    var privatePayed:                   Bool!           { get set }
//    var privateDateAndTimePayed:        DateAndTime?    { get set }
//}
//extension Payable
//{
//    var payed: Bool
//    {
//        return privatePayed
//    }
//    var dateAndTimePayed: DateAndTime?
//    {
//        return privateDateAndTimePayed
//    }
//    mutating func timeStampPay()
//    {
//        self.privatePayed = true
//        self.privateDateAndTimePayed = timeStamp()
//    }
//}
//
//protocol Reviewable: CustomTimeStampable
//{
//    var privateReviewed:                Bool!           { get set }
//    var privateDateAndTimeReviewed:     DateAndTime?    { get set }
//}
//extension Reviewable
//{
//    var reviewed: Bool
//    {
//        return privateReviewed
//    }
//    var dateAndTimeReviewed: DateAndTime?
//    {
//        return privateDateAndTimeReviewed
//    }
//    mutating func timeStampReview()
//    {
//        self.privateReviewed = true
//        self.privateDateAndTimeReviewed = timeStamp()
//    }
//}
