//
//  Constants.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/15/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

//import UIKit
import MapKit

import Firebase

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    var lowercaseFirst: String
    {
        return first.lowercased() + String(characters.dropFirst())
    }
}

extension Array
{
    func newArrayByAppendingSingle(element: Element) -> [Element]
    {
        var extendedArray = self
        extendedArray.append(element)
        return extendedArray
    }
    
    func newArrayByAppendingMultiple(elements: [Element]) -> [Element]
    {
        var extendedArray = self
        for element in elements
        {
            extendedArray.append(element)
        }
        return extendedArray
    }
}

extension Array where Element: ExpressibleByStringLiteral
{
    var lowercaseFirst: [String]
    {
        return self.map {"\($0)".lowercaseFirst}
    }
    
    func chopFromSelf(fragment: String) -> [String]
    {
        var choppedArray = [String]()
        for element in self
        {
            if "\(element)".contains(fragment)
            {
                choppedArray.append("\(element)".replacingOccurrences(of: fragment, with: Constants.Literal.Empty))
            }
            else
            {
                choppedArray.append("\(element)")
            }
        }
        return choppedArray
    }
}

func addArray<T>(first: [T], with second: [T]) -> [T]
{
    var sum     = [T]()
    sum         = first.newArrayByAppendingMultiple(elements: second)
    return sum
}

func addArrayOf<T>(arrays: [[T]]) -> [T]
{
    var sum     = [T]()
    for array in arrays
    {
        sum     = sum.newArrayByAppendingMultiple(elements: array)
    }
    return sum
}

extension RawRepresentable
{
    var stringLowerCase: String
    {
        return "\(self)".lowercaseFirst
    }
    
    var stringCapitalized: String
    {
        return "\(self)".capitalized
    }
    
    var bool: Bool?
    {
        return self.stringLowerCase.bool
    }
}

enum TrueOrFalse: String
{
    case True
    case False
}

enum YesOrNo: String
{
    case Yes
    case No
}

enum SuccessOrFailure: String
{
    case Success
    case Failure
}

enum SucceededOrFailed: String
{
    case Succeeded
    case Failed
}

enum PassOrFail: String
{
    case Pass
    case Fail
}

extension Bool
{
    var stringYesNo: String
    {
        return self == true ? YesOrNo.Yes.stringLowerCase : YesOrNo.No.stringLowerCase
    }
    var stringTrueFalse: String
    {
        return self == true ? TrueOrFalse.True.stringLowerCase : TrueOrFalse.False.stringLowerCase
    }
    var stringSuccessOrFailure: String
    {
        return self == true ? SuccessOrFailure.Success.stringLowerCase : SuccessOrFailure.Failure.stringLowerCase
    }
    var stringSucceededOrFailed: String
    {
        return self == true ? SucceededOrFailed.Succeeded.stringLowerCase : SucceededOrFailed.Failed.stringLowerCase
    }
    var stringPassOrFail: String
    {
        return self == true ? PassOrFail.Pass.stringLowerCase : PassOrFail.Fail.stringLowerCase
    }
}

extension String
{
    var removeLast: String
    {
        var trimmed = self
        trimmed.remove(at: trimmed.index(before: trimmed.endIndex))
        return trimmed
    }
    var trueStrings: [String]
    {
        return ["true", "yes", "pass", "success", "succeeded", "start"]
    }
    var falseStrings: [String]
    {
        return ["false", "no", "fail", "failure", "failed", "stop"]
    }
    var truthStrings: [String]
    {
        return trueStrings + falseStrings
    }
    var bool: Bool?
    {
        if truthStrings.contains(self)
        {
            return trueStrings.contains(self)
        }
        else
        {
            print("The string (\(self)) is not one of the truth strings (\(truthStrings))")
            return nil
        }
    }
}

struct Constants {
    
    struct DataService
    {
        struct Firebase
        {
            static let BaseURL = FIRDatabase.database().reference()
            static let Provider = "firebase"
            static let Locations = "locations"
            static let Requests = "requests"
            static let Users = "users"
            static let Coaches = "coaches"
        }
        struct Mirror
        {
            static let Firebase = Constants.DataService.Firebase.Provider.capitalized
            static let Locations = Constants.DataService.Firebase.Locations.capitalized
            static let Requests = Constants.DataService.Firebase.Requests.capitalized
            static let Users = Constants.DataService.Firebase.Users.capitalized
            static let Coaches = Constants.DataService.Firebase.Coaches.capitalized
        }
        struct User
        {
            static let UID = Constants.Firebase.KeychainWrapper.KeyUID
            static let Location = Constants.DataService.Firebase.Locations.removeLast
            static let Name = "name"
            static let Provider = "provider"
            static let Cell = "cellNumber"
            static let Email = Constants.Facebook.Key.Email
            static let Requests = Constants.DataService.Firebase.Requests
        }
    }
    
    struct Dictionary
    {
        struct Key
        {
            static let privateSmalls        = "private"
            static let privateCapitalized   = Constants.Dictionary.Key.privateSmalls.capitalized
        }
    }
    
    struct Literal
    {
        static let Empty                            = ""
    }
    
    struct Facebook
    {
        struct Profile
        {
            static let ImageURLPrefix = "https://graph.facebook.com/"
            static let ImageURLSuffix = "/picture?type=large&w‌ idth=1000&height=1000"
        }
        
        struct Key
        {
            static let Provider = "provider"
            static let Profile = "profile"
            static let Name = "name"
            static let Email = "email"
            static let UID = "facebookUID"
            static let ImageURLString = "imageURL"
        }
    }
    
    struct Firebase
    {
        struct KeychainWrapper
        {
            static let KeyUID = "uid"
        }
        struct Key
        {
            static let UID = "firebaseUID"
        }
    }
    
    struct SignUpVC
    {
        struct Segue
        {
            static let SignUpToSetGym = "SignUpToSetGym"
            static let SignUpToSetGymMap = "SignUpToSetGymMap"
            static let SignUpToSaveCellNumber = "SignUpToSaveCellNumber"
            static let SignUpToCoachRequests = "SignUpToCoachRequests"
        }
    }
    
    struct CoachRequestsVC
    {
        struct Segue
        {
            static let CoachRequestsToSignUp = "CoachRequestsToSignUp"
        }
        
        struct Cell
        {
            static let Request = "Request"
        }
    }
    
    struct Protocols
    {
        struct Keys
        {
            var set:        [String]
            var get:        [String]
            var other:      [String]
            var firebase:   [String]
            
            init    (
                set:
                [String]? = nil,
                get:
                [String]? = nil,
                other:
                [String]? = nil,
                firebase:
                [String]? = nil
                )
            {
                if let set = set
                {
                    self.set = set
                }
                else
                {
                    self.set = [""]
                }
                if let get = get
                {
                    self.get = get
                }
                else
                {
                    self.get = self.set.chopFromSelf(fragment: "private").lowercaseFirst
                }
                if let other = other
                {
                    self.other = other
                }
                else
                {
                    self.other = [""]
                }
                if let firebase = firebase
                {
                    self.firebase = firebase
                }
                else
                {
                    self.firebase = self.get
                }
            }
            init(set: [String])
            {
                self.init(set: set, get: nil, other: nil, firebase: nil)
            }
            init(set: [String], other: [String])
            {
                self.init(set: set, get: nil, other: other, firebase: nil)
            }
            init(set: [String], other: [String], firebase: [String])
            {
                self.init(set: set, get: nil, other: other, firebase: firebase)
            }
            init(set: [String], get: [String], other: [String])
            {
                self.init(set: set, get: get, other: other, firebase: nil)
            }
            init(get: [String])
            {
                self.init(set: nil, get: get, other: nil, firebase: nil)
            }
            init(get: [String], other: [String])
            {
                self.init(set: nil, get: get, other: other, firebase: nil)
            }
            init(other: [String], firebase: [String])
            {
                self.init(set: nil, get: nil, other: other, firebase: firebase)
            }
        }
        
        struct CoachTaggable
        {
            static let privateIsCoach           =       "privateIsCoach"
            static let isCoach                  =       "isCoach"
            static let coachOrNot               =       "coachOrNot"
            
            static let keys                     =   Keys    (
                set:
                [
                    CoachTaggable.privateIsCoach
                ],
                other:
                [
                    CoachTaggable.coachOrNot
                ]
            )
        }
        
        struct FirebaseUserIDable
        {
            static let privateFirebaseUID       =       "privateFirebaseUID"
            static let firebaseUID              =       "firebaseUID"
            static let firebaseUserRef          =       "firebaseUserRef"
            
            static let setKeys                  =       CoachTaggable.keys.set
                .newArrayByAppendingSingle  (
                    element:
                    FirebaseUserIDable.privateFirebaseUID
            )
            static let getKeys                  =       CoachTaggable.keys.get
                .newArrayByAppendingSingle  (
                    element:
                    FirebaseUserIDable.firebaseUID
            )
            static let otherKeys                =       CoachTaggable.keys.other
                .newArrayByAppendingSingle  (
                    element:
                    FirebaseUserIDable.firebaseUserRef
            )
            static let firebaseKeys             =       CoachTaggable.keys.firebase
                .newArrayByAppendingSingle  (
                    element:
                    FirebaseUserIDable.firebaseUID
            )
            static let keys                     =   Keys    (
                set:
                FirebaseUserIDable.setKeys,
                get:
                FirebaseUserIDable.getKeys,
                other:
                FirebaseUserIDable.otherKeys,
                firebase:
                FirebaseUserIDable.firebaseKeys
            )
        }
        
        struct ProviderSpecifiable
        {
            static let privateProvider          =       "privateProvider"
            static let provider                 =       "provider"
            static let keys                     =   Keys    (
                set:
                [
                    ProviderSpecifiable.privateProvider
                ]
            )
        }
        
        struct LoginTimeStampable
        {
            static let privateLoggedInAtTime    =       "privateLoggedInAtTime"
            static let loggedInAtTime           =       "loggedInAtTime"
            static let logInDateAndTime         =       "logInDateAndTime"
            
            static let keys                     =   Keys    (
                set:
                [
                    LoginTimeStampable.privateLoggedInAtTime
                ],
                other:
                [
                    LoginTimeStampable.logInDateAndTime
                ]
            )
        }
        
        struct FacebookUserIDable
        {
            static let privateFacebookUID       =       "privateFacebookUID"
            static let facebookUID              =       "facebookUID"
            
            static let keys                     =   Keys    (
                set:
                [
                    FacebookUserIDable.privateFacebookUID
                ]
            )
        }
        
        struct FacebookImageRetrievable
        {
            static let facebookImageURL         =       "facebookImageURL"
            
            static let getKeys                  =       FacebookUserIDable.keys.get
                .newArrayByAppendingSingle  (
                    element:
                    FacebookImageRetrievable.facebookImageURL
            )
            static let keys                     =   Keys    (
                set:
                FacebookUserIDable      .keys.set,
                get:
                FacebookImageRetrievable.getKeys,
                other:
                FacebookUserIDable      .keys.other,
                firebase:
                FacebookUserIDable      .keys.firebase
            )
        }
        
        struct Nameable
        {
            static let privateFullName          =       "privateFullName"
            static let fullName                 =       "fullName"
            static let firstName                =       "firstName"
            static let nameTriplet              =       "nameTriplet"
            
            static let keys                     =   Keys    (
                set:
                [
                    Nameable.privateFullName
                ],
                get:
                [
                    Nameable.fullName,
                    Nameable.firstName
                ],
                other:
                [
                    Nameable.nameTriplet
                ]
            )
        }
        
        struct Emailable
        {
            static let privateEmail             =       "privateEmail"
            static let email                    =       "email"
            static let keys                     =   Keys    (
                set:
                [
                    Emailable.privateEmail
                ]
            )
        }
        
        struct Textable
        {
            static let privateCell              =       "privateCell"
            static let cell                     =       "cell"
            static let keys                     =   Keys    (
                set:
                [
                    Textable.privateCell
                ]
            )
        }
        
        struct RequestArchivable
        {
            static let privateRequests          =       "privateRequests"
            static let requests                 =       "requests"
            static let requestsList             =       "requestsList"
            
            static let keys                     =   Keys    (
                set:
                [
                    RequestArchivable.privateRequests
                ],
                other:
                [
                    RequestArchivable.requestsList
                ]
            )
        }
        
        struct RatingArchivable
        {
            static let privateRating            =       "privateRating"
            static let privateRatings           =       "privateRatings"
            
            static let rating                   =       "rating"
            static let ratings                  =       "ratings"
            
            static let ratingAverage            =       "ratingAverage"
            static let ratingsList              =       "ratingsList"
            
            static let keys                     =   Keys    (
                set:
                [
                    RatingArchivable.privateRating,
                    RatingArchivable.privateRatings
                ],
                other:
                [
                    RatingArchivable.ratingAverage,
                    RatingArchivable.ratingsList
                ]
            )
        }
        
        struct ReviewArchivable
        {
            static let privateReviews           =       "privateReviews"
            static let reviews                  =       "reviews"
            static let reviewsList              =       "reviewsList"
            
            static let keys                     =   Keys    (
                set:
                [
                    ReviewArchivable.privateReviews
                ],
                other:
                [
                    ReviewArchivable.reviewsList
                ]
            )
        }
        
        struct AllUsersType
        {
            static let keys                     =       FirebaseUserIDable.keys
        }
        
        struct UserType
        {
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    FirebaseUserIDable      .keys.set,
                    ProviderSpecifiable     .keys.set,
                    LoginTimeStampable      .keys.set,
                    FacebookImageRetrievable.keys.set,
                    Nameable                .keys.set,
                    Emailable               .keys.set,
                    Textable                .keys.set,
                    FirebaseRequestIDable   .keys.set,
                    RequestArchivable       .keys.set,
                    FirebaseUIDListType     .keys.set,
                    RatingArchivable        .keys.set,
                    ReviewArchivable        .keys.set
                ]
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    FirebaseUserIDable      .keys.get,
                    ProviderSpecifiable     .keys.get,
                    LoginTimeStampable      .keys.get,
                    FacebookImageRetrievable.keys.get,
                    Nameable                .keys.get,
                    Emailable               .keys.get,
                    Textable                .keys.get,
                    FirebaseRequestIDable   .keys.get,
                    RequestArchivable       .keys.get,
                    FirebaseUIDListType     .keys.get,
                    RatingArchivable        .keys.get,
                    ReviewArchivable        .keys.get
                ]
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    FirebaseUserIDable      .keys.other,
                    ProviderSpecifiable     .keys.other,
                    LoginTimeStampable      .keys.other,
                    FacebookImageRetrievable.keys.other,
                    Nameable                .keys.other,
                    Emailable               .keys.other,
                    Textable                .keys.other,
                    FirebaseRequestIDable   .keys.other,
                    RequestArchivable       .keys.other,
                    FirebaseUIDListType     .keys.other,
                    RatingArchivable        .keys.other,
                    ReviewArchivable        .keys.other
                ]
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    FirebaseUserIDable      .keys.firebase,
                    ProviderSpecifiable     .keys.firebase,
                    LoginTimeStampable      .keys.firebase,
                    FacebookImageRetrievable.keys.firebase,
                    Nameable                .keys.firebase,
                    Emailable               .keys.firebase,
                    Textable                .keys.firebase,
                    FirebaseRequestIDable   .keys.firebase,
                    RequestArchivable       .keys.firebase,
                    FirebaseUIDListType     .keys.firebase,
                    RatingArchivable        .keys.firebase,
                    ReviewArchivable        .keys.firebase
                ]
            )
            static let keys                     =   Keys    (
                set:
                UserType                .setKeys,
                get:
                UserType                .getKeys,
                other:
                UserType                .otherKeys,
                firebase:
                UserType                .firebaseKeys
            )
        }
        
        struct FirebaseUIDListType
        {
            static let privateFirebaseUIDs      =       "privateFirebaseUIDs"
            static let firebaseUIDs             =       "firebaseUIDs"
            static let firebaseUIDsList         =       "firebaseUIDsList"
            
            static let keys                     =   Keys    (
                set:
                [
                    FirebaseUIDListType.privateFirebaseUIDs
                ],
                other:
                [
                    FirebaseUIDListType.firebaseUIDsList
                ]
            )
        }
        
        struct RevieweeArchivable
        {
            static let revieweeUsers            =       "revieweeUsers"
            static let revieweesList            =       "revieweesList"
            static let keys                     =   Keys    (
                get:
                [
                    RevieweeArchivable.revieweeUsers
                ],
                other:
                [
                    RevieweeArchivable.revieweesList
                ]
            )
        }
        
        struct ReviewerArchivable
        {
            static let reviewers                =       "reviewers"
            static let reviewersList            =       "reviewersList"
            
            static let keys                     =   Keys    (
                get:
                [
                    ReviewerArchivable.reviewers
                ],
                other:
                [
                    ReviewerArchivable.reviewersList
                ]
            )
        }
        
        struct StudentType
        {
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.set,
                    RevieweeArchivable  .keys.set
                ]
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.get,
                    RevieweeArchivable  .keys.get
                ]
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.other,
                    RevieweeArchivable  .keys.other
                ]
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.firebase,
                    RevieweeArchivable  .keys.firebase
                ]
            )
            static let keys                     =   Keys    (
                set:
                StudentType         .setKeys,
                get:
                StudentType         .getKeys,
                other:
                StudentType         .otherKeys,
                firebase:
                StudentType         .firebaseKeys
            )
        }
        
        struct CoachType
        {
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.set,
                    ReviewerArchivable  .keys.set
                ]
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.get,
                    ReviewerArchivable  .keys.get
                ]
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.other,
                    ReviewerArchivable  .keys.other
                ]
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    UserType            .keys.firebase,
                    ReviewerArchivable  .keys.firebase
                ]
            )
            static let keys                     =   Keys    (
                set:
                CoachType           .setKeys,
                get:
                CoachType           .getKeys,
                other:
                CoachType           .otherKeys,
                firebase:
                CoachType           .firebaseKeys
            )
        }
        
        struct FirebaseRequestIDable
        {
            static let privateFirebaseRID       =       "privateFirebaseRID"
            static let firebaseRID              =       "firebaseRID"
            static let firebaseRequestRef       =       "firebaseRequestRef"
            static let requestCreatedRef        =       "requestCreatedRef"
            static let requestAcceptedRef       =       "requestAcceptedRef"
            static let requestCommunicatedRef   =       "requestCommunicatedRef"
            static let requestServiceRef        =       "requestServiceRef"
            static let requestPayedRef          =       "requestPayedRef"
            static let requestReviewedRef       =       "requestReviewedRef"
            static let requestTimeRef           =       "requestTimeRef"
            
            static let keys                     =   Keys    (
                set:
                [
                    FirebaseRequestIDable.privateFirebaseRID
                ],
                other:
                [
                    FirebaseRequestIDable.firebaseRequestRef,
                    FirebaseRequestIDable.requestCreatedRef,
                    FirebaseRequestIDable.requestAcceptedRef,
                    FirebaseRequestIDable.requestCommunicatedRef,
                    FirebaseRequestIDable.requestServiceRef,
                    FirebaseRequestIDable.requestPayedRef,
                    FirebaseRequestIDable.requestReviewedRef,
                    FirebaseRequestIDable.requestTimeRef
                ]
            )
        }
        
        struct HappenedType
        {
            static let privateOrNot             =       "privateOrNot"
            static let privateAtTime            =       "privateAtTime"
            static let orNot                    =       "orNot"
            static let atTime                   =       "atTime"
            static let yesOrNo                  =       "yesOrNo"
            static let atDateAndTime            =       "atDateAndTime"
            
            static let keys                     =   Keys    (
                set:
                [
                    HappenedType.privateOrNot,
                    HappenedType.privateAtTime
                ],
                other:
                [
                    HappenedType.yesOrNo,
                    HappenedType.atDateAndTime
                ]
            )
        }
        
        struct Starting
        {
            static let privateHasStarted        =       "privateHasStarted"
            static let privateStartedAtTime     =       "privateStartedAtTime"
            static let hasStarted               =       "hasStarted"
            static let startedAtTime            =       "startedAtTime"
            static let started                  =       "started"
            static let startedAtDateAndTime     =       "startedAtDateAndTime"
            
            static let keys                     =   Keys    (
                set:
                [
                    Starting.privateHasStarted,
                    Starting.privateStartedAtTime
                ],
                other:
                [
                    Starting.started,
                    Starting.startedAtDateAndTime
                ]                                                            )
        }
        
        struct Ending
        {
            static let privateHasEnded          =       "privateHasEnded"
            static let privateEndedAtTime       =       "privateEndedAtTime"
            static let hasEnded                 =       "hasEnded"
            static let endedAtTime              =       "endedAtTime"
            static let ended                    =       "ended"
            static let endedAtDateAndTime       =       "endedAtDateAndTime"
            
            static let keys                     =   Keys    (
                set:
                [
                    Ending.privateHasEnded,
                    Ending.privateEndedAtTime
                ],
                other:
                [
                    Ending.ended,
                    Ending.endedAtDateAndTime
                ]
            )
        }
        
        struct ActivityType
        {
            static let timeInterval             =       "timeInterval"
            static let duration                 =       "duration"
            
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    Starting                .keys.set,
                    Ending                  .keys.set,
                    FirebaseRequestIDable   .keys.set
                ]
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    Starting                .keys.get,
                    Ending                  .keys.get,
                    FirebaseRequestIDable   .keys.get
                ]
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    Starting                .keys.other,
                    Ending                  .keys.other,
                    ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        ActivityType            .timeInterval,
                        ActivityType            .duration
                    ]
            )
            static let firebaseKeys             =   ActivityType                .getKeys
                .newArrayByAppendingSingle  (
                    element:
                    ActivityType            .duration
            )
            static let keys                     =   Keys    (
                set:
                ActivityType.setKeys,
                get:
                ActivityType.getKeys,
                other:
                ActivityType.otherKeys,
                firebase:
                ActivityType.firebaseKeys
            )
        }
        
        struct StudentInitiatable
        {
            static let privateByStudent         =       "privateByStudent"
            static let byStudent                =       "byStudent"
            
            static let student                  =       "student"
            static let afterTimeInterval        =       "afterTimeInterval"
            static let afterTimeOf              =       "afterTimeOf"
            
            static let setKeys                  =       HappenedType.keys.set
                .newArrayByAppendingSingle  (
                    element:
                    StudentInitiatable.privateByStudent
            )
            static let getKeys                  =       HappenedType.keys.get
                .newArrayByAppendingSingle  (
                    element:
                    StudentInitiatable.byStudent
            )
            static let otherKeys                =       HappenedType.keys.other
                .newArrayByAppendingMultiple(
                    elements:
                    [
                        StudentInitiatable.afterTimeOf,
                        StudentInitiatable.afterTimeInterval,
                        StudentInitiatable.student
                    ]
            )
            static let firebaseKeys             =       StudentInitiatable.getKeys
                .newArrayByAppendingSingle  (
                    element:
                    StudentInitiatable.afterTimeOf
            )
            static let keys                     =   Keys    (
                set:
                StudentInitiatable.setKeys,
                get:
                StudentInitiatable.getKeys,
                other:
                StudentInitiatable.otherKeys,
                firebase:
                StudentInitiatable.firebaseKeys
            )
        }
        
        struct CoachInitiatable
        {
            static let privateByCoach           =       "privateByCoach"
            static let byCoach                  =       "byCoach"
            
            static let afterTimeOf              =       "afterTimeOf"
            static let coach                    =       "coach"
            static let afterTimeInterval        =       "afterTimeInterval"
            
            static let setKeys                  =   HappenedType.keys.set
                .newArrayByAppendingSingle  (
                    element:
                    CoachInitiatable.privateByCoach
            )
            static let getKeys                  =   HappenedType.keys.get
                .newArrayByAppendingSingle  (
                    element:
                    CoachInitiatable.byCoach
            )
            static let otherKeys                =   HappenedType.keys.other
                .newArrayByAppendingMultiple(
                    elements:
                    [
                        CoachInitiatable.afterTimeOf,
                        CoachInitiatable.afterTimeInterval,
                        CoachInitiatable.coach
                    ]
            )
            static let firebaseKeys             =   CoachInitiatable.getKeys
                .newArrayByAppendingSingle  (
                    element:
                    CoachInitiatable.afterTimeOf
            )
            static let keys                     =   Keys    (
                set:
                CoachInitiatable.setKeys,
                get:
                CoachInitiatable.getKeys,
                other:
                CoachInitiatable.otherKeys,
                firebase:
                CoachInitiatable.firebaseKeys
            )
        }
        
        struct Creatable
        {
            static let privateForGym            =       "privateForGym"
            
            static let forGym                   =       "forGym"
            
            static let gym                      =       "gym"
            static let timeIntervalOfLife       =       "timeIntervalOfLife"
            static let lengthOfLife             =       "lengthOfLife"
            
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    StudentInitiatable      .keys.set,
                    Ending                  .keys.set,
                    FirebaseRequestIDable   .keys.set
                ]
                )
                .newArrayByAppendingSingle  (
                    element:
                    Creatable.privateForGym
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    StudentInitiatable      .keys.get,
                    Ending                  .keys.get,
                    FirebaseRequestIDable   .keys.get
                ]
                )
                .newArrayByAppendingSingle  (
                    element:
                    Creatable.forGym
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    StudentInitiatable      .keys.other,
                    Ending                  .keys.other,
                    FirebaseRequestIDable   .keys.other
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Creatable               .gym,
                        Creatable               .timeIntervalOfLife,
                        Creatable               .lengthOfLife
                    ]
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    StudentInitiatable      .keys.firebase,
                    Ending                  .keys.firebase,
                    FirebaseRequestIDable   .keys.firebase
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Creatable               .forGym,
                        Creatable               .lengthOfLife
                    ]
            )
            static let keys                     =   Keys    (
                set:
                Creatable               .setKeys,
                get:
                Creatable               .getKeys,
                other:
                Creatable               .otherKeys,
                firebase:
                Creatable               .firebaseKeys
            )
        }
        
        struct Acceptable
        {
            static let privateAndIsAtTheGym     =       "privateAndIsAtTheGym"
            static let privateAndTimeToReach    =       "privateAndTimeToReach"
            static let andIsAtTheGym            =       "andIsAtTheGym"
            static let andTimeToReach           =       "andTimeToReach"
            static let atTheGym                 =       "atTheGym"
            static let timeIntervalToReach      =       "timeIntervalToReach"
            
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    CoachInitiatable        .keys.set,
                    FirebaseRequestIDable   .keys.set
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Acceptable.privateAndIsAtTheGym,
                        Acceptable.privateAndIsAtTheGym
                    ]
            )
            
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    CoachInitiatable        .keys.get,
                    FirebaseRequestIDable   .keys.get
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Acceptable              .andIsAtTheGym,
                        Acceptable              .andTimeToReach
                    ]
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    CoachInitiatable        .keys.other,
                    FirebaseRequestIDable   .keys.other
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Acceptable              .atTheGym,
                        Acceptable              .timeIntervalToReach
                    ]
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    CoachInitiatable        .keys.firebase,
                    FirebaseRequestIDable   .keys.firebase
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Acceptable          .andIsAtTheGym,
                        Acceptable          .andTimeToReach
                    ]
            )
            static let keys                     =   Keys    (
                set:
                Acceptable              .setKeys,
                get:
                Acceptable              .getKeys,
                other:
                Acceptable              .otherKeys,
                firebase:
                Acceptable              .firebaseKeys
            )
        }
        
        struct HappenedSequenceType
        {
            static let privateOrNot             =       "privateOrNot"
            static let privateAtTimes           =       "privateAtTimes"
            static let orNot                    =       "orNot"
            static let atTimes                  =       "atTimes"
            static let yesOrNo                  =       "yesOrNo"
            static let atTimesList              =       "atTimesList"
            static let atDateAndTimes           =       "atDateAndTimes"
            
            static let keys                     =   Keys    (
                set:
                [
                    HappenedSequenceType.privateOrNot,
                    HappenedSequenceType.privateAtTimes
                ],
                other:
                [
                    HappenedSequenceType.yesOrNo,
                    HappenedSequenceType.atTimesList,
                    HappenedSequenceType.atDateAndTimes
                ]
            )
        }
        
        struct CallOrTextSequenceType
        {
            static let privateByCallOrText      =       "privateByCallOrText"
            static let byCallOrText             =       "byCallOrText"
            static let byCallsOrTextsList       =       "byCallsOrTextsList"
            static let callsOrTexts             =       "callsOrTexts"
            
            static let keys                     =   Keys    (
                set:
                [
                    CallOrTextSequenceType.privateByCallOrText
                ],
                other:
                [
                    CallOrTextSequenceType.byCallsOrTextsList,
                    CallOrTextSequenceType.callsOrTexts
                ]
            )
        }
        
        struct CoachOrNotSequenceType
        {
            static let privateByCoachOrNot      =       "privateByCoachOrNot"
            static let byCoachOrNot             =       "byCoachOrNot"
            static let byCoachOrNotsList        =       "byCoachOrNotsList"
            static let coachOrNots              =       "coachOrNots"
            
            static let keys                     =   Keys    (
                set:
                [
                    CoachOrNotSequenceType.privateByCoachOrNot
                ],
                other:
                [
                    CoachOrNotSequenceType.byCoachOrNotsList,
                    CoachOrNotSequenceType.coachOrNots
                ]
            )
        }
        
        struct Communicable
        {
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    HappenedSequenceType    .keys.set,
                    CallOrTextSequenceType  .keys.set,
                    CoachOrNotSequenceType  .keys.set,
                    FirebaseRequestIDable   .keys.set
                ]
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    HappenedSequenceType    .keys.get,
                    CallOrTextSequenceType  .keys.get,
                    CoachOrNotSequenceType  .keys.get,
                    FirebaseRequestIDable   .keys.get
                ]
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    HappenedSequenceType    .keys.other,
                    CallOrTextSequenceType  .keys.other,
                    CoachOrNotSequenceType  .keys.other,
                    FirebaseRequestIDable   .keys.other
                ]
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    HappenedSequenceType    .keys.firebase,
                    CallOrTextSequenceType  .keys.firebase,
                    CoachOrNotSequenceType  .keys.firebase,
                    FirebaseRequestIDable   .keys.firebase
                ]
            )
            static let keys                     =   Keys    (
                set:
                Communicable            .setKeys,
                get:
                Communicable            .getKeys,
                other:
                Communicable            .otherKeys,
                firebase:
                Communicable            .firebaseKeys
            )
        }
        
        
        struct Billable
        {
            static let privateCostPerHour       =       "privateCostPerHour"
            static let costPerHour              =       "costPerHour"
            static let costInDollars            =       "costInDollars"
            
            static let keys                     =   Keys    (
                set:
                [
                    Billable.privateCostPerHour
                ],
                other:
                [
                    Billable.costInDollars
                ]
            )
        }
        
        struct Commissionable
        {
            static let privateCommision         =       "privateCommision"
            static let commission               =       "commission"
            static let commissionPercentage     =       "commissionPercentage"
            static let commissionFraction       =       "commissionFraction"
            static let coachPercentage          =       "coachPercentage"
            static let coachFraction            =       "coachFraction"
            
            static let keys                     =   Keys    (
                set:
                [
                    Commissionable          .privateCommision
                ],
                other:
                [
                    Commissionable          .commissionPercentage,
                    Commissionable          .commissionFraction,
                    Commissionable          .coachPercentage,
                    Commissionable          .coachFraction
                ]
            )
        }
        
        struct Tippable
        {
            static let privateTip               =       "privateTip"
            static let tip                      =       "tip"
            static let tipInDollars             =       "tipInDollars"
            
            static let keys                     =   Keys    (
                set:
                [
                    Tippable                .privateTip
                ],
                other:
                [
                    Tippable                .tipInDollars
                ]
            )
        }
        
        struct TipCommissionable
        {
            static let privateTipCommission     =       "privateTipCommission"
            static let tipCommission            =       "tipCommission"
            static let tipCommissionPercentage  =       "tipCommissionPercentage"
            static let tipCommissionFraction    =       "tipCommissionFraction"
            static let tipCoachPercentage       =       "tipCoachPercentage"
            static let tipCoachFraction         =       "tipCoachFraction"
            
            static let keys                     =   Keys    (
                set:
                [
                    TipCommissionable       .privateTipCommission
                ],
                other:
                [
                    TipCommissionable       .tipCommissionPercentage,
                    TipCommissionable       .tipCommissionFraction,
                    TipCommissionable       .tipCoachPercentage,
                    TipCommissionable       .tipCoachFraction
                ]
            )
        }
        
        struct Payable // Billable, Commissionable, Tippable, TipCommissionable, FirebaseRequestIDable
        {
            static let coachFee                 =       "coachFee"
            static let coachFeeInDollars        =       "coachFeeInDollars"
            
            static let amount                   =       "amount"
            static let coachAmount              =       "coachAmount"
            static let commissionEarned         =       "commissionEarned"
            static let tipCoach                 =       "tipCoach"
            static let tipCommissionEarned      =       "tipCommissionEarned"
            
            static let amountInDollars          =       "amountInDollars"
            static let coachAmountInDollars     =       "coachAmountInDollars"
            static let commissionInDollars      =       "commissionInDollars"
            static let tipCoachInDollars        =       "tipCoachInDollars"
            static let tipCommissionInDollars   =       "tipCommissionInDollars"
            
            static let totalPayed               =       "totalPayed"
            static let totalCoachAmount         =       "totalCoachAmount"
            static let totalCommission          =       "totalCommission"
            
            static let totalPayedInDollars      =       "totalPayedInDollars"
            static let totalCoachAmountInDollar =       "totalCoachAmountInDollars"
            static let totalCommissionInDollars =       "totalCommissionInDollars"
            
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    Billable                .keys.set,
                    Commissionable          .keys.set,
                    Tippable                .keys.set,
                    TipCommissionable       .keys.set,
                    FirebaseRequestIDable   .keys.set
                ]
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    Billable                .keys.get,
                    Commissionable          .keys.get,
                    Tippable                .keys.get,
                    TipCommissionable       .keys.get,
                    FirebaseRequestIDable   .keys.get
                ]
            )
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    Billable                .keys.other,
                    Commissionable          .keys.other,
                    Tippable                .keys.other,
                    TipCommissionable       .keys.other,
                    FirebaseRequestIDable   .keys.other
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Payable                 .coachFeeInDollars,
                        Payable                 .amountInDollars,
                        Payable                 .coachAmountInDollars,
                        Payable                 .commissionInDollars,
                        Payable                 .tipCoachInDollars,
                        Payable                 .tipCommissionInDollars,
                        Payable                 .totalPayedInDollars,
                        Payable                 .totalCoachAmountInDollar,
                        Payable                 .totalCommissionInDollars,
                        
                        Payable                 .coachFee,
                        Payable                 .amount,
                        Payable                 .coachAmount,
                        Payable                 .commissionEarned,
                        Payable                 .tipCoach,
                        Payable                 .tipCommissionEarned,
                        Payable                 .totalPayed,
                        Payable                 .totalCoachAmount,
                        Payable                 .totalCommission
                    ]
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    Billable                .keys.firebase,
                    Commissionable          .keys.firebase,
                    Tippable                .keys.firebase,
                    TipCommissionable       .keys.firebase,
                    FirebaseRequestIDable   .keys.firebase
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Payable                 .coachFee,
                        Payable                 .amount,
                        Payable                 .coachAmount,
                        Payable                 .commissionEarned,
                        Payable                 .tipCoach,
                        Payable                 .tipCommissionEarned,
                        Payable                 .totalPayed,
                        Payable                 .totalCoachAmount,
                        Payable                 .totalCommission
                    ]
            )
            static let keys                     =   Keys    (
                set:
                Payable                 .setKeys,
                get:
                Payable                 .getKeys,
                other:
                Payable                 .otherKeys,
                firebase:
                Payable                 .firebaseKeys
            )
        }
        
        struct Reviewable
        {
            static let privateRating            =       "privateRating"
            static let privateReview            =       "privateReview"
            
            static let rating                   =       "rating"
            static let review                   =       "review"
            
            static let ratingValue              =       "ratingValue"
            
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    HappenedType            .keys.set,
                    FirebaseRequestIDable   .keys.set
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Reviewable              .privateRating,
                        Reviewable              .privateReview
                    ]
            )
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    HappenedType            .keys.get,
                    FirebaseRequestIDable   .keys.get
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Reviewable              .rating,
                        Reviewable              .review
                    ]
            )
            
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    HappenedType            .keys.other,
                    FirebaseRequestIDable   .keys.other
                ]
                )
                .newArrayByAppendingSingle  (
                    element:
                    Reviewable.ratingValue
            )
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    HappenedType            .keys.firebase,
                    FirebaseRequestIDable   .keys.firebase
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        Reviewable              .rating,
                        Reviewable              .review
                    ]
            )
            static let keys                     =   Keys    (
                set:
                Reviewable              .setKeys,
                get:
                Reviewable              .getKeys,
                other:
                Reviewable              .otherKeys,
                firebase:
                Reviewable              .firebaseKeys
            )
        }
        
        struct RequestTimeSequenceType
        {
            static let toCreate                 =       "toCreate"
            static let toAccept                 =       "toAccept"
            static let toCommunicate            =       "toCommunicate"
            static let toStart                  =       "toStart"
            static let toPay                    =       "toPay"
            static let toReview                 =       "toReview"
            
            static let time                     =       "time"
            
            static let intervalToCreate         =       "intervalToCreate"
            static let intervalToAccept         =       "intervalToAccept"
            static let intervalToCommunicate    =       "intervalToCommunicate"
            static let intervalToStart          =       "intervalToStart"
            static let intervalToPay            =       "intervalToPay"
            static let intervalToReview         =       "intervalToReview"
            
            static let keys                     =   Keys    (
                other:
                [
                    RequestTimeSequenceType .intervalToCreate,
                    RequestTimeSequenceType .intervalToAccept,
                    RequestTimeSequenceType .intervalToCommunicate,
                    RequestTimeSequenceType .intervalToStart,
                    RequestTimeSequenceType .intervalToPay,
                    RequestTimeSequenceType .intervalToReview,
                    
                    RequestTimeSequenceType .toCreate,
                    RequestTimeSequenceType .toAccept,
                    RequestTimeSequenceType .toCommunicate,
                    RequestTimeSequenceType .toStart,
                    RequestTimeSequenceType .toPay,
                    RequestTimeSequenceType .toReview
                ],
                firebase:
                [
                    RequestTimeSequenceType .toCreate,
                    RequestTimeSequenceType .toAccept,
                    RequestTimeSequenceType .toCommunicate,
                    RequestTimeSequenceType .toStart,
                    RequestTimeSequenceType .toPay,
                    RequestTimeSequenceType .toReview
                ]
            )
        }
        
        struct RequestType
        {
            static let privateCreated           =       "privateCreated"
            static let privateAccepted          =       "privateAccepted"
            static let privateCommunicated      =       "privateCommunicated"
            static let privateService           =       "privateService"
            static let privatePayed             =       "privatePayed"
            static let privateReviewed          =       "privateReviewed"
            
            static let created                  =       "created"
            static let accepted                 =       "accepted"
            static let communicated             =       "communicated"
            static let service                  =       "service"
            static let payed                    =       "payed"
            static let reviewed                 =       "reviewed"
            
            static let setKeys                  =   addArrayOf  (
                arrays:
                [
                    RequestTimeSequenceType .keys.set,
                    FirebaseRequestIDable   .keys.set
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        RequestType             .privateCreated,
                        RequestType             .privateAccepted,
                        RequestType             .privateCommunicated,
                        RequestType             .privateService,
                        RequestType             .privatePayed,
                        RequestType             .privateReviewed
                    ]
            )
            
            static let getKeys                  =   addArrayOf  (
                arrays:
                [
                    RequestTimeSequenceType .keys.get,
                    FirebaseRequestIDable   .keys.get
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    [
                        RequestType             .created,
                        RequestType             .accepted,
                        RequestType             .communicated,
                        RequestType             .service,
                        RequestType             .payed,
                        RequestType             .reviewed
                    ]
            )
            
            static let otherKeys                =   addArrayOf  (
                arrays:
                [
                    RequestTimeSequenceType .keys.other,
                    FirebaseRequestIDable   .keys.other
                ]
            )
            
            static let firebaseKeys             =   addArrayOf  (
                arrays:
                [
                    RequestTimeSequenceType .keys.firebase,
                    FirebaseRequestIDable   .keys.firebase
                ]
                )
                .newArrayByAppendingMultiple    (
                    elements:
                    RequestType             .getKeys
            )
            static let keys                     =   Keys    (
                set:
                RequestType             .setKeys,
                get:
                RequestType             .getKeys,
                other:
                RequestType             .otherKeys,
                firebase:
                RequestType             .firebaseKeys
            )
        }
        
        struct FirebaseLocationIDable
        {
            static let privateFirebaseLID       =       "privateFirebaseLID"
            static let firebaseLID              =       "firebaseLID"
            static let firebaseLocationRef      =       "firebaseLocationRef"
            
            static let keys                     =   Keys    (
                set:
                [
                    FirebaseLocationIDable  .privateFirebaseLID
                ],
                other:
                [
                    FirebaseLocationIDable  .firebaseLocationRef
                ]
            )
        }
    }
    
    struct SaveCellNumber
    {
        struct Segue
        {
            static let SaveCellNumberToSetGym = "SaveCellNumberToSetGym"
        }
    }
    
    struct ViewController
    {
        struct Segue
        {
            static let LogInToRiderOnMap = "ShowRiderOnMap"
            static let Logout = "Logout"
            static let LogInToDriverViewController = "ShowDriverViewController"
            static let SignUpToSetGym = "SignUpToSetGym"
            static let SetGymToSignIn = "SetGymToSignIn"
        }
    }
    
    struct SetGymVC
    {
        struct Segue
        {
            static let SetGymToSignIn = "SetGymMapToSignIn"
        }
    }
    
    struct RiderViewController
    {
        struct Segue
        {
            static let Logout = "Logout"
            static let Driver = Constants.ViewController.Segue.LogInToDriverViewController
        }
    }
    
    struct DriverViewController
    {
        struct Segue
        {
            static let Driver = Constants.ViewController.Segue.LogInToDriverViewController
            static let Logout = "LogOutDriver"
            static let ShowUserLocation = "ShowUserLocation"
        }
        struct TableView
        {
            static let DefaultNumberOfSections: Int = 1
            static let DefaultNumberOfRows: Int = 4
            static let DefaultCellTextLabelText = "Test"
            static let DefaultCellReuseIdentifier = "Cell"
        }
    }
    
    struct Button
    {
        struct Title
        {
            static let LogIn = "Log In"
            static let SignUp = "Sign Up"
            static let SwitchToLogIn = "Switch to Log In"
            static let SwitchToSignUp = "Switch to Sign Up"
        }
    }
    struct Alert
    {
        struct Title
        {
            static let OK = "OK"
            static let Continue = "Continue"
            static let Cancel = "Cancel"
            static let SignUp = "Sign Up"
            static let LogIn = "Log In"
            static let SignUpFailed = "Sign Up Failed."
            static let LogInFailed = "Log In Failed."
            static let EmptyUserName = "User Name Not Captured"
            static let EmptyPassword = "Password Not Captured"
            static let EmptyUserNameAndPassword = "User Name and Password Not Captured"
            static let EmptyCellNumber = "Cell Number Not Captured"
            static let SuccessfullyCalledCoach = "Coach Assigned"
            static let FailedToCallCoach = "Coach Unreachable."
            static let CurrentLocationNotFound = "Current Location Undetected"
            static let GymNotSelected = "No Gym Selection Made"
            
        }
        struct Message
        {
            static let SignUpFailed = "Sorry, the sign up attempt was not successful."
            static let LogInFailed = "Sorry, the log in attempt was not successful."
            static let EmptyUserName = "How would you like to be called? Please enter a username of your choice."
            static let EmptyPassword = "Your account security is our priority. Please enter a secure password."
            static let EmptyUserNameAndPassword = "Your account security is our priority. Please enter a user name and password."
            static let EmptyCellNumber = "We require your cell phone for your coach to be able to reach you. Please enter a valid Cell Number."
            static let SuccessfullyCalledCoach = Constants.Display.Message.SuccessfullyCalledCoach
            static let FailedToCallCoach = Constants.Display.Message.FailedToCallCoach
            static let CurrentLocationNotFound = "Your current location could not be detected. Please try again in a few moments."
            static let GymNotSelected = "No gym has been selected for sighting. Please select the gym you want to spot on the map."
        }
    }
    struct Key
    {
        static let IsDriver = "isDriver"
        static let IsUser = "isUser"
        static let Error = "error"
        static let LogIn = "Log In"
        static let SignUp = "Sign Up"
    }
    struct Error
    {
        struct Message
        {
            static let TryAgain = "Please, try again later."
            static let DataRetrieval = "Sorry, the data could not be retrieved from the specified URL."
        }
    }
    struct Display
    {
        struct Message
        {
            static let LogInSuccessful = "You logged in successfully."
            static let SignUpSuccessful = "You signed up successfully."
            static let SuccessfullyCalledCoach = "Your coach is on the way."
            static let FailedToCallCoach = "Sorry, a coach could not be reached at this point."
            static let NoRequestsFound = "No user requests found at the moment."
            static let UserLocationNotConvertibleToCLLocation = "User location could not be converted to a CLLocationCoordinate2D object."
        }
    }
    struct Mirror
    {
        struct Key
        {
            static let Alert = "Alert"
            static let Key = "Key"
            static let Button = "Button"
            static let Title = "Title"
            static let Message = "Message"
            static let Error = "Error"
            static let Display = "Display"
            static let LogIn = Constants.Key.LogIn
            static let LogInSuccessful = "logInSuccessful"
            static let SignUpSuccessful = "signUpSuccessful"
            
            static let Gym = "Gym"
            static let Web = "Web"
            static let Scraping = "Scraping"
            static let CURLscraping = "CURLscraping"
        }
        
        struct Web
        {
            struct Key
            {
                static let Link = "Link"
            }
            
            struct Link
            {
                static let PSUfitnessScraping = "PSUfitnessScraping"
                static let PSUfitnessCURLscraping = "PSUfitnessCURLscraping"
            }
        }
        
        struct Scraping
        {
            struct Key
            {
                
            }
        }
        
        struct CURLscraping
        {
            struct Key
            {
                static let HeadersPSUFitness = "HeadersPSUFitness"
                static let HeaderValue = "HeaderValue"
            }
            
            struct Header {
                static let Accept = "Accept"
                static let XRequestedWith = "X-Requested-With"
                static let Connection = "Connection"
                static let Referer = "Referer"
            }
        }
        
        struct Gym
        {
            struct Key
            {
                static let Name = "Name"
                static let Statistic = "Statistic"
                static let Parsing = "Parsing"
                static let Synonyms = "Synonyms"
            }
            
            struct Name
            {
                static let WhiteBuilding = "WhiteBuilding"
                static let WhiteBldg = "WhiteBldg"
                static let RecHall = "RecHall"
                static let IMBuilding = "IMBuilding"
                static let IMBldg = "IMBldg"
                static let HepperFitness = "HepperFitness"
                static let IMWeightRoom = "IMWeightRoom"
                
            }
            
            struct Statistic
            {
                static let CurrentVal = Constants.Gym.Parsing.CurrentVal
                static let FullCapacityWaiTime = Constants.Gym.Parsing.FullCapacityWaiTime
                static let GUID = Constants.Gym.Parsing.GUID
                static let LocationDescription = Constants.Gym.Parsing.LocationDescription
                static let MaxVal = Constants.Gym.Parsing.MaxVal
            }
            
            struct Parsing
            {
                static let GymDataSeparator = "GymDataSeparator"
                static let GymParameterKeys = "GymParameterKeys"
            }
        }
    }
    
    struct Map
    {
        struct Distance
        {
            static let SpanWidth = 1000.00
            static let SpanHeight = 1000.00
            static let RegionDistance: CLLocationDistance = 1000.00
        }
        struct Location
        {
            static let BaseInitializer = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        struct Annotation
        {
            static let TitleForCurrentLocation = "Current Location"
            static let TitleForUserLocation = "You"
            static let TitleForCoachLocation = "Coach"
            
            static let IdentifierGym = "gym"
            static let IdentifierUser = "user"
            static let IdentifierCoach = "coach"
            static let ButtonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        
        struct PlaceMark
        {
            static let DestinationNameToGym = "Gym"
        }
        
        struct Display
        {
            static let DefaultLatitudeScaling = 2.00
            static let DefaultLongitudeScaling = 2.00
            static let DefaultLatitudeOffsetDegress = 0.005
            static let DefaultLongitudeOffsetDegrees = 0.005
            static let DefaultLatitudeOffsetMeters = 500.00
            static let DefaultLongitudeOffsetMeters = 500.00
        }
        
        struct Trax
        {
            static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
            static let AnnotationViewReuseIdentifier = "waypoint"
            static let ShowImageSegue = "Show Image"
            static let EditUserWaypoint = "Edit Waypoint"
            static let Dropped = "Dropped"
        }
        
        struct GeoFire
        {
            static let QueryRadius = 2.5
        }
    }
    
    struct Conversions
    {
        struct Distance
        {
            static let MetersInKilometers: Double = 1000.00
        }
    }
    struct Parse
    {
        struct Object
        {
            static let UserRequest = "UserRequest"
            static let CoachLocation = "CoachLocation"
            static let UserName = Constants.Parse.Properties.UserName
            static let Location = Constants.Parse.Properties.Location
        }
        struct Properties
        {
            static let UserName = "username"
            static let Location = "Location"
            static let CoachLocation = Constants.Parse.UserRequest.CoachLocation
        }
        struct UserRequest
        {
            static let UserName = Constants.Parse.Object.UserName
            static let Location = Constants.Parse.Object.Location
            static let CoachResponded = "coachResponded"
            static let CoachLocation = "coachLocation"
        }
        struct CoachLocation
        {
            static let UserName = Constants.Parse.Properties.UserName
            static let Location = Constants.Parse.Properties.Location
        }
        struct Query
        {
            static let DefaultLimit: Int = 10
        }
    }
    struct Web
    {
        struct Link
        {
            static let PSUfitnessScraping = "https://studentaffairs.psu.edu/CurrentFitnessAttendance/"
            static let PSUfitnessCURLscraping = "https://studentaffairs.psu.edu/CurrentFitnessAttendance/api/CounterAPI"
        }
    }
    
    struct Scraping
    {
        
    }
    
    /*
     
     "Accept": "application/json, text/javascript, /; q=0.01",
     "X-Requested-With": "XMLHttpRequest",
     "Connection": "keep-alive",
     "Referer": "https://studentaffairs.psu.edu/CurrentFitnessAttendance/"
     
     */
    
    struct CURLscraping
    {
        struct Header
        {
            static let Accept = "Accept"
            static let XRequestedWith = "X-Requested-With"
            static let Connection = "Connection"
            static let Referer = "Referer"
        }
        
        struct HeaderValue {
            static let Accept = "application/json, text/javascript, /; q=0.01"
            static let XRequestedWith = "XMLHttpRequest"
            static let Connection = "keep-alive"
            static let RefererPSUFitness = "https://studentaffairs.psu.edu/CurrentFitnessAttendance/"
        }
    }
    
    struct Parsing
    {
        
    }
    
    struct Gym
    {
        struct Statistic
        {
            static let CurrentVal = "Occupancy"
            static let FullCapacityWaiTime = "Wait Time"
            static let GUID = "GUID"
            static let LocationDescription = "Gym"
            static let MaxVal = "Capacity"
            static let numberOfParameters: Int = 5
        }
        
        struct Parsing
        {
            static let GymDataSeparator = " = "
            static let CurrentVal = "CurrentVal"
            static let FullCapacityWaiTime = "FullCapacityWaiTime"
            static let GUID = "GUID"
            static let LocationDescription = "LocationDescription"
            static let MaxVal = "MaxVal"        }
        
        struct Name
        {
            static let WhiteBuilding = "White Building"
            static let WhiteBldg = "White Bldg"
            static let RecHall = "Rec Hall"
            static let IMBuilding = "IM Building"
            static let IMBldg = "IM Bldg"
            static let HepperFitness = "Hepper Fitness Center"
            static let IMWeightRoom = "IM Weight Room"
        }
    }
}

let ConstantsDictionary: [String : [String : [String : String]]] = [
    Constants.Mirror.Key.Gym : [
        Constants.Mirror.Gym.Key.Statistic : [
            Constants.Mirror.Gym.Statistic.CurrentVal : Constants.Gym.Statistic.CurrentVal,
            Constants.Mirror.Gym.Statistic.FullCapacityWaiTime : Constants.Gym.Statistic.FullCapacityWaiTime,
            Constants.Mirror.Gym.Statistic.GUID : Constants.Gym.Statistic.GUID,
            Constants.Mirror.Gym.Statistic.LocationDescription : Constants.Gym.Statistic.LocationDescription,
            Constants.Mirror.Gym.Statistic.MaxVal : Constants.Gym.Statistic.MaxVal
        ],
        Constants.Mirror.Gym.Key.Synonyms : [
            Constants.Gym.Name.WhiteBuilding : Constants.Gym.Name.WhiteBldg,
            Constants.Gym.Name.HepperFitness : Constants.Gym.Name.RecHall,
            Constants.Gym.Name.IMWeightRoom : Constants.Gym.Name.IMBldg
        ]
    ],
    Constants.Mirror.Key.CURLscraping : [
        Constants.Mirror.CURLscraping.Key.HeadersPSUFitness : [
            Constants.Mirror.CURLscraping.Header.Accept : Constants.CURLscraping.HeaderValue.Accept,
            Constants.Mirror.CURLscraping.Header.XRequestedWith : Constants.CURLscraping.HeaderValue.XRequestedWith,
            Constants.Mirror.CURLscraping.Header.Connection : Constants.CURLscraping.HeaderValue.Connection,
            Constants.Mirror.CURLscraping.Header.Referer: Constants.CURLscraping.HeaderValue.RefererPSUFitness
        ]
    ],
    Constants.Mirror.Key.Display: [
        Constants.Mirror.Key.Message: [
            Constants.Mirror.Key.LogInSuccessful: Constants.Display.Message.LogInSuccessful,
            Constants.Mirror.Key.SignUpSuccessful: Constants.Display.Message.SignUpSuccessful
        ]
    ]
]
