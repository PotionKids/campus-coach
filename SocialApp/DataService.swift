//
//  DataService.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/17/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

typealias FirebaseData = [String : String]

let FirebaseBaseURL         = FIRDatabase.database().reference()

let FirebaseAllUsersURL     = FirebaseBaseURL.child(Constants.DataService.Firebase.AllUsers)
let FirebaseStudentsURL     = FirebaseBaseURL.child(Constants.DataService.Firebase.Students)
let FirebaseCoachesURL      = FirebaseBaseURL.child(Constants.DataService.Firebase.Coaches)
let FirebaseLocationsURL    = FirebaseBaseURL.child(Constants.DataService.Firebase.Locations)
let FirebaseRequestsURL     = FirebaseBaseURL.child(Constants.DataService.Firebase.Requests)

let FirebaseCreatedURL      = FirebaseRequestsURL.child(Constants.DataService.Firebase.Created)
let FirebaseAcceptedURL     = FirebaseRequestsURL.child(Constants.DataService.Firebase.Accepted)
let FirebaseCommunicatedURL = FirebaseRequestsURL.child(Constants.DataService.Firebase.Communicated)
let FirebaseServiceURL      = FirebaseRequestsURL.child(Constants.DataService.Firebase.Service)
let FirebasePayedURL        = FirebaseRequestsURL.child(Constants.DataService.Firebase.Payed)
let FirebaseReviewedURL     = FirebaseRequestsURL.child(Constants.DataService.Firebase.Reviewed)

extension RawRepresentable
{
    var description: String
    {
        return "\(rawValue)"
    }
    var string: String
    {
        return "\(rawValue)"
    }
    var objectKey: String
    {
        return "\(rawValue)"
    }
    var key: String
    {
        return "\(rawValue)"
    }
    var rootNode: String
    {
        return "\(rawValue)"
    }
    var node: String
    {
        return "\(rawValue)"
    }
    var subNode: String
    {
        return "\(rawValue)"
    }
    var DatabaseReference: FIRDatabaseReference
    {
        return FirebaseBaseURL.child(rootNode)
    }
}

struct Firebase
{
    enum Object: String
    {
        case base                       = "object"
        case allUsers
        case users
        case students
        case coaches
        case locations
        case requests
        
        var firebaseRef: FIRDatabaseReference
        {
            return FirebaseBaseURL.child(node)
        }
        
        //MARK: Firebase.Object.Users STARTS Here.
        
        enum AllUsers: String
        {
            case base                   = "allUsers"
            case firebaseUID
            case isCoach
            
            static var keys: [String]
            {
                return Constants.Protocols.AllUsersType.keys.firebase
            }
            
            static var cases: [AllUsers]
            {
                var all = [AllUsers]()
                for key in AllUsers.keys
                {
                    all.append(AllUsers(rawValue: key)!)
                }
                return all
            }
            
            
        }
        
        //MARK: Firebase.Object.Users ENDS Here.
        
        //MARK: Firebase.Object.Students STARTS Here.
        
        enum Students: String
        {
            case base                   = "students"
            case firebaseUID
            case isCoach
            case provider
            case loggedInAtTime
            case facebookUID
            case facebookImageURL
            case fullName
            case firstName
            case email
            case cell
            case firebaseRID
            case requests
            case firebaseUIDs
            case rating
            case ratings
            case reviews
            
            static var keys: [String]
            {
                return Constants.Protocols.StudentType.keys.firebase
            }
            
            static var cases: [Students]
            {
                var all = [Students]()
                for key in Students.keys
                {
                    all.append(Students(rawValue: key)!)
                }
                return all
            }
        }
        
        //MARK: Firebase.Object.Coaches STARTS Here.
        
        enum Coaches: String
        {
            case base                   = "coaches"
            case firebaseUID
            case isCoach
            case provider
            case loggedInAtTime
            case facebookUID
            case facebookImageURL
            case fullName
            case firstName
            case email
            case cell
            case firebaseRID
            case requests
            case firebaseUIDs
            case rating
            case ratings
            case reviews
            
            static var keys: [String]
            {
                return Constants.Protocols.CoachType.keys.firebase
            }
            
            static var cases: [Coaches]
            {
                var all = [Coaches]()
                for key in Coaches.keys
                {
                    all.append(Coaches(rawValue: key)!)
                }
                return all
            }
        }
        
        //MARK: Firebase.Object.Coaches ENDS Here.
        
        //MARK: Firebase.Object.Locations STARTS Here.
        enum Locations: String
        {
            case base                   = "locations"
        }
        
        //MARK: Firebase.Object.Locations ENDS Here.
        
        //MARK: Firebase.Object.Requests STARTS Here.
        
        enum Requests: String
        {
            case base                   = "requests"
            case created
            case accepted
            case communicated
            case service
            case payed
            case reviewed
            case time
            
            static var keys: [String]
            {
                return [""]
            }
            
            //MARK: Firebase.Object.Requests.Created STARTS Here
            
            enum Created: String
            {
                case base              = "created"
                case orNot
                case atTime
                case byStudent
                case afterTimeOf
                case hasEnded
                case endedAtTime
                case firebaseRID
                case forGym
                case lengthOfLife
            }
            
            //MARK: Firebase.Object.Requests.Created ENDS Here.
            
            //MARK: Firebase.Object.Requests.Accepted STARTS Here.
            
            enum Accepted: String
            {
                case base               = "accepted"
                case orNot
                case atTime
                case byCoach
                case afterTimeOf
                case firebaseRID
                case andIsAtTheGym
                case andTimeToReach
                
                static var keys: [String]
                {
                    return Constants.Protocols.Acceptable.keys.firebase
                }
                
                static var cases: [Accepted]
                {
                    var all = [Accepted]()
                    for key in Accepted.keys
                    {
                        all.append(Accepted(rawValue: key)!)
                    }
                    return all
                }
            }
            
            //MARK: Firebase.Object.Requests.Accepted ENDS Here.
            
            //MARK: Firebase.Object.Requests.Communicated STARTS Here.
            
            enum Communicated: String
            {
                case base               = "communicated"
                case orNot
                case atTimes
                case byCallOrText
                case byCoachOrNot
                case firebaseRID
                
                static var keys: [String]
                {
                    return Constants.Protocols.Communicable.keys.firebase
                }
                
                static var cases: [Communicated]
                {
                    var all = [Communicated]()
                    for key in Communicated.keys
                    {
                        all.append(Communicated(rawValue: key)!)
                    }
                    return all
                }
            }
            
            enum Service: String
            {
                case base               = "service"
                case hasStarted
                case startedAtTime
                case hasEnded
                case endedAtTime
                case duration
                case costPerHour
                case commission
                case coachFee
                case firebaseRID
                case amount
                case coachAmount
                case commissionEarned
                
                static var keys: [String]
                {
                    return Constants.Protocols.ActivityType.keys.firebase
                }
                
                static var cases: [Service]
                {
                    var all = [Service]()
                    for key in Service.keys
                    {
                        all.append(Service(rawValue: key)!)
                    }
                    return all
                }
            }
            //MARK: Firebase.Object.Requests.Stopped ENDS Here.
            
            //MARK: Firebase.Object.Requests.Payed STARTS Here.
            
            enum Payed: String
            {
                case base               = "payed"
                case orNot
                case atTime
                case firebaseRID
                case tip
                
                static var keys: [String]
                {
                    return Constants.Protocols.Payable.keys.firebase
                }
                
                static var cases: [Payed]
                {
                    var all = [Payed]()
                    for key in Payed.keys
                    {
                        all.append(Payed(rawValue: key)!)
                    }
                    return all
                }
            }
            
            //MARK: Firebase.Object.Requests.Payed ENDS Here.
            
            //MARK: Firebase.Object.Requests.Reviewed STARTS Here.
            
            enum Reviewed: String
            {
                case base               = "reviewed"
                case orNot
                case atTime
                case firebaseRID
                case rating
                case review
                
                static var keys: [String]
                {
                    return Constants.Protocols.Reviewable.keys.firebase
                }
                
                static var cases: [Reviewed]
                {
                    var all = [Reviewed]()
                    for key in Reviewed.keys
                    {
                        all.append(Reviewed(rawValue: key)!)
                    }
                    return all
                }
            }
            
            //MARK: Firebase.Object.Requests.Reviewed ENDS Here.
            
            enum Time: String
            {
                case base               = "timeSequence"
                case toCreate
                case toAccept
                case toCommunicate
                case toStart
                case toPay
                case toReview
            }
        }
        
        //MARK: Firebase.Object.Requests ENDS Here.
    }
    static let Users:       Object = .users
    static let Coaches:     Object = .coaches
    static let Locations:   Object = .locations
    static let Requests:    Object = .requests
    
    //MARK: Firebase.Object ENDS Here.
    
    //MARK: Firebase.Object Pointers START Here.
    
    static let getObjectBase                        = Object.base
    static let getAllUsersNode                      = Object.allUsers
    static let getStudentsNode                      = Object.students
    static let getCoachesNode                       = Object.coaches
    static let getLocationsNode                     = Object.locations
    static let getRequestsNode                      = Object.requests
    
    static let getRequestCreatedNode                = Object.Requests.created
    static let getRequestAcceptedNode               = Object.Requests.accepted
    static let getRequestCommunicatedNode           = Object.Requests.communicated
    static let getRequestServiceNode                = Object.Requests.service
    static let getRequestPayedNode                  = Object.Requests.payed
    static let getRequestReviewedNode               = Object.Requests.reviewed
    static let getRequestTimeSequenceNode           = Object.Requests.time
    
    static let getRequestCreatedBase                = Object.Requests.Created       .base
    static let getRequestCreatedOrNot               = Object.Requests.Created       .orNot
    static let getRequestCreatedAtTime              = Object.Requests.Created       .atTime
    static let getRequestCreatedByStudent           = Object.Requests.Created       .byStudent
    static let getRequestCreatedAfterTimeOf         = Object.Requests.Created       .afterTimeOf
    static let getRequestCreatedHasEnded            = Object.Requests.Created       .hasEnded
    static let getRequestCreatedEndedAtTime         = Object.Requests.Created       .endedAtTime
    static let getRequestCreatedFirebaseRID         = Object.Requests.Created       .firebaseRID
    static let getRequestCreatedForGym              = Object.Requests.Created       .forGym
    static let getRequestCreatedLengthOfLife        = Object.Requests.Created       .lengthOfLife
    
    static let getRequestAcceptedBase               = Object.Requests.Accepted      .base
    static let getRequestAcceptedOrNot              = Object.Requests.Accepted      .orNot
    static let getRequestAcceptedAtTime             = Object.Requests.Accepted      .atTime
    static let getRequestAcceptedByCoach            = Object.Requests.Accepted      .byCoach
    static let getRequestAcceptedAfterTimeOf        = Object.Requests.Accepted      .afterTimeOf
    static let getRequestAcceptedFirebaseRID        = Object.Requests.Accepted      .firebaseRID
    static let getRequestAcceptedAndIsAtTheGym      = Object.Requests.Accepted      .andIsAtTheGym
    static let getRequestAcceptedAndTimeToReach     = Object.Requests.Accepted      .andTimeToReach
    
    static let getRequestCommunicatedBase           = Object.Requests.Communicated  .base
    static let getRequestCommunicatedOrNot          = Object.Requests.Communicated  .orNot
    static let getRequestCommunicatedAtTimes        = Object.Requests.Communicated  .atTimes
    static let getRequestCommunicatedByCallOrText   = Object.Requests.Communicated  .byCallOrText
    static let getRequestCommunicatedByCoachOrNot   = Object.Requests.Communicated  .byCoachOrNot
    static let getRequestCommunicatedFirebaseRID    = Object.Requests.Communicated  .firebaseRID
    
    static let getRequestServiceBase                = Object.Requests.Service       .base
    static let getRequestServiceHasStarted          = Object.Requests.Service       .hasStarted
    static let getRequestServiceStartedAtTime       = Object.Requests.Service       .startedAtTime
    static let getRequestServiceHasEnded            = Object.Requests.Service       .hasEnded
    static let getRequestServiceEndedAtTime         = Object.Requests.Service       .endedAtTime
    static let getRequestServiceDuration            = Object.Requests.Service       .duration
    static let getRequestServiceCost                = Object.Requests.Service       .costPerHour
    static let getRequestServiceCommission          = Object.Requests.Service       .commission
    static let getRequestServiceCoachFee            = Object.Requests.Service       .coachFee
    static let getRequestServiceFirebaseRID         = Object.Requests.Service       .firebaseRID
    static let getRequestServiceAmount              = Object.Requests.Service       .amount
    static let getRequestServiceCoachAmount         = Object.Requests.Service       .coachAmount
    static let getRequestServiceCommissionEarned    = Object.Requests.Service       .commissionEarned
    
    static let getRequestPayedBase                  = Object.Requests.Payed         .base
    static let getRequestPayedOrNot                 = Object.Requests.Payed         .orNot
    static let getRequestPayedAtTime                = Object.Requests.Payed         .atTime
    static let getRequestPayedFirebaseRID           = Object.Requests.Payed         .firebaseRID
    static let getRequestPayedTip                   = Object.Requests.Payed         .tip
    
    static let getRequestReviewedBase               = Object.Requests.Reviewed      .base
    static let getRequestReviewedOrNot              = Object.Requests.Reviewed      .orNot
    static let getRequestReviewedAtTime             = Object.Requests.Reviewed      .atTime
    static let getRequestReviewedFirebaseRID        = Object.Requests.Reviewed      .firebaseRID
    static let getRequestReviewedRating             = Object.Requests.Reviewed      .rating
    static let getRequestReviewedReview             = Object.Requests.Reviewed      .review
    
    static let getRequestTimeBase                   = Object.Requests.Time          .base
    static let getRequestTimeToCreate               = Object.Requests.Time          .toCreate
    static let getRequestTimeToAccept               = Object.Requests.Time          .toAccept
    static let getRequestTimeToCommunicate          = Object.Requests.Time          .toCommunicate
    static let getRequestTimeToStart                = Object.Requests.Time          .toStart
    static let getRequestTimeToPay                  = Object.Requests.Time          .toPay
    static let getRequestTimeToReview               = Object.Requests.Time          .toReview
    
    
    //MARK: Firebase.Object Pointers END Here.
}

class DataService
{
    static let ds = DataService()
    
    private var RefBasePrivate = FirebaseBaseURL
    
    var refBase: FIRDatabaseReference
    {
        return RefBasePrivate
    }
    
    func createFirebaseObject(object: Firebase.Object, instanceID: String, data: FirebaseData)
    {
        object.DatabaseReference.child(instanceID).updateChildValues(data)
    }
}

func getFirebaseUserRef(fromObject object: FirebaseUserIDable) -> FIRDatabaseReference
{
    if object.coachOrNot
    {
        return object.firebaseUID.firebaseCoachRef
    }
    else
    {
        return object.firebaseUID.firebaseStudentRef
    }
}

func getFirebaseLocationRef(fromObject object: FirebaseLocationIDable) -> FIRDatabaseReference
{
    return object.firebaseLID.firebaseLocationRef
}

func getFirebaseRequestRef(fromObject object: FirebaseRequestIDable) -> FIRDatabaseReference
{
    return object.firebaseRID.firebaseRequestRef
}

func getRequestCreatedRef(fromObject object: FirebaseRequestIDable) -> FIRDatabaseReference
{
    return object.firebaseRID.requestCreatedRef
}

func getRequestAcceptedRef(fromObject object: FirebaseRequestIDable) -> FIRDatabaseReference
{
    return object.firebaseRID.requestAcceptedRef
}

func getRequestCommunicatedRef(fromObject object: FirebaseRequestIDable) -> FIRDatabaseReference
{
    return object.firebaseRID.requestCommunicatedRef
}

func getRequestServiceRef(fromObject object: FirebaseRequestIDable) -> FIRDatabaseReference
{
    return object.firebaseRID.requestServiceRef
}

func getRequestPayedRef(fromObject object: FirebaseRequestIDable) -> FIRDatabaseReference
{
    return object.firebaseRID.requestPayedRef
}

func getRequestReviewedRef(fromObject object: FirebaseRequestIDable) -> FIRDatabaseReference
{
    return object.firebaseRID.requestReviewedRef
}

func pushToFirebase(data: StringDictionary, atLocation location: FIRDatabaseReference)
{
    location.updateChildValues(data)
}

extension String
{
    var firebaseUserRef: FIRDatabaseReference
    {
        return Firebase.Object.users.DatabaseReference.child(self)
    }
    var firebaseAllUsersRef: FIRDatabaseReference
    {
        return FirebaseAllUsersURL.child(self)
    }
    var firebaseStudentRef: FIRDatabaseReference
    {
        return FirebaseStudentsURL.child(self)
    }
    
    var firebaseCoachRef: FIRDatabaseReference
    {
        return FirebaseCoachesURL.child(self)
    }
    
    var firebaseLocationRef: FIRDatabaseReference
    {
        return FirebaseLocationsURL.child(self)
    }
    
    var firebaseRequestRef: FIRDatabaseReference
    {
        return FirebaseRequestsURL.child(self)
    }
    
    var requestCreatedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestCreatedBase.key)
    }
    
    var requestAcceptedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestAcceptedBase.key)
    }
    
    var requestCommunicatedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestCommunicatedBase.key)
    }
    
    var requestServiceRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestServiceBase.key)
    }
    
    var requestPayedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestPayedBase.key)
    }
    
    var requestReviewedRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestReviewedBase.key)
    }
    
    var requestTimeRef: FIRDatabaseReference
    {
        return firebaseRequestRef.child(Firebase.getRequestTimeBase.key)
    }
    
    func getRequestCreatedRefAt(subNode: Firebase.Object.Requests.Created) -> FIRDatabaseReference
    {
        return requestCreatedRef.child(subNode.key)
    }
    
    func getRequestAcceptedRefAt(subNode: Firebase.Object.Requests.Accepted) -> FIRDatabaseReference
    {
        return requestAcceptedRef.child(subNode.key)
    }
    
    func getRequestCommunicatedRefAt(subNode: Firebase.Object.Requests.Communicated) -> FIRDatabaseReference
    {
        return requestCommunicatedRef.child(subNode.key)
    }
    
    func getRequestServiceRefAt(subNode: Firebase.Object.Requests.Service) -> FIRDatabaseReference
    {
        return requestServiceRef.child(subNode.key)
    }
    
    func getRequestPayedRefAt(subNode: Firebase.Object.Requests.Payed) -> FIRDatabaseReference
    {
        return requestPayedRef.child(subNode.key)
    }
    
    func getRequestReviewedRefAt(subNode: Firebase.Object.Requests.Reviewed) -> FIRDatabaseReference
    {
        return requestReviewedRef.child(subNode.key)
    }
    
    func getRequestTimeRefAt(subNode: Firebase.Object.Requests.Time) -> FIRDatabaseReference
    {
        return requestTimeRef.child(subNode.key)
    }
}
