//
//  ModelProtocols.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/6/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

typealias NameTriplet = (first: String, middle: String, last: String)

func parseFirst(name: String) -> String
{
    let names = name.components(separatedBy: .whitespacesAndNewlines)
    let firstName = names[0]
    return firstName
}

func parseNameTriplet(from fullName: String) -> NameTriplet
{
    let names   = fullName.components(separatedBy: .whitespacesAndNewlines)
    let first   = names[0]
    let middle  = names[1]
    let last    = names.removeIndices(indices: [0, 1]).flattenToString()
    return (first, middle, last)
}

func getFacebookImageURLStringFrom(_ facebookID: String) -> String
{
    return "\(Constants.Facebook.Profile.ImageURLPrefix)\(facebookID)\(Constants.Facebook.Profile.ImageURLSuffix)"
}

func timeStamp() -> DateAndTime
{
    return DateAndTime()
}

protocol CustomTimeStampable {}
extension CustomTimeStampable
{
    mutating func timeStampEvent(occurred: inout Bool!, at date: DateAndTime? = nil, set internalDate: inout DateAndTime?)
    {
        occurred = true
        if let date = date
        {
            internalDate = date
        }
        else
        {
            internalDate = timeStamp()
        }
    }
}

protocol TimeIntervalCalculable: CustomTimeStampable {}
extension TimeIntervalCalculable
{
    func intervalCalculator(start: DateAndTime?, end: DateAndTime?) -> TimeInterval
    {
        guard let start = start, let end = end else { return 0.00 }
        return end.date.timeIntervalSince(start.date)
    }
    
    func intervalFromStamps(start: String?, end: String?, format: DateAndTimeFormat.Standard = .TimeToReach) -> TimeInterval
    {
        guard let start = start, let end = end else { return 0.00 }
        let startTime   = DateAndTime(dateStringStandard: start, withStandard: format)
        let endTime     = DateAndTime(dateStringStandard: end, withStandard: format)
        return intervalCalculator(start: startTime, end: endTime)
    }
    
    func intervalToReach(from: String?) -> TimeInterval
    {
        let zeroStamp   = Constants.Calendar.Date.ReferenceTime_mm_ss
        return intervalFromStamps(start: zeroStamp, end: from)
    }
    
    var componentsFormatter: DateComponentsFormatter
    {
        let formatter           = DateComponentsFormatter()
        formatter.unitsStyle    = .full
        return formatter
    }
}

typealias KeysType = Constants.Protocols.Keys

protocol SelfReflecting
{
    static var keys         : KeysType        { get }
}

protocol Saveable
{
    func save() -> Bool
}

protocol Retrievable
{
    func retrieve() -> Any?
}

protocol Persisting: Saveable {}

protocol ObjectHierarchyTraceable
{
    static var setObject:   Firebase.Object!    { get set }
    static var setChildOf:  Firebase.Object!    { get set }
    static var setChild:    Firebase.Child!     { get set }
}
extension ObjectHierarchyTraceable
{
    static var object: Firebase.Object
    {
        return Self.setObject
    }
    static var childOf: Firebase.Object
    {
        return Self.setChildOf
    }
    static var child: Firebase.Child
    {
        return Self.setChild
    }
    
    var objectInstance: Firebase.Object
    {
        return Self.object
    }
    var childOfInstance: Firebase.Object
    {
        return Self.childOf
    }
    var childInstance: Firebase.Child
    {
        return Self.child
    }
    
    static var path: String
    {
        var objectPath = String()
        if Self.object.key.isEmpty
        {
            objectPath = Self.child.path
        }
        else
        {
            objectPath = Self.object.path
        }
        return objectPath
    }
}

protocol FirebaseIDable: Dictionarizable, SelfReflecting, ObjectHierarchyTraceable
{
    var firebaseID:     String  { get }
}
extension FirebaseIDable
{
    var saveKeyPrefix: String
    {
       return "\(Self.path)"
    }
    static var keyForSaveKeys: Key
    {
        return "\(Self.path)_saveKeys"
    }
    var keyForSavingKeys: Key
    {
        return Self.keyForSaveKeys
    }
    
    var saveKeys: Keys
    {
        return firebaseKeys.map { self.saveKey(forFirebaseKey: $0) }
    }
    func saveKey(forFirebaseKey key: Key) -> Key
    {
        return "\(saveKeyPrefix)_\(key)"
    }
    func firebaseKey(forSaveKey key: Key) -> Key
    {
        var shredded = Key()
        if let firebaseKey = key.components(separatedBy: Constants.Literal.Underscore).last
        {
            shredded = firebaseKey
        }
        else
        {
            print("KRIS: The Save Key input \n KRIS: \(key) is not of the right format.")
            shredded = Constants.Literal.Empty
        }
        return shredded
    }
    var anyDictionaryForSaving: AnyDictionary
    {
        var dictionary      = AnyDictionary()
        var keyForSaving    = Key()
        for (key, value) in anyDictionaryOfFirebaseKeys
        {
            keyForSaving    = saveKey(forFirebaseKey: key)
            dictionary.updateValue(value, forKey: keyForSaving)
        }
        return dictionary
    }
    
    var stringDictionaryForSaving: StringDictionary
    {
        return anyDictionaryForSaving.forcedStringLiteral
    }
    
    func save() -> Bool
    {
        UserDefaults.standard.set(self, forKey: Self.keyForSaveKeys)
        return UserDefaults.standard.synchronize()
    }
    
    func retrieve() -> Any?
    {
        return UserDefaults.standard.value(forKey: Self.keyForSaveKeys)
    }
    
    func saveAnyDictionary() -> Bool
    {
        print("KRIS: Any Dictionary Being Saved \(anyDictionaryForSaving)")
        UserDefaults.standard.setValuesForKeys(anyDictionaryForSaving)
        print("KRIS: Save Keys Being Saved FirebaseIDable \(saveKeys) \n KRIS: Save Keys Saved for key \(Self.keyForSaveKeys)")
        UserDefaults.standard.setValue(saveKeys, forKey: Self.keyForSaveKeys)
        return UserDefaults.standard.synchronize()
    }
    func saveStringDictionary() -> Bool
    {
        return saveAnyDictionary()
    }
    var saved: Any?
    {
        return UserDefaults.standard.value(forKey: Self.keyForSaveKeys)
    }
    var savedAnyDictionary: AnyDictionary
    {
        var savedDictionary     = AnyDictionary()
        print("KRIS: Save Keys FirebaseIDable \(saveKeys)\n\n")
        if let savedKeys        = UserDefaults.standard.value(forKey: Self.keyForSaveKeys) as? Keys
        {
            savedDictionary      = UserDefaults.standard.dictionaryWithValues(forKeys: savedKeys)
            print("KRIS: Retrieved Any Dictionary \(savedDictionary.forcedStringLiteral)\n\n")
        }
        else
        {
            savedDictionary     = saveKeys.emptyStringDictionary
            print("KRIS: Save Keys could not be found. Returning Empty String Dictionary \(savedDictionary)\n\n")
        }
        return savedDictionary
    }
    var savedFirebaseDictionary: AnyDictionary
    {
        var firebaseAnyDictionary   = AnyDictionary()
        for i in 1...saveKeys.count
        {
            firebaseAnyDictionary.updateValue(savedAnyDictionary[saveKeys[i - 1]]!, forKey: firebaseKeys[i - 1])
        }
        print("KRIS: Saved Firebase Dictionary FirebaseIDable is \(firebaseAnyDictionary.forcedStringLiteral)")
        return firebaseAnyDictionary
    }
    var savedStringDictionary: StringDictionary
    {
        var firebaseStringDictionary    = StringDictionary()
        var savedStringDictionary       = StringDictionary()
        savedStringDictionary           = UserDefaults.standard.dictionaryWithValues(forKeys: saveKeys).forcedStringLiteral
        for i in 1...saveKeys.count
        {
            firebaseStringDictionary.updateValue(savedStringDictionary[saveKeys[i - 1]]!, forKey: firebaseKeys[i - 1])
        }
        return firebaseStringDictionary
    }
}

protocol CoachTaggable: FirebaseIDable
{
    var privateIsCoach:     String!         { get set }
    var isCoach:            String          { get }
    var coachOrNot:         Bool?           { get }
}
extension CoachTaggable
{
    var isCoach: String
    {
        return privateIsCoach
    }
    var coachOrNot: Bool?
    {
        return isCoach.bool
    }
    var keys: KeysType
    {
        return Constants.Protocols.CoachTaggable.keys
    }
}

protocol FirebaseUserIDable: CoachTaggable
{
    var privateFirebaseUID: String!                 { get set }
    var firebaseUID:        String                  { get }
    var firebaseUserRef:    FIRDatabaseReference    { get }
}
extension FirebaseUserIDable
{
    var firebaseID: String
    {
        return firebaseUID
    }
    var firebaseUID: String
    {
        return privateFirebaseUID
    }
    var firebaseUserRef: FIRDatabaseReference
    {
        if coachOrNot!
        {
            return firebaseUID.firebaseCoachRef
        }
        else
        {
            return firebaseUID.firebaseStudentRef
        }
    }
    
    func pushToFirebaseUser()
    {
        pushValuesToFirebase(forKeys: Self.keys.firebase, at: firebaseUserRef)
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.FirebaseUserIDable.keys
    }
}

protocol ProviderSpecifiable: FirebaseIDable
{
    var privateProvider:    String! { get set }
    var provider:           String  { get }
}
extension ProviderSpecifiable
{
    var provider: String
    {
        return privateProvider
    }
    var keys: KeysType
    {
        return Constants.Protocols.ProviderSpecifiable.keys
    }
}

protocol LoginTimeStampable: FirebaseIDable
{
    var privateLoggedInAtTime:  String!     { get set }
    var loggedInAtTime:         String      { get }
    var logInDateAndTime:       DateAndTime { get }
}
extension LoginTimeStampable
{
    var loggedInAtTime: String
    {
        return privateLoggedInAtTime
    }
    var logInDateAndTime: DateAndTime
    {
        return DateAndTime(dateStringCustom: loggedInAtTime)!
    }
    var keys: KeysType
    {
        return Constants.Protocols.LoginTimeStampable.keys
    }
}

protocol FacebookUserIDable: FirebaseIDable
{
    var privateFacebookUID: String!     { get set }
    var facebookUID:        String      { get }
}
extension FacebookUserIDable
{
    var facebookUID: String
    {
        return privateFacebookUID
    }
    var keys: KeysType
    {
        return Constants.Protocols.FacebookUserIDable.keys
    }
}

protocol FacebookImageRetrievable: FacebookUserIDable {}
extension FacebookImageRetrievable
{
    var facebookImageURLString: String
    {
        return getFacebookImageURLStringFrom(facebookUID)
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.FacebookImageRetrievable.keys
    }
}

protocol Nameable: FirebaseIDable
{
    var privateFullName:    String!     { get set }
    var fullName:           String      { get }
    var firstName:          String      { get }
    var nameTriplet:        NameTriplet { get }
}
extension Nameable
{
    var fullName: String
    {
        return privateFullName
    }
    var firstName: String
    {
        return parseFirst(name: fullName)
    }
    var nameTriplet: NameTriplet
    {
        return parseNameTriplet(from: fullName)
    }
    var keys: KeysType
    {
        return Constants.Protocols.Nameable.keys
    }
}

protocol Emailable: FirebaseIDable
{
    var privateEmail:       String! { get set }
}
extension Emailable
{
    var email: String
    {
        return privateEmail
    }
    var keys: KeysType
    {
        return Constants.Protocols.Emailable.keys
    }
}

protocol Textable: FirebaseIDable
{
    var privateCell:        String! { get set }
}
extension Textable
{
    var cell: String
    {
        return privateCell
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.Textable.keys
    }
}

protocol RequestArchivable
{
    var privateRequests:    String!     { get set }
    var requests:           String      { get }
    var requestsList:       [String]    { get }
}
extension RequestArchivable
{
    var requests: String
    {
        return privateRequests
    }
    var requestsList: [String]
    {
        return requests.components(separatedBy: .whitespaces)
    }
    var keys: KeysType
    {
        return Constants.Protocols.RequestArchivable.keys
    }
}

protocol RatingArchivable
{
    var privateRating:      String!     { get set }
    var privateRatings:     String!     { get set }
    
    var rating:             String      { get }
    var ratings:            String      { get }
    
    var ratingAverage:      Double      { get }
    var ratingsList:        [Double]    { get }
}
extension RatingArchivable
{
    var rating: String
    {
        return privateRating
    }
    var ratings: String
    {
        return privateRatings
    }
    var ratingAverage: Double
    {
        return rating.double!
    }
    var ratingsList: [Double]
    {
        return ratings.components(separatedBy: .whitespaces).map { $0.double! }
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.RatingArchivable.keys
    }
}

protocol ReviewArchivable
{
    var privateReviews:     String!     { get set }
    var reviews:            String      { get }
    var reviewsList:        [String]    { get }
}
extension ReviewArchivable
{
    var reviews: String
    {
        return privateReviews
    }
    var reviewsList: [String]
    {
        return reviews.components(separatedBy: .whitespaces)
    }
    var keys: KeysType
    {
        return Constants.Protocols.ReviewArchivable.keys
    }
}

protocol FirebaseRequestIDable: FirebaseIDable
{
    var privateFirebaseRID:     String!                 { get set }
    var firebaseRID:            String                  { get }
    var firebaseRequestRef:     FIRDatabaseReference    { get }
    var requestCreatedRef:      FIRDatabaseReference    { get }
    var requestAcceptedRef:     FIRDatabaseReference    { get }
    var requestCommunicatedRef: FIRDatabaseReference    { get }
    var requestServiceRef:      FIRDatabaseReference    { get }
    var requestPayedRef:        FIRDatabaseReference    { get }
    var requestReviewedRef:     FIRDatabaseReference    { get }
    var requestTimeRef:         FIRDatabaseReference    { get }
}
extension FirebaseRequestIDable
{
    var firebaseID: String
    {
        return firebaseRID
    }
    var firebaseRID: String
    {
        return privateFirebaseRID
    }
    var firebaseRequestRef: FIRDatabaseReference
    {
        return firebaseRID.firebaseRequestRef
    }
    var requestCreatedRef: FIRDatabaseReference
    {
        return firebaseRID.requestCreatedRef
    }
    var requestAcceptedRef: FIRDatabaseReference
    {
        return firebaseRID.requestAcceptedRef
    }
    var requestCommunicatedRef: FIRDatabaseReference
    {
        return firebaseRID.requestCommunicatedRef
    }
    var requestServiceRef: FIRDatabaseReference
    {
        return firebaseRID.requestServiceRef
    }
    var requestPayedRef: FIRDatabaseReference
    {
        return firebaseRID.requestPayedRef
    }
    var requestReviewedRef: FIRDatabaseReference
    {
        return firebaseRID.requestReviewedRef
    }
    var requestTimeRef: FIRDatabaseReference
    {
        return firebaseRID.requestTimeRef
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.FirebaseRequestIDable.keys
    }
}

protocol FirebaseUIDListType: FirebaseIDable
{
    var privateFirebaseUIDs:    String!     { get set }
    var firebaseUIDs:           String      { get }
    var firebaseUIDsList:       [String]    { get }
}
extension FirebaseUIDListType
{
    var firebaseUIDs: String
    {
        return privateFirebaseUIDs
    }
    var firebaseUIDsList: [String]
    {
        return firebaseUIDs.components(separatedBy: .whitespaces)
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.FirebaseUIDListType.keys
    }
}

protocol AllUsersType: FirebaseUserIDable {}

protocol RevieweeArchivable: FirebaseIDable, FirebaseUIDListType
{
    var reviewedUsers:          String      { get }
    var revieweesList:          [String]    { get }
}
extension RevieweeArchivable
{
    var reviewedUsers: String
    {
        return privateFirebaseUIDs
    }
    var revieweesList: [String]
    {
        return reviewedUsers.components(separatedBy: .whitespaces)
    }
    var keys: KeysType
    {
        return Constants.Protocols.RevieweeArchivable.keys
    }
}

protocol ReviewerArchivable: FirebaseIDable, FirebaseUIDListType
{
    var reviewers:          String      { get }
    var reviewersList:      [String]    { get }
}
extension ReviewerArchivable
{
    var reviewers: String
    {
        return privateFirebaseUIDs
    }
    var reviewersList: [String]
    {
        return reviewers.components(separatedBy: .whitespaces)
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.ReviewerArchivable.keys
    }
}

protocol Pushable
{
    func push()
}


protocol HappenedType: FirebaseIDable
{
    var privateOrNot:                       String!     { get set }
    var privateAtTime:                      String!     { get set }
    var orNot:                              String      { get }
    var atTime:                             String      { get }
    var yesOrNo:                            Bool        { get }
    var atDateAndTime:                      DateAndTime { get }
}
extension HappenedType
{
    var orNot: String
    {
        return privateOrNot
    }
    var atTime: String
    {
        return privateAtTime
    }
    var yesOrNo: Bool
    {
        return orNot.bool!
    }
    var atDateAndTime: DateAndTime
    {
        return DateAndTime(dateStringCustom: atTime)!
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.HappenedType.keys
    }
}

protocol Starting: FirebaseIDable
{
    var privateHasStarted:      String!         { get set }
    var privateStartedAtTime:   String!         { get set }
    var hasStarted:             String          { get }
    var startedAtTime:          String          { get }
    var started:                Bool            { get }
    var startedAtDateAndTime:   DateAndTime     { get }
}
extension Starting
{
    var hasStarted:             String
    {
        return privateHasStarted
    }
    var startedAtTime:          String
    {
        return privateStartedAtTime
    }
    var started:                Bool
    {
        return hasStarted.bool!
    }
    var startedAtDateAndTime:   DateAndTime
    {
        return DateAndTime(dateStringCustom: startedAtTime)!
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.Starting.keys
    }
}

protocol Ending: FirebaseIDable
{
    var privateHasEnded:    String!     { get set }
    var privateEndedAtTime: String!     { get set }
    var hasEnded:           String      { get }
    var endedAtTime:        String      { get }
    var ended:              Bool        { get }
    var endedAtDateAndTime: DateAndTime { get }
}
extension Ending
{
    var hasEnded: String
    {
        return privateHasEnded
    }
    var endedAtTime: String
    {
        return privateEndedAtTime
    }
    var ended: Bool
    {
        return hasEnded.bool!
    }
    var endedAtDateAndTime: DateAndTime
    {
        return DateAndTime(dateStringCustom: endedAtTime)!
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.Ending.keys
    }
}

protocol StudentInitiatable: Nameable, HappenedType, TimeIntervalCalculable
{
    var privateByStudent:                   String!         { get set }
    var byStudent:                          String          { get }
    var student:                            User            { get }
    var afterTimeInterval:                  TimeInterval    { get }
    var afterTimeOf:                        String          { get }
}
extension StudentInitiatable
{
    var byStudent:                          String
    {
        return privateByStudent
    }
    var afterTimeOf:                        String
    {
        return componentsFormatter.string(from: afterTimeInterval)!
    }
    
    var student:                            User
    {
        return User()
        //return Student(fromServerWithFirebaseUID: byStudent, forUserWhoIsACoachOrNot: false)!
    }
    var afterTimeInterval:                  TimeInterval
    {
        return intervalCalculator(start: student.logInDateAndTime, end: atDateAndTime)
    }
}

protocol CoachInitiatable: Nameable, HappenedType, TimeIntervalCalculable
{
    var privateByCoach:                     String!         { get set }
    var byCoach:                            String          { get }
    var afterTimeOf:                        String          { get }
    var coach:                              User            { get }
    var afterTimeInterval:                  TimeInterval    { get }
}
extension CoachInitiatable
{
    var byCoach:                            String
    {
        return privateByCoach
    }
    var afterTimeOf:                        String
    {
        return componentsFormatter.string(from: afterTimeInterval)!
    }
    
    var coach:                              User
    {
        return User()
        //return Coach(fromServerWithFirebaseUID: byCoach, forUserWhoIsACoachOrNot: true)!
    }
    var afterTimeInterval:                  TimeInterval
    {
        return intervalCalculator(start: coach.logInDateAndTime, end: atDateAndTime)
    }
}

extension Array where Element: ExpressibleByStringLiteral
{
    var boolsWithFailures: (bools: [Bool], indicesOfFailure: [Int])
    {
        var arrayOfBools    = [Bool]()
        var arrayOfIndices  = [Int]()
        for i in 1...self.count
        {
            if let bool = "\(self[i-1])".bool
            {
                arrayOfBools.append(bool)
            }
            else
            {
                arrayOfBools.append(true)
                arrayOfIndices.append(i-1)
            }
        }
        return (arrayOfBools, arrayOfIndices)
    }
    func flattenToString() -> String
    {
        var flattenedString = ""
        for element in self
        {
            flattenedString = "\(flattenedString)\(element)"
        }
        return flattenedString
    }
}

enum CallOrText: String
{
    case call
    case text
    case none
    
    var isCall: Bool
    {
        return self == .call
    }
    var isText: Bool
    {
        return self == .text
    }
    var isNone: Bool
    {
        return self == .none
    }
    
    static func fromArrayOf(callOrTextStrings: [String]) -> [CallOrText]
    {
        var arrayOfCallOrTexts      = [CallOrText]()
        for callOrTextString in callOrTextStrings
        {
            arrayOfCallOrTexts.append(CallOrText(rawValue: callOrTextString)!)
        }
        return arrayOfCallOrTexts
    }
}

protocol HappenedSequenceType: TimeIntervalCalculable
{
    var privateOrNot:   String!         { get set }
    var privateAtTimes: String!         { get set }
    var orNot:          String          { get }
    var atTimes:        String          { get }
    var yesOrNo:        Bool            { get }
    var atTimesList:    [String]        { get }
    var atDateAndTimes: [DateAndTime]   { get }
}
extension HappenedSequenceType
{
    var orNot: String
    {
        return privateOrNot
    }
    var yesOrNo: Bool
    {
        return orNot.bool!
    }
    var atTimes: String
    {
        return privateAtTimes
    }
    var atTimesList: [String]
    {
        return atTimes.components(separatedBy: .whitespaces)
    }
    var atDateAndTimes: [DateAndTime]
    {
        return DateAndTime.fromArrayOneCustomFormat(ofStrings: atTimesList)!
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.HappenedSequenceType.keys
    }
}

protocol CallOrTextSequenceType
{
    var privateByCallOrText:    String!         { get set }
    var byCallOrText:           String          { get }
    var byCallsOrTextsList:     [String]        { get }
    var callsOrTexts:           [CallOrText]    { get }
}
extension CallOrTextSequenceType
{
    var byCallOrText: String
    {
        return privateByCallOrText
    }
    var byCallsOrTextsList: [String]
    {
        return byCallOrText.components(separatedBy: .whitespaces)
    }
    var callsOrTexts: [CallOrText]
    {
        return CallOrText.fromArrayOf(callOrTextStrings: byCallsOrTextsList)
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.CallOrTextSequenceType.keys
    }
}

protocol CoachOrNotSequenceType
{
    var privateByCoachOrNot:    String!     { get set }
    var byCoachOrNot:           String      { get }
    var byCoachOrNotsList:      [String]    { get }
    var coachOrNots:            [Bool]      { get }
}
extension CoachOrNotSequenceType
{
    var byCoachOrNot: String
    {
        return privateByCoachOrNot
    }
    var byCoachOrNotsList: [String]
    {
        return byCoachOrNot.components(separatedBy: .whitespaces)
    }
    var coachOrNots: [Bool]
    {
        return byCoachOrNotsList.boolsWithFailures.bools
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.CoachOrNotSequenceType.keys
    }
}

typealias Dollars       = Double
typealias Cost          = Double
typealias Percentage    = Double
typealias Fraction      = Double

extension String
{
    var double: Double?
    {
        return Double(self)
    }
    var int: Int?
    {
        return Int(self)
    }
//    var isCoach: IsCoach
//    {
//        guard let bool = bool
//        else
//        {
//            return .none
//        }
//        switch bool
//        {
//        case true:
//            return .yes
//        case false:
//            return .no
//        }
//    }
}

extension Int
{
    var double: Double
    {
        return Double(self)
    }
    var string: String
    {
        return "\(self)"
    }
}

extension Double
{
    var string: String
    {
        return "\(self)"
    }
    var intGreater: Int
    {
        return Int(ceil(self))
    }
    var intLesser: Int
    {
        return Int(floor(self))
    }
}
extension Dollars
{
    var dollars: Int
    {
        return Int(floor(self))
    }
    var cents: Int
    {
        return Int((self - floor(self)) * 100)
    }
    var priceComponents: (dollars: Int, cents: Int)
    {
        return (dollars, cents)
    }
    var priceDescriptionSymbolic: String
    {
        return "$ \(dollars) and ¢ \(cents)"
    }
    var priceDescriptionWords: String
    {
        return "\(dollars) Dollars & \(cents) Cents"
    }
    func unitsOfService(rate: Double) -> Double
    {
        return self / rate
    }
}

extension Cost: TimeIntervalCalculable
{
    var perHour: Cost
    {
        return self
    }
    var perMinute: Cost
    {
        return self / 60.00
    }
    var perSecond: Cost
    {
        return self / 3600.00
    }
    var per8HourDay: Cost
    {
        return self * 8
    }
    var per40HoursWeek: Cost
    {
        return self * 8 * 5
    }
    func toTotalAmount(for time: TimeInterval) -> Dollars
    {
        return self.perSecond * time
    }
    func toCoachFeeAfter(deducting commission: Percentage, for time: TimeInterval) -> Dollars
    {
        return (self.perSecond * time) * (1 - commission.percentToFraction)
    }
    func toCommissionEarned(for commission: Percentage, for time: TimeInterval) -> Dollars
    {
        return (self.perSecond * time) * commission.percentToFraction
    }
}

extension Percentage
{
    var percentage: Percentage
    {
        return self
    }
    var percentToFraction: Fraction
    {
        return self / 100.00
    }
    var fractionToPercent: Percentage
    {
        return self * 100.00
    }
}

protocol Billable
{
    var privateCostPerHour:         String!     { get set }
    var costPerHour:                String      { get }
    var costInDollars:              Cost        { get }
}
extension Billable
{
    var costPerHour: String
    {
        return privateCostPerHour
    }
    var costInDollars: Dollars
    {
        return costPerHour.double!
    }
}

protocol Commissionable
{
    var privateCommision:           String!     { get set }
    var commission:                 String      { get }
    var commissionPercentage:       Percentage  { get }
    var commissionFraction:         Fraction    { get }
    var coachPercentage:            Percentage  { get }
    var coachFraction:              Fraction    { get }
}
extension Commissionable
{
    var commission: String
    {
        return privateCommision
    }
    var commissionPercentage: Percentage
    {
        return commission.double!
    }
    var commissionFraction: Fraction
    {
        return commissionPercentage.percentToFraction
    }
    var coachFraction: Fraction
    {
        return 1 - commissionFraction
    }
    var coachPercentage: Percentage
    {
        return coachFraction.fractionToPercent
    }
}

protocol Tippable
{
    var privateTip:                 String!     { get set }
    var tip:                        String      { get }
    var tipInDollars:               Dollars     { get }
}
extension Tippable
{
    var tip: String
    {
        return privateTip
    }
    var tipInDollars: Dollars
    {
        return tip.double!
    }
}

protocol TipCommissionable
{
    var privateTipCommission:       String!     { get set }
    var tipCommission:              String      { get }
    var tipCommissionPercentage:    Percentage  { get }
    var tipCommissionFraction:      Fraction    { get }
    var tipCoachPercentage:         Percentage  { get }
    var tipCoachFraction:           Fraction    { get }
}
extension TipCommissionable
{
    var tipCommission: String
    {
        return privateTipCommission
    }
    var tipCommissionPercentage: Percentage
    {
        return tipCommission.double!
    }
    var tipCommissionFraction:      Fraction
    {
        return tipCommissionPercentage.percentToFraction
    }
    var tipCoachFraction:           Fraction
    {
        return 1 - tipCommissionFraction
    }
    var tipCoachPercentage:         Percentage
    {
        return tipCoachFraction.fractionToPercent
    }
}

protocol RequestTimeSequenceType: TimeIntervalCalculable
{
    var intervalToCreate:       TimeInterval        { get }
    var intervalToAccept:       TimeInterval        { get }
    var intervalToCommunicate:  TimeInterval        { get }
    var intervalToStart:        TimeInterval        { get }
    var intervalToPay:          TimeInterval        { get }
    var intervalToReview:       TimeInterval        { get }
    
    var toCreate:               String              { get }
    var toAccept:               String              { get }
    var toCommunicate:          String              { get }
    var toStart:                String              { get }
    var toPay:                  String              { get }
    var toReview:               String              { get }
    
    var time:                   StringDictionary    { get }
}
extension RequestTimeSequenceType
{
    var toCreate: String
    {
        return componentsFormatter.string(from: intervalToCreate)!
    }
    var toAccept: String
    {
        return componentsFormatter.string(from: intervalToAccept)!
    }
    var toCommunicate: String
    {
        return componentsFormatter.string(from: intervalToCommunicate)!
    }
    var toStart: String
    {
        return componentsFormatter.string(from: intervalToStart)!
    }
    var toPay: String
    {
        return componentsFormatter.string(from: intervalToPay)!
    }
    var toReview: String
    {
        return componentsFormatter.string(from: intervalToReview)!
    }
    
    var time: StringDictionary
    {
        return  [
            Constants.Protocols.RequestTimeSequenceType.toCreate        : toCreate,
            Constants.Protocols.RequestTimeSequenceType.toAccept        : toAccept,
            Constants.Protocols.RequestTimeSequenceType.toCommunicate   : toCommunicate,
            Constants.Protocols.RequestTimeSequenceType.toStart         : toStart,
            Constants.Protocols.RequestTimeSequenceType.toPay           : toPay,
            Constants.Protocols.RequestTimeSequenceType.toReview        : toReview
                ]
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.RequestTimeSequenceType.keys
    }
}

protocol FirebaseLocationIDable: FirebaseIDable
{
    var privateFirebaseLID:     String!                 { get set }
    var firebaseLID:            String                  { get }
    var firebaseLocationRef:    FIRDatabaseReference    { get }
}
extension FirebaseLocationIDable
{
    var firebaseLID: String
    {
        return privateFirebaseLID
    }
    var firebaseLocationRef: FIRDatabaseReference
    {
        return firebaseLID.firebaseLocationRef
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.FirebaseLocationIDable.keys
    }
}

protocol Locatable
{
    var privateLocation: CLLocation! { get set }
}
extension Locatable
{
    var location: CLLocation
    {
        return privateLocation
    }
    
    var distanceFromWhiteBldg: CLLocationDistance
    {
        return getDistanceFromGym(.White)
    }
    var distanceFromRecHall: CLLocationDistance
    {
        return getDistanceFromGym(.Rec)
    }
    var distanceFromIMBldg: CLLocationDistance
    {
        return getDistanceFromGym(.IM)
    }
    
    func getDistanceFrom(_ object: Locatable) -> CLLocationDistance
    {
        return location.distance(from: object.location)
    }
    
    func getDistanceFromGym(_ building: Building) -> CLLocationDistance
    {
        return location.distance(from: building.location)
    }
}
