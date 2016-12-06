////
////  ModelProtocols.swift
////  SocialApp
////
////  Created by Kris Rajendren on Dec/6/16.
////  Copyright © 2016 Campus Coach. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//typealias NameTriplet = (first: String, middle: String, last: String)
//
//func parseFirst(name: String) -> String
//{
//    let names = name.components(separatedBy: .whitespacesAndNewlines)
//    let firstName = names[0]
//    return firstName
//}
//
//func parseNameTriplet(from fullName: String) -> NameTriplet
//{
//    let names   = fullName.components(separatedBy: .whitespacesAndNewlines)
//    let first   = names[0]
//    let middle  = names[1]
//    let last    = names.removeIndices(indices: [0, 1]).flattenToString()
//    return (first, middle, last)
//}
//
//func getFacebookImageURLStringFrom(_ facebookID: String) -> String
//{
//    return "\(Constants.Facebook.Profile.ImageURLPrefix)\(facebookID)\(Constants.Facebook.Profile.ImageURLSuffix)"
//}
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
//protocol TimeIntervalCalculable: CustomTimeStampable {}
//extension TimeIntervalCalculable
//{
//    func intervalCalculator(start: DateAndTime?, end: DateAndTime?) -> TimeInterval
//    {
//        guard let start = start, let end = end else { return 0.00 }
//        return end.date.timeIntervalSince(start.date)
//    }
//    
//    func intervalFromStamps(start: String?, end: String?, format: DateAndTimeFormat.Standard = .TimeToReach) -> TimeInterval
//    {
//        guard let start = start, let end = end else { return 0.00 }
//        let startTime   = DateAndTime(dateStringStandard: start, withStandard: format)
//        let endTime     = DateAndTime(dateStringStandard: end, withStandard: format)
//        return intervalCalculator(start: startTime, end: endTime)
//    }
//    
//    func intervalToReach(from: String?) -> TimeInterval
//    {
//        let zeroStamp   = Constants.Calendar.Date.ReferenceTime_mm_ss
//        return intervalFromStamps(start: zeroStamp, end: from)
//    }
//    
//    var componentsFormatter: DateComponentsFormatter
//    {
//        let formatter           = DateComponentsFormatter()
//        formatter.unitsStyle    = .full
//        return formatter
//    }
//}
//
//typealias KeysType = Constants.Protocols.Keys
//
//protocol SelfReflecting
//{
//    var keys:               KeysType        { get }
//}
//
//protocol FirebaseIDable: Dictionarizable, SelfReflecting {}
//
//
//protocol CoachTaggable: FirebaseIDable
//{
//    var privateIsCoach:     String!         { get set }
//    var isCoach:            String          { get }
//    var coachOrNot:         Bool            { get }
//}
//extension CoachTaggable
//{
//    var isCoach: String
//    {
//        return privateIsCoach
//    }
//    var coachOrNot: Bool
//    {
//        return isCoach.bool!
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.CoachTaggable.keys
//    }
//}
//
//protocol FirebaseUserIDable: CoachTaggable
//{
//    var privateFirebaseUID: String!                 { get set }
//    var firebaseUID:        String                  { get }
//    var firebaseUserRef:    FIRDatabaseReference    { get }
//}
//extension FirebaseUserIDable
//{
//    var firebaseUID: String
//    {
//        return privateFirebaseUID
//    }
//    var firebaseUserRef: FIRDatabaseReference
//    {
//        if coachOrNot
//        {
//            return firebaseUID.firebaseCoachRef
//        }
//        else
//        {
//            return firebaseUID.firebaseStudentRef
//        }
//    }
//    
//    func pushToFirebaseUser()
//    {
//        pushValuesToFirebase(forKeys: keys.firebase, at: firebaseUserRef)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.FirebaseUserIDable.keys
//    }
//}
//
//protocol ProviderSpecifiable: FirebaseIDable
//{
//    var privateProvider:    String! { get set }
//    var provider:           String  { get }
//}
//extension ProviderSpecifiable
//{
//    var provider: String
//    {
//        return privateProvider
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.ProviderSpecifiable.keys
//    }
//}
//
//protocol LoginTimeStampable: FirebaseIDable
//{
//    var privateLoggedInAtTime:  String!     { get set }
//    var loggedInAtTime:         String      { get }
//    var logInDateAndTime:       DateAndTime { get }
//}
//extension LoginTimeStampable
//{
//    var loggedInAtTime: String
//    {
//        return privateLoggedInAtTime
//    }
//    var logInDateAndTime: DateAndTime
//    {
//        return DateAndTime(dateStringCustom: loggedInAtTime)!
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.LoginTimeStampable.keys
//    }
//}
//
//protocol FacebookUserIDable: FirebaseIDable
//{
//    var privateFacebookUID: String!     { get set }
//    var facebookUID:        String      { get }
//}
//extension FacebookUserIDable
//{
//    var facebookUID: String
//    {
//        return privateFacebookUID
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.FacebookUserIDable.keys
//    }
//}
//
//protocol FacebookImageRetrievable: FacebookUserIDable {}
//extension FacebookImageRetrievable
//{
//    var facebookImageURLString: String
//    {
//        return getFacebookImageURLStringFrom(facebookUID)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.FacebookImageRetrievable.keys
//    }
//}
//
//protocol Nameable: FirebaseIDable
//{
//    var privateFullName:    String!     { get set }
//    var fullName:           String      { get }
//    var firstName:          String      { get }
//    var nameTriplet:        NameTriplet { get }
//}
//extension Nameable
//{
//    var fullName: String
//    {
//        return privateFullName
//    }
//    var firstName: String
//    {
//        return parseFirst(name: fullName)
//    }
//    var nameTriplet: NameTriplet
//    {
//        return parseNameTriplet(from: fullName)
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.Nameable.keys
//    }
//}
//
//protocol Emailable: FirebaseIDable
//{
//    var privateEmail:       String! { get set }
//}
//extension Emailable
//{
//    var email: String
//    {
//        return privateEmail
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.Emailable.keys
//    }
//}
//
//protocol Textable: FirebaseIDable
//{
//    var privateCell:        String! { get set }
//}
//extension Textable
//{
//    var cell: String
//    {
//        return privateCell
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.Textable.keys
//    }
//}
//
//protocol RequestArchivable
//{
//    var privateRequests:    String!     { get set }
//    var requests:           String      { get }
//    var requestsList:       [String]    { get }
//}
//extension RequestArchivable
//{
//    var requests: String
//    {
//        return privateRequests
//    }
//    var requestsList: [String]
//    {
//        return requests.components(separatedBy: .whitespaces)
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.RequestArchivable.keys
//    }
//}
//
//protocol RatingArchivable
//{
//    var privateRating:      String!     { get set }
//    var privateRatings:     String!     { get set }
//    
//    var rating:             String      { get }
//    var ratings:            String      { get }
//    
//    var ratingAverage:      Double      { get }
//    var ratingsList:        [Double]    { get }
//}
//extension RatingArchivable
//{
//    var rating: String
//    {
//        return privateRating
//    }
//    var ratings: String
//    {
//        return privateRatings
//    }
//    var ratingAverage: Double
//    {
//        return rating.double!
//    }
//    var ratingsList: [Double]
//    {
//        return ratings.components(separatedBy: .whitespaces).map { $0.double! }
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.RatingArchivable.keys
//    }
//}
//
//protocol ReviewArchivable
//{
//    var privateReviews:     String!     { get set }
//    var reviews:            String      { get }
//    var reviewsList:        [String]    { get }
//}
//extension ReviewArchivable
//{
//    var reviews: String
//    {
//        return privateReviews
//    }
//    var reviewsList: [String]
//    {
//        return reviews.components(separatedBy: .whitespaces)
//    }
//    var keys: KeysType
//    {
//        return Constants.Protocols.ReviewArchivable.keys
//    }
//}
//
//protocol FirebaseRequestIDable: FirebaseIDable
//{
//    var privateFirebaseRID:     String!                 { get set }
//    var firebaseRID:            String                  { get }
//    var firebaseRequestRef:     FIRDatabaseReference    { get }
//    var requestCreatedRef:      FIRDatabaseReference    { get }
//    var requestAcceptedRef:     FIRDatabaseReference    { get }
//    var requestCommunicatedRef: FIRDatabaseReference    { get }
//    var requestServiceRef:      FIRDatabaseReference    { get }
//    var requestPayedRef:        FIRDatabaseReference    { get }
//    var requestReviewedRef:     FIRDatabaseReference    { get }
//    var requestTimeRef:         FIRDatabaseReference    { get }
//}
//extension FirebaseRequestIDable
//{
//    var firebaseRID: String
//    {
//        return privateFirebaseRID
//    }
//    var firebaseRequestRef: FIRDatabaseReference
//    {
//        return firebaseRID.firebaseRequestRef
//    }
//    var requestCreatedRef: FIRDatabaseReference
//    {
//        return firebaseRID.requestCreatedRef
//    }
//    var requestAcceptedRef: FIRDatabaseReference
//    {
//        return firebaseRID.requestAcceptedRef
//    }
//    var requestCommunicatedRef: FIRDatabaseReference
//    {
//        return firebaseRID.requestCommunicatedRef
//    }
//    var requestServiceRef: FIRDatabaseReference
//    {
//        return firebaseRID.requestServiceRef
//    }
//    var requestPayedRef: FIRDatabaseReference
//    {
//        return firebaseRID.requestPayedRef
//    }
//    var requestReviewedRef: FIRDatabaseReference
//    {
//        return firebaseRID.requestReviewedRef
//    }
//    var requestTimeRef: FIRDatabaseReference
//    {
//        return firebaseRID.requestTimeRef
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.FirebaseRequestIDable.keys
//    }
//}
//
//protocol FirebaseUIDListType: FirebaseIDable
//{
//    var privateFirebaseUIDs:    String!     { get set }
//    var firebaseUIDs:           String      { get }
//    var firebaseUIDsList:       [String]    { get }
//}
//extension FirebaseUIDListType
//{
//    var firebaseUIDs: String
//    {
//        return privateFirebaseUIDs
//    }
//    var firebaseUIDsList: [String]
//    {
//        return firebaseUIDs.components(separatedBy: .whitespaces)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.FirebaseUIDListType.keys
//    }
//}
//
//protocol AllUsersType: FirebaseUserIDable {}
//
//protocol RevieweeArchivable: FirebaseIDable, FirebaseUIDListType
//{
//    var reviewedUsers:          String      { get }
//    var revieweesList:          [String]    { get }
//}
//extension RevieweeArchivable
//{
//    var reviewedUsers: String
//    {
//        return privateFirebaseUIDs
//    }
//    var revieweesList: [String]
//    {
//        return reviewedUsers.components(separatedBy: .whitespaces)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.RevieweeArchivable.keys
//    }
//}
//
//protocol ReviewerArchivable: FirebaseIDable, FirebaseUIDListType
//{
//    var reviewers:          String      { get }
//    var reviewersList:      [String]    { get }
//}
//extension ReviewerArchivable
//{
//    var reviewers: String
//    {
//        return privateFirebaseUIDs
//    }
//    var reviewersList: [String]
//    {
//        return reviewers.components(separatedBy: .whitespaces)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.ReviewerArchivable.keys
//    }
//}
//
//protocol CoachType: UserType, ReviewerArchivable {}
//extension CoachType
//{
//    var keys: KeysType
//    {
//        return Constants.Protocols.CoachType.keys
//    }
//}
//
//protocol Pushable
//{
//    func push()
//}
//
//
//protocol HappenedType: FirebaseIDable
//{
//    var privateOrNot:                       String!     { get set }
//    var privateAtTime:                      String!     { get set }
//    var orNot:                              String      { get }
//    var atTime:                             String      { get }
//    var yesOrNo:                            Bool        { get }
//    var atDateAndTime:                      DateAndTime { get }
//}
//extension HappenedType
//{
//    var orNot: String
//    {
//        return privateOrNot
//    }
//    var atTime: String
//    {
//        return privateAtTime
//    }
//    var yesOrNo: Bool
//    {
//        return orNot.bool!
//    }
//    var atDateAndTime: DateAndTime
//    {
//        return DateAndTime(dateStringCustom: atTime)!
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.HappenedType.keys
//    }
//}
//
//protocol Starting: FirebaseIDable
//{
//    var privateHasStarted:      String!         { get set }
//    var privateStartedAtTime:   String!         { get set }
//    var hasStarted:             String          { get }
//    var startedAtTime:          String          { get }
//    var started:                Bool            { get }
//    var startedAtDateAndTime:   DateAndTime     { get }
//}
//extension Starting
//{
//    var hasStarted:             String
//    {
//        return privateHasStarted
//    }
//    var startedAtTime:          String
//    {
//        return privateStartedAtTime
//    }
//    var started:                Bool
//    {
//        return hasStarted.bool!
//    }
//    var startedAtDateAndTime:   DateAndTime
//    {
//        return DateAndTime(dateStringCustom: startedAtTime)!
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.Starting.keys
//    }
//}
//
//protocol Ending: FirebaseIDable
//{
//    var privateHasEnded:    String!     { get set }
//    var privateEndedAtTime: String!     { get set }
//    var hasEnded:           String      { get }
//    var endedAtTime:        String      { get }
//    var ended:              Bool        { get }
//    var endedAtDateAndTime: DateAndTime { get }
//}
//extension Ending
//{
//    var hasEnded: String
//    {
//        return privateHasEnded
//    }
//    var endedAtTime: String
//    {
//        return privateEndedAtTime
//    }
//    var ended: Bool
//    {
//        return hasEnded.bool!
//    }
//    var endedAtDateAndTime: DateAndTime
//    {
//        return DateAndTime(dateStringCustom: endedAtTime)!
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.Ending.keys
//    }
//}
//
//protocol ActivityType: Starting, Ending, TimeIntervalCalculable, FirebaseRequestIDable, Pushable
//{
//    var timeInterval:   TimeInterval    { get }
//    var duration:       String          { get }
//    
//    init    ()
//    
//    init    (
//        internallyWithFirebaseRID
//        firebaseRID:    String,
//        startedAtTime:  String,
//        hasEnded:       String,
//        endedAtTime:    String
//    )
//    
//    init?   (
//        fromServerWithFirebaseRID
//        firebaseRID:    String
//    )
//    
//}
//extension ActivityType
//{
//    var timeInterval: TimeInterval
//    {
//        return intervalCalculator(start: startedAtDateAndTime, end: endedAtDateAndTime)
//    }
//    var duration: String
//    {
//        return componentsFormatter.string(from: timeInterval)!
//    }
//    
//    func push()
//    {
//        pushValuesToFirebase(forKeys: keys.firebase, at: requestServiceRef)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.ActivityType.keys
//    }
//}
//
//protocol StudentInitiatable: HappenedType, TimeIntervalCalculable
//{
//    var privateByStudent:                   String!         { get set }
//    var byStudent:                          String          { get }
//    var student:                            Student         { get }
//    var afterTimeInterval:                  TimeInterval    { get }
//    var afterTimeOf:                        String          { get }
//}
//extension StudentInitiatable
//{
//    var byStudent:                          String
//    {
//        return privateByStudent
//    }
//    var afterTimeOf:                        String
//    {
//        return componentsFormatter.string(from: afterTimeInterval)!
//    }
//    
//    var student:                            Student
//    {
//        return Student(fromServerWithFirebaseUID: byStudent, forUserWhoIsACoachOrNot: false)!
//    }
//    var afterTimeInterval:                  TimeInterval
//    {
//        return intervalCalculator(start: student.logInDateAndTime, end: atDateAndTime)
//    }
//}
//
//protocol CoachInitiatable: HappenedType, TimeIntervalCalculable
//{
//    var privateByCoach:                     String!         { get set }
//    
//    var byCoach:                            String          { get }
//    var afterTimeOf:                        String          { get }
//    
//    var coach:                              Coach           { get }
//    var afterTimeInterval:                  TimeInterval    { get }
//}
//extension CoachInitiatable
//{
//    var byCoach:                            String
//    {
//        return privateByCoach
//    }
//    var afterTimeOf:                        String
//    {
//        return componentsFormatter.string(from: afterTimeInterval)!
//    }
//    
//    var coach:                              Coach
//    {
//        return Coach(fromServerWithFirebaseUID: byCoach, forUserWhoIsACoachOrNot: true)!
//    }
//    var afterTimeInterval:                  TimeInterval
//    {
//        return intervalCalculator(start: coach.logInDateAndTime, end: atDateAndTime)
//    }
//}
//
//extension Array where Element: ExpressibleByStringLiteral
//{
//    var boolsWithFailures: (bools: [Bool], indicesOfFailure: [Int])
//    {
//        var arrayOfBools    = [Bool]()
//        var arrayOfIndices  = [Int]()
//        for i in 1...self.count
//        {
//            if let bool = "\(self[i-1])".bool
//            {
//                arrayOfBools.append(bool)
//            }
//            else
//            {
//                arrayOfBools.append(true)
//                arrayOfIndices.append(i-1)
//            }
//        }
//        return (arrayOfBools, arrayOfIndices)
//    }
//    func flattenToString() -> String
//    {
//        var flattenedString = ""
//        for element in self
//        {
//            flattenedString = "\(flattenedString)\(element)"
//        }
//        return flattenedString
//    }
//}
//
//enum CallOrText: String
//{
//    case call
//    case text
//    case none
//    
//    var isCall: Bool
//    {
//        return self == .call
//    }
//    var isText: Bool
//    {
//        return self == .text
//    }
//    var isNone: Bool
//    {
//        return self == .none
//    }
//    
//    static func fromArrayOf(callOrTextStrings: [String]) -> [CallOrText]
//    {
//        var arrayOfCallOrTexts      = [CallOrText]()
//        for callOrTextString in callOrTextStrings
//        {
//            arrayOfCallOrTexts.append(CallOrText(rawValue: callOrTextString)!)
//        }
//        return arrayOfCallOrTexts
//    }
//}
//
//protocol HappenedSequenceType: TimeIntervalCalculable
//{
//    var privateOrNot:   String!         { get set }
//    var privateAtTimes: String!         { get set }
//    var orNot:          String          { get }
//    var atTimes:        String          { get }
//    var yesOrNo:        Bool            { get }
//    var atTimesList:    [String]        { get }
//    var atDateAndTimes: [DateAndTime]   { get }
//}
//extension HappenedSequenceType
//{
//    var orNot: String
//    {
//        return privateOrNot
//    }
//    var yesOrNo: Bool
//    {
//        return orNot.bool!
//    }
//    var atTimes: String
//    {
//        return privateAtTimes
//    }
//    var atTimesList: [String]
//    {
//        return atTimes.components(separatedBy: .whitespaces)
//    }
//    var atDateAndTimes: [DateAndTime]
//    {
//        return DateAndTime.fromArrayOneCustomFormat(ofStrings: atTimesList)!
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.HappenedSequenceType.keys
//    }
//}
//
//protocol CallOrTextSequenceType
//{
//    var privateByCallOrText:    String!         { get set }
//    var byCallOrText:           String          { get }
//    var byCallsOrTextsList:     [String]        { get }
//    var callsOrTexts:           [CallOrText]    { get }
//}
//extension CallOrTextSequenceType
//{
//    var byCallOrText: String
//    {
//        return privateByCallOrText
//    }
//    var byCallsOrTextsList: [String]
//    {
//        return byCallOrText.components(separatedBy: .whitespaces)
//    }
//    var callsOrTexts: [CallOrText]
//    {
//        return CallOrText.fromArrayOf(callOrTextStrings: byCallsOrTextsList)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.CallOrTextSequenceType.keys
//    }
//}
//
//protocol CoachOrNotSequenceType
//{
//    var privateByCoachOrNot:    String!     { get set }
//    var byCoachOrNot:           String      { get }
//    var byCoachOrNotsList:      [String]    { get }
//    var coachOrNots:            [Bool]      { get }
//}
//extension CoachOrNotSequenceType
//{
//    var byCoachOrNot: String
//    {
//        return privateByCoachOrNot
//    }
//    var byCoachOrNotsList: [String]
//    {
//        return byCoachOrNot.components(separatedBy: .whitespaces)
//    }
//    var coachOrNots: [Bool]
//    {
//        return byCoachOrNotsList.boolsWithFailures.bools
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.CoachOrNotSequenceType.keys
//    }
//}
//
//typealias Dollars       = Double
//typealias Cost          = Double
//typealias Percentage    = Double
//typealias Fraction      = Double
//
//extension String
//{
//    var double: Double?
//    {
//        return Double(self)
//    }
//    var int: Int?
//    {
//        return Int(self)
//    }
//}
//
//extension Int
//{
//    var double: Double
//    {
//        return Double(self)
//    }
//    var string: String
//    {
//        return "\(self)"
//    }
//}
//
//extension Double
//{
//    var string: String
//    {
//        return "\(self)"
//    }
//    var intGreater: Int
//    {
//        return Int(ceil(self))
//    }
//    var intLesser: Int
//    {
//        return Int(floor(self))
//    }
//}
//extension Dollars
//{
//    var dollars: Int
//    {
//        return Int(floor(self))
//    }
//    var cents: Int
//    {
//        return Int((self - floor(self)) * 100)
//    }
//    var priceComponents: (dollars: Int, cents: Int)
//    {
//        return (dollars, cents)
//    }
//    var priceDescriptionSymbolic: String
//    {
//        return "$ \(dollars) and ¢ \(cents)"
//    }
//    var priceDescriptionWords: String
//    {
//        return "\(dollars) Dollars & \(cents) Cents"
//    }
//    func unitsOfService(rate: Double) -> Double
//    {
//        return self / rate
//    }
//}
//
//extension Cost: TimeIntervalCalculable
//{
//    var perHour: Cost
//    {
//        return self
//    }
//    var perMinute: Cost
//    {
//        return self / 60.00
//    }
//    var perSecond: Cost
//    {
//        return self / 3600.00
//    }
//    var per8HourDay: Cost
//    {
//        return self * 8
//    }
//    var per40HoursWeek: Cost
//    {
//        return self * 8 * 5
//    }
//    func toTotalAmount(for time: TimeInterval) -> Dollars
//    {
//        return self.perSecond * time
//    }
//    func toCoachFeeAfter(deducting commission: Percentage, for time: TimeInterval) -> Dollars
//    {
//        return (self.perSecond * time) * (1 - commission.percentToFraction)
//    }
//    func toCommissionEarned(for commission: Percentage, for time: TimeInterval) -> Dollars
//    {
//        return (self.perSecond * time) * commission.percentToFraction
//    }
//}
//
//extension Percentage
//{
//    var percentage: Percentage
//    {
//        return self
//    }
//    var percentToFraction: Fraction
//    {
//        return self / 100.00
//    }
//    var fractionToPercent: Percentage
//    {
//        return self * 100.00
//    }
//}
//
//protocol Billable
//{
//    var privateCostPerHour:         String!     { get set }
//    var costPerHour:                String      { get }
//    var costInDollars:              Cost        { get }
//}
//extension Billable
//{
//    var costPerHour: String
//    {
//        return privateCostPerHour
//    }
//    var costInDollars: Dollars
//    {
//        return costPerHour.double!
//    }
//}
//
//protocol Commissionable
//{
//    var privateCommision:           String!     { get set }
//    var commission:                 String      { get }
//    var commissionPercentage:       Percentage  { get }
//    var commissionFraction:         Fraction    { get }
//    var coachPercentage:            Percentage  { get }
//    var coachFraction:              Fraction    { get }
//}
//extension Commissionable
//{
//    var commission: String
//    {
//        return privateCommision
//    }
//    var commissionPercentage: Percentage
//    {
//        return commission.double!
//    }
//    var commissionFraction: Fraction
//    {
//        return commissionPercentage.percentToFraction
//    }
//    var coachFraction: Fraction
//    {
//        return 1 - commissionFraction
//    }
//    var coachPercentage: Percentage
//    {
//        return coachFraction.fractionToPercent
//    }
//}
//
//protocol Tippable
//{
//    var privateTip:                 String!     { get set }
//    var tip:                        String      { get }
//    var tipInDollars:               Dollars     { get }
//}
//extension Tippable
//{
//    var tip: String
//    {
//        return privateTip
//    }
//    var tipInDollars: Dollars
//    {
//        return tip.double!
//    }
//}
//
//protocol TipCommissionable
//{
//    var privateTipCommission:       String!     { get set }
//    var tipCommission:              String      { get }
//    var tipCommissionPercentage:    Percentage  { get }
//    var tipCommissionFraction:      Fraction    { get }
//    var tipCoachPercentage:         Percentage  { get }
//    var tipCoachFraction:           Fraction    { get }
//}
//extension TipCommissionable
//{
//    var tipCommission: String
//    {
//        return privateTipCommission
//    }
//    var tipCommissionPercentage: Percentage
//    {
//        return tipCommission.double!
//    }
//    var tipCommissionFraction:      Fraction
//    {
//        return tipCommissionPercentage.percentToFraction
//    }
//    var tipCoachFraction:           Fraction
//    {
//        return 1 - tipCommissionFraction
//    }
//    var tipCoachPercentage:         Percentage
//    {
//        return tipCoachFraction.fractionToPercent
//    }
//}
//
//protocol RequestTimeSequenceType: TimeIntervalCalculable
//{
//    var intervalToCreate:       TimeInterval        { get }
//    var intervalToAccept:       TimeInterval        { get }
//    var intervalToCommunicate:  TimeInterval        { get }
//    var intervalToStart:        TimeInterval        { get }
//    var intervalToPay:          TimeInterval        { get }
//    var intervalToReview:       TimeInterval        { get }
//    
//    var toCreate:               String              { get }
//    var toAccept:               String              { get }
//    var toCommunicate:          String              { get }
//    var toStart:                String              { get }
//    var toPay:                  String              { get }
//    var toReview:               String              { get }
//    
//    var time:                   StringDictionary    { get }
//}
//extension RequestTimeSequenceType
//{
//    var toCreate: String
//    {
//        return componentsFormatter.string(from: intervalToCreate)!
//    }
//    var toAccept: String
//    {
//        return componentsFormatter.string(from: intervalToAccept)!
//    }
//    var toCommunicate: String
//    {
//        return componentsFormatter.string(from: intervalToCommunicate)!
//    }
//    var toStart: String
//    {
//        return componentsFormatter.string(from: intervalToStart)!
//    }
//    var toPay: String
//    {
//        return componentsFormatter.string(from: intervalToPay)!
//    }
//    var toReview: String
//    {
//        return componentsFormatter.string(from: intervalToReview)!
//    }
//    
//    var time: StringDictionary
//    {
//        return  [
//            Constants.Protocols.RequestTimeSequenceType.toCreate        : toCreate,
//            Constants.Protocols.RequestTimeSequenceType.toAccept        : toAccept,
//            Constants.Protocols.RequestTimeSequenceType.toCommunicate   : toCommunicate,
//            Constants.Protocols.RequestTimeSequenceType.toStart         : toStart,
//            Constants.Protocols.RequestTimeSequenceType.toPay           : toPay,
//            Constants.Protocols.RequestTimeSequenceType.toReview        : toReview
//        ]
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.RequestTimeSequenceType.keys
//    }
//}
//
//protocol RequestType: RequestTimeSequenceType, FirebaseRequestIDable, Pushable
//{
//    var privateCreated:         Created!            { get set }
//    var privateAccepted:        Accepted?           { get set }
//    var privateCommunicated:    Communicated?       { get set }
//    var privateService:         Service?            { get set }
//    var privatePayed:           Payed?              { get set }
//    var privateReviewed:        Reviewed?           { get set }
//    
//    var created:                Created             { get }
//    var accepted:               Accepted?           { get }
//    var communicated:           Communicated?       { get }
//    var service:                Service?            { get }
//    var payed:                  Payed?              { get }
//    var reviewed:               Reviewed?           { get }
//    
//    init    ()
//    init    (
//        byStudent:      String,
//        forGym:         String
//    )
//    init    (
//        internallyWithFirebaseRID
//        firebaseRID:    String,
//        created:        Created,
//        accepted:       Accepted?,
//        communicated:   Communicated?,
//        service:        Service?,
//        payed:          Payed?,
//        reviewed:       Reviewed?
//    )
//    init?   (
//        fromServerWithFirebaseRID
//        firebaseRID:    String
//    )
//    
//    func push()
//    
//    mutating func accept(byCoach: String, atTheGym: String, timeToReach: String)
//    mutating func communicate(byCallOrText: String, byCoachOrNot: String)
//    mutating func start()
//    mutating func stop()
//    mutating func pay(withTip tip: String)
//    mutating func review(withRating rating: String, withReview review: String)
//}
//extension RequestType
//{
//    var created: Created
//    {
//        return privateCreated
//    }
//    var accepted: Accepted?
//    {
//        return privateAccepted
//    }
//    var communicated: Communicated?
//    {
//        return privateCommunicated
//    }
//    var service: Service?
//    {
//        return privateService
//    }
//    var payed: Payed?
//    {
//        return privatePayed
//    }
//    var reviewed: Reviewed?
//    {
//        return privateReviewed
//    }
//    
//    var intervalToCreate: TimeInterval
//    {
//        return intervalCalculator(start: created.student.logInDateAndTime, end: created.atDateAndTime)
//    }
//    var intervalToAccept: TimeInterval
//    {
//        return intervalCalculator(start: created.atDateAndTime, end: accepted?.atDateAndTime)
//    }
//    var intervalToCommunicate: TimeInterval
//    {
//        return intervalCalculator(start: accepted?.atDateAndTime, end: communicated?.atDateAndTimes[0])
//    }
//    var intervalToStart: TimeInterval
//    {
//        if let communicated = communicated
//        {
//            return intervalCalculator(start: communicated.atDateAndTimes[0], end: service?.startedAtDateAndTime)
//        }
//        else
//        {
//            return intervalCalculator(start: accepted?.atDateAndTime, end: service?.startedAtDateAndTime)
//        }
//    }
//    var intervalToPay: TimeInterval
//    {
//        return intervalCalculator(start: service?.endedAtDateAndTime, end: payed?.atDateAndTime)
//    }
//    var intervalToReview: TimeInterval
//    {
//        return intervalCalculator(start: payed?.atDateAndTime, end: reviewed?.atDateAndTime)
//    }
//    
//    func push()
//    {
//        created         .push()
//        accepted?       .push()
//        communicated?   .push()
//        service?        .push()
//        payed?          .push()
//        reviewed?       .push()
//        requestTimeRef  .updateChildValues(time)
//    }
//    
//    mutating func accept(byCoach: String, atTheGym: String, timeToReach: String)
//    {
//        self.privateAccepted                = Accepted(internallyWithFirebaseRID: firebaseRID, byCoach: byCoach, whoIsAtTheGym: atTheGym, andWillTake: timeToReach)
//    }
//    mutating func communicate(byCallOrText: String, byCoachOrNot: String)
//    {
//        if communicated != nil
//        {
//            privateCommunicated!.stampCommunication(byCallOrText: byCallOrText, byCoachOrNot: byCoachOrNot)
//        }
//        else
//        {
//            let atTime                      = timeStamp().stampNanoseconds
//            self.privateCommunicated        = Communicated(internallyWithFirebaseRID: firebaseRID, communicatedAtTimes: atTime, usingCallOrText: byCallOrText, initiatedByCoachOrNot: byCoachOrNot)
//        }
//    }
//    mutating func start()
//    {
//        let atTime                          = timeStamp().stampNanoseconds
//        self.privateService                 = Service(internallyWithFirebaseRID: firebaseRID, startedAtTime: atTime, endedAtTime: atTime)
//    }
//    mutating func stop()
//    {
//        let atTime                          = timeStamp().stampNanoseconds
//        self.service?.privateHasEnded       = YesOrNo.Yes.string
//        self.service?.privateEndedAtTime    = atTime
//    }
//    mutating func pay(withTip tip: String)
//    {
//        let atTime                          = timeStamp().stampNanoseconds
//        self.privatePayed                   = Payed(internallyWithFirebaseRID: firebaseRID, service: service!, tip: tip)
//    }
//    mutating func review(withRating rating: String, withReview review: String)
//    {
//        let atTime                              = timeStamp().stampNanoseconds
//        self.privateReviewed                    =
//            Reviewed(internallyWithFirebaseRID: firebaseRID, atTime: atTime, rating: rating, review: review)
//        self.privateCreated.privateEndedAtTime  = atTime
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.RequestType.keys
//    }
//}
//
//class Request: RequestType
//{
//    var privateFirebaseRID:     String!
//    var privateCreated:         Created!
//    var privateAccepted:        Accepted?       = nil
//    var privateCommunicated:    Communicated?   = nil
//    var privateService:         Service?        = nil
//    var privatePayed:           Payed?          = nil
//    var privateReviewed:        Reviewed?       = nil
//    
//    required init()
//    {
//        self.privateFirebaseRID = timeStamp().stampNanoseconds
//        self.privateCreated     = Created()
//    }
//    
//    required convenience init(byStudent: String, forGym: String)
//    {
//        self.init()
//        self.privateCreated     = Created   (
//            internallyWithFirebaseRID:  privateFirebaseRID,
//            byStudent:                  byStudent,
//            forGymWith:                 forGym
//        )
//    }
//    
//    required convenience init   (
//        internallyWithFirebaseRID
//        firebaseRID:    String,
//        created:        Created,
//        accepted:       Accepted?,
//        communicated:   Communicated?,
//        service:        Service?,
//        payed:          Payed?,
//        reviewed:       Reviewed?
//        )
//    {
//        self.init()
//        self.privateCreated         = created
//        self.privateAccepted        = accepted
//        self.privateCommunicated    = communicated
//        self.privateService         = service
//        self.privatePayed           = payed
//        self.privateReviewed        = reviewed
//        self.privateFirebaseRID     = firebaseRID
//    }
//    
//    required convenience init?  (
//        fromServerWithFirebaseRID
//        firebaseRID:    String
//        )
//    {
//        guard   let created         =   Created       (fromServerWithFirebaseRID: firebaseRID)
//            else
//        {
//            return nil
//        }
//        let accepted        =   Accepted      (fromServerWithFirebaseRID: firebaseRID)
//        let communicated    =   Communicated  (fromServerWithFirebaseRID: firebaseRID)
//        let service         =   Service       (fromServerWithFirebaseRID: firebaseRID)
//        let payed           =   Payed         (fromServerWithFirebaseRID: firebaseRID)
//        let reviewed        =   Reviewed      (fromServerWithFirebaseRID: firebaseRID)
//        self.init   (
//            internallyWithFirebaseRID:  firebaseRID,
//            created:                    created,
//            accepted:                   accepted,
//            communicated:               communicated,
//            service:                    service,
//            payed:                      payed,
//            reviewed:                   reviewed
//        )
//    }
//}
//
//protocol FirebaseLocationIDable: FirebaseIDable
//{
//    var privateFirebaseLID:     String!                 { get set }
//    var firebaseLID:            String                  { get }
//    var firebaseLocationRef:    FIRDatabaseReference    { get }
//}
//extension FirebaseLocationIDable
//{
//    var firebaseLID: String
//    {
//        return privateFirebaseLID
//    }
//    var firebaseLocationRef: FIRDatabaseReference
//    {
//        return getFirebaseLocationRef(fromObject: self)
//    }
//    
//    var keys: KeysType
//    {
//        return Constants.Protocols.FirebaseLocationIDable.keys
//    }
//}
//
//protocol Locatable
//{
//    var privateLocation: CLLocation! { get set }
//}
//extension Locatable
//{
//    var location: CLLocation
//    {
//        return privateLocation
//    }
//    
//    var distanceFromWhiteBldg: CLLocationDistance
//    {
//        return getDistanceFromGym(.White)
//    }
//    var distanceFromRecHall: CLLocationDistance
//    {
//        return getDistanceFromGym(.Rec)
//    }
//    var distanceFromIMBldg: CLLocationDistance
//    {
//        return getDistanceFromGym(.IM)
//    }
//    
//    func getDistanceFrom(_ object: Locatable) -> CLLocationDistance
//    {
//        return location.distance(from: object.location)
//    }
//    
//    func getDistanceFromGym(_ building: Building) -> CLLocationDistance
//    {
//        return location.distance(from: building.location)
//    }
//}
