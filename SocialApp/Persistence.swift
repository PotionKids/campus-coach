//
//  Persistence.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/15/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

typealias ActionType            = Persistence.Action
typealias MethodType            = Persistence.Method
typealias ResultBool            = (success: Bool, value         : Bool?         )
typealias ResultAny             = (success: Bool, value         : Any?          )
typealias ResultUser            = (success: Bool, user          : User?         )
typealias ResultStudent         = (success: Bool, student       : Student?      )
typealias ResultCoach           = (success: Bool, coach         : Coach?        )
typealias ResultRequest         = (success: Bool, request       : Request?      )
typealias ResultCreated         = (success: Bool, created       : Created?      )
typealias ResultAccepted        = (success: Bool, accepted      : Accepted?     )
typealias ResultCommunicated    = (success: Bool, communicated  : Communicated? )
typealias ResultService         = (success: Bool, service       : Service?      )
typealias ResultPayed           = (success: Bool, payed         : Payed?        )
typealias ResultReviewed        = (success: Bool, reviewed      : Reviewed?     )
typealias ResultTime            = (success: Bool, time          : TimeObject?   )


protocol PersistenceType
{
    var privateHasSignedUp      : Bool!                 { get set }
    var privateIsLoggedIn       : Bool!                 { get set }
    var privateIsCoach          : IsCoach               { get set }
    var privateCoachOrNot       : Bool!                 { get set }
    
    var privateUser             : User?                 { get set }
    var privateStudent          : Student?              { get set }
    var privateCoach            : Coach?                { get set }
    var privateRequest          : Request?              { get set }
    
    var hasSignedUp             : Bool                  { get }
    var isLoggedIn              : Bool                  { get }
    var isCoach                 : Bool                  { get }
    
    var user                    : User?                 { get }
    var student                 : Student?              { get }
    var coach                   : Coach?                { get }
    var firebaseUID             : Key?                  { get }
    var firebaseRID             : Key?                  { get }
    
    var request                 : Request?              { get }
    var created                 : Created?              { get }
    var accepted                : Accepted?             { get }
    var communicated            : Communicated?         { get }
    var service                 : Service?              { get }
    var payed                   : Payed?                { get }
    var reviewed                : Reviewed?             { get }
    var time                    : StringDictionary?     { get }
    
    var keyIsLoggedIn           : Key                   { get }
    var keyHasSignedUp          : Key                   { get }
    var keyIsCoach              : Key                   { get }
    var keyUser                 : Key                   { get }
    var keyStudent              : Key                   { get }
    var keyCoach                : Key                   { get }
    
    var keyRequest              : Key                   { get }
    var keyCreated              : Key                   { get }
    var keyAccepted             : Key                   { get }
    var keyCommunicated         : Key                   { get }
    var keyService              : Key                   { get }
    var keyPayed                : Key                   { get }
    var keyReviewed             : Key                   { get }
    var keyTimeSequence         : Key                   { get }
    
    var userRef                 : FIRDatabaseReference? { get }
    var studentRef              : FIRDatabaseReference? { get }
    var coachRef                : FIRDatabaseReference? { get }
    var requestRef              : FIRDatabaseReference? { get }
    var createdRef              : FIRDatabaseReference? { get }
    var acceptedRef             : FIRDatabaseReference? { get }
    var communicatedRef         : FIRDatabaseReference? { get }
    var serviceRef              : FIRDatabaseReference? { get }
    var payedRef                : FIRDatabaseReference? { get }
    var reviewedRef             : FIRDatabaseReference? { get }
    var timeRef                 : FIRDatabaseReference? { get }
}
extension PersistenceType
{
    var hasSignedUp             : Bool
    {
        return privateHasSignedUp
    }
    var isLoggedIn              : Bool
    {
        return privateIsLoggedIn
    }
    var isCoach                 : IsCoach
    {
        return privateIsCoach
    }
    var coachOrNot              : Bool
    {
        return privateCoachOrNot
    }
    
    var user                    : User?
    {
        return privateUser
    }
    var student                 : Student?
    {
        return privateStudent
    }
    var coach                   : Coach?
    {
        return privateCoach
    }
    var firebaseUID             : Key?
    {
        return user?            .firebaseUID
    }
    var firebaseRID             : Key?
    {
        return request?         .firebaseRID
    }
    
    var request                 : Request?
    {
        return privateRequest
    }
    var created                 : Created?
    {
        return request?         .created
    }
    var accepted                : Accepted?
    {
        return request?         .accepted
    }
    var communicated            : Communicated?
    {
        return request?         .communicated
    }
    var service                 : Service?
    {
        return request?         .service
    }
    var payed                   : Payed?
    {
        return request?         .payed
    }
    var reviewed                : Reviewed?
    {
        return request?         .reviewed
    }
    var time                    : StringDictionary?
    {
        return request?         .time
    }
    
    var keyIsLoggedIn           : Key
    {
        return Constants.Protocols.Persistence  .keyIsLoggedIn
    }
    var keyHasSignedUp          : Key
    {
        return Constants.Protocols.Persistence  .keyHasSignedUp
    }
    var keyIsCoach              : Key
    {
        return Constants.Protocols.Persistence  .keyIsCoach
    }
    
    var keyUser                 : Key
    {
        return User         .keyForSaveKeys
    }
    var keyStudent              : Key
    {
        return Student      .keyForSaveKeys
    }
    var keyCoach                : Key
    {
        return Coach        .keyForSaveKeys
    }
    
    var keyRequest              : Key
    {
        return Request      .keyForSaveKeys
    }
    var keyCreated              : Key
    {
        return Created      .keyForSaveKeys
    }
    var keyAccepted             : Key
    {
        return Accepted     .keyForSaveKeys
    }
    var keyCommunicated         : Key
    {
        return Communicated .keyForSaveKeys
    }
    var keyService              : Key
    {
        return Service      .keyForSaveKeys
    }
    var keyPayed                : Key
    {
        return Payed        .keyForSaveKeys
    }
    var keyReviewed             : Key
    {
        return Reviewed     .keyForSaveKeys
    }
    var keyTimeSequence         : Key
    {
        return Constants.Protocols.Persistence.timeSaveKeys
    }
    
    var userRef                 : FIRDatabaseReference?
    {
        return user?            .firebaseUserRef
    }
    var studentRef              : FIRDatabaseReference?
    {
        return student?         .firebaseUserRef
    }
    var coachRef                : FIRDatabaseReference?
    {
        return coach?           .firebaseUserRef
    }
    var requestRef              : FIRDatabaseReference?
    {
        return request?         .firebaseRequestRef
    }
    var createdRef              : FIRDatabaseReference?
    {
        return created?         .requestCreatedRef
    }
    var acceptedRef             : FIRDatabaseReference?
    {
        return accepted?        .requestAcceptedRef
    }
    var communicatedRef         : FIRDatabaseReference?
    {
        return communicated?    .requestCommunicatedRef
    }
    var serviceRef              : FIRDatabaseReference?
    {
        return service?         .requestServiceRef
    }
    var payedRef                : FIRDatabaseReference?
    {
        return payed?           .requestPayedRef
    }
    var reviewedRef             : FIRDatabaseReference?
    {
        return reviewed?        .requestReviewedRef
    }
    var timeRef                 : FIRDatabaseReference?
    {
        return request?         .requestTimeRef
    }
    
    //MARK: VARIABLES For Printing-Booleans
    
    var shouldPrintBoolActions          : Bool
    {
        return Constants.Protocols.Persistence              .ShouldPrint
    }
    var shouldPrintUserAction           : Bool
    {
        return Constants.Protocols.Persistence.Users        .ShouldPrint
    }
    var shouldPrintStudentAction        : Bool
    {
        return Constants.Protocols.Persistence.Students     .ShouldPrint
    }
    var shouldPrintCoachAction          : Bool
    {
        return Constants.Protocols.Persistence.Coaches      .ShouldPrint
    }
    var shouldPrintRequestAction        : Bool
    {
        return Constants.Protocols.Persistence.Requests     .ShouldPrint
    }
    var shouldPrintCreatedAction        : Bool
    {
        return Constants.Protocols.Persistence.Created      .ShouldPrint
    }
    var shouldPrintAcceptedAction       : Bool
    {
        return Constants.Protocols.Persistence.Accepted     .ShouldPrint
    }
    var shouldPrintCommunicatedAction   : Bool
    {
        return Constants.Protocols.Persistence.Communicated .ShouldPrint
    }
    var shouldPrintServiceAction        : Bool
    {
        return Constants.Protocols.Persistence.Service      .ShouldPrint
    }
    var shouldPrintPayedAction          : Bool
    {
        return Constants.Protocols.Persistence.Payed        .ShouldPrint
    }
    var shouldPrintReviewedAction       : Bool
    {
        return Constants.Protocols.Persistence.Reviewed     .ShouldPrint
    }
    var shouldPrintTimeAction           : Bool
    {
        return Constants.Protocols.Persistence.Created      .ShouldPrint
    }
    
    //MARK: VARIABLES For Saving-Booleans
    
    var shouldSaveUser              : Bool
    {
        return Constants.Protocols.Persistence.Users        .ShouldSave
    }
    var shouldSaveStudent           : Bool
    {
        return Constants.Protocols.Persistence.Students     .ShouldSave
    }
    var shouldSaveCoach             : Bool
    {
        return Constants.Protocols.Persistence.Coaches      .ShouldSave
    }
    var shouldSaveRequest           : Bool
    {
        return Constants.Protocols.Persistence.Requests     .ShouldSave
    }
    var shouldSaveCreated           : Bool
    {
        return Constants.Protocols.Persistence.Created      .ShouldSave
    }
    var shouldSaveAccepted          : Bool
    {
        return Constants.Protocols.Persistence.Accepted     .ShouldSave
    }
    var shouldSaveCommunicated      : Bool
    {
        return Constants.Protocols.Persistence.Communicated .ShouldSave
    }
    var shouldSaveService           : Bool
    {
        return Constants.Protocols.Persistence.Service      .ShouldSave
    }
    var shouldSavePayed             : Bool
    {
        return Constants.Protocols.Persistence.Payed        .ShouldSave
    }
    var shouldSaveReviewed          : Bool
    {
        return Constants.Protocols.Persistence.Reviewed     .ShouldSave
    }
    var shouldSaveTime              : Bool
    {
        return Constants.Protocols.Persistence.Time         .ShouldSave
    }
    
    //MARK: FUNCTIONS For Printing
    
    func printActionedValueMessage(forValue value: Any?, withKey key: Key, forAction action: ActionType)
    {
        print("KRIS: Object \(action.verbPastTense) \n KRIS: \(value) \n KRIS: For Keys \n KRIS: \(key)")
    }
    
    func printActionedObjectMessage(forObject object: FirebaseIDable, forAction action: ActionType)
    {
        printActionedValueMessage(forValue: object.anyDictionaryForSaving, withKey: object.keyForSavingKeys, forAction: action)
    }
    
    func printFailedToActionValueMessage(forValue value: Any?, withKey key: Key, forAction action: ActionType)
    {
        print("KRIS: Failure! Object \n KRIS: \(value) \n was NOT \(action.verbPastTense) \n KRIS: For Keys \n KRIS: \(key)")
    }
    
    func printFailedToActionObjectMessage(forObject object: FirebaseIDable, forAction action: ActionType)
    {
        printFailedToActionValueMessage(forValue: object.anyDictionaryForSaving, withKey: object.keyForSavingKeys, forAction: action)
    }
    
    func printNilValueFound(value: Any?)
    {
        print("KRIS: Nil \(value) Value of Type \(type(of: value)) Found while unwrapping.")
    }
    
    func printNilObjectFound()
    {
        print("KRIS: Nil Object Found.")
    }
    
    func printNilParentObjectFound(object: Firebase.Object)
    {
        print("KRIS: Nil \(object.key.removeLast.capitalized) Object Found while unwrapping.")
    }
    
    func printNilChildObjectFound(object: Firebase.Child)
    {
        print("KRIS: Nil \(object.key.capitalized) Object Found while unwrapping.")
    }
    
    //MARK: FUNCTIONS For Saving & Retrieving
    
    func actionBool (
                                    action:             ActionType,
                                    bool:               Bool?,
                    forKey          key:                Key,
                    andPrintMessage shouldPrint:        Bool
                    )       ->                          ResultBool
    {
        var success : Bool      = false
        var value   : Bool?     = nil
        switch action
        {
        case .save:
            UserDefaults.standard.set(bool, forKey: key)
            success             = UserDefaults.standard.synchronize()
            if success
            {
                value           = bool
            }
        case .retrieve:
            if let valueSaved   = UserDefaults.standard.value(forKey: key) as? Bool
            {
                success         = true
                value           = valueSaved
            }
        }
        if success && shouldPrint
        {
            printActionedValueMessage       (forValue: bool, withKey: key, forAction: action)
        }
        else if !success
        {
            printFailedToActionValueMessage (forValue: bool, withKey: key, forAction: action)
        }
        return (success, value)
    }
    
    func actionObject       (
                                    action:             ActionType,
                                    object:             Any?,
                    forKey          key:                Key,
                    andPrintMessage shouldPrint:        Bool
                            )           ->              ResultAny
    {
        var success : Bool      = false
        var value   : Any?      = nil
        switch action
        {
        case .save:
            if let object       = object as? FirebaseIDable
            {
                let saveKeys    = object.saveKeys
                let dictionary  = object.anyDictionaryForSaving
                UserDefaults.standard.set(saveKeys  , forKey: key)
                UserDefaults.standard.setValuesForKeys(dictionary)
                success         = UserDefaults.standard.synchronize()
                if success
                {
                    value       = object
                }
            }
        case .retrieve:
            if let saveKeys     = UserDefaults.standard.value(forKey: key) as? Keys
            {
                let valueSaved  = UserDefaults.standard.dictionaryWithValues(forKeys: saveKeys)
                success         = true
                value           = valueSaved.keysShreddedFromSaveToFirebase
            }
        }
        if success && shouldPrint
        {
            printActionedValueMessage       (forValue: object, withKey: key, forAction: action)
        }
        else if !success
        {
            printFailedToActionValueMessage (forValue: object, withKey: key, forAction: action)
            printNilObjectFound()
        }
        return (success, value)
    }
    
    func actionUser         (
                                    action:             ActionType,
                    setOrSaveValue  object:             User?
                            )           ->              ResultUser
    {
        var success     : Bool              = false
        var value       : Any?              = nil
        var user        : User?             = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                          ,
                                    object:             object                          ,
                                    forKey:             self.keyUser                    ,
                                    andPrintMessage:    self.shouldPrintUserAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                user                        = value as? User
            case .retrieve:
                let data                    = value as! AnyDictionary
                user                        = User(fromUserData: data)
            }
        }
        else
        {
            printNilParentObjectFound   (object: .users)
        }
        
        return (success, user)
    }
    
    func actionStudent      (
                                    action:             ActionType,
                    setOrSaveValue  object:             Student?
                            )           ->              ResultStudent
    {
        var success     : Bool              = false
        var value       : Any?              = nil
        var student     : Student?          = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                          ,
                                    object:             object                          ,
                                    forKey:             self.keyStudent                 ,
                                    andPrintMessage:    self.shouldPrintStudentAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                student                     = value as? Student
            case .retrieve:
                let data                    = value as! AnyDictionary
                student                     = Student(fromUserData: data)
            }
        }
        else
        {
            printNilParentObjectFound   (object: .students)
        }
        
        return (success, student)
    }
    
    func actionCoach        (
                                    action:             ActionType,
                    setOrSaveValue  object:             Coach?
                            )           ->              ResultCoach
    {
        var success     : Bool              = false
        var value       : Any?              = nil
        var coach       : Coach?            = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                              ,
                                    object:             object                              ,
                                    forKey:             self.keyCoach                       ,
                                    andPrintMessage:    self.shouldPrintCoachAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                coach                       = value as? Coach
            case .retrieve:
                let data                    = value as! AnyDictionary
                coach                       = Coach(fromUserData: data)
            }
        }
        else
        {
            printNilParentObjectFound   (object: .coaches)
        }
        
        return (success, coach)
    }
    
    func actionCreated      (
                                    action:             ActionType,
                    setOrSaveValue  object:             Created?
                            )           ->              ResultCreated
    {
        var success     : Bool              = false
        var value       : Any?              = nil
        var created     : Created?          = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                              ,
                                    object:             object                              ,
                                    forKey:             self.keyCreated                     ,
                                    andPrintMessage:    self.shouldPrintCreatedAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                created                     = value as? Created
            case .retrieve:
                let data                    = value as! AnyDictionary
                created                     = Created(fromData: data)
            }
        }
        else
        {
            printNilChildObjectFound    (object: .created)
        }
        
        return (success, created)
    }
    
    func actionAccepted     (
                                    action:             ActionType,
                    setOrSaveValue  object:             Accepted?
                            )           ->              ResultAccepted
    {
        var success         : Bool          = false
        var value           : Any?          = nil
        var accepted        : Accepted?     = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                              ,
                                    object:             object                              ,
                                    forKey:             self.keyAccepted                    ,
                                    andPrintMessage:    self.shouldPrintAcceptedAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                accepted                    = value as? Accepted
            case .retrieve:
                let data                    = value as! AnyDictionary
                accepted                    = Accepted(fromData: data)
            }
        }
        else
        {
            printNilChildObjectFound(object: .accepted)
        }
        
        return (success, accepted)
    }
    
    func actionCommunicated (
                                    action:             ActionType,
                    setOrSaveValue  object:             Communicated?
                            )           ->              ResultCommunicated
    {
        var success         : Bool          = false
        var value           : Any?          = nil
        var communicated    : Communicated? = nil

        (success, value)                    = actionObject  (
                                    action:             action                              ,
                                    object:             self.communicated                   ,
                                    forKey:             self.keyCommunicated                ,
                                    andPrintMessage:    self.shouldPrintCommunicatedAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                communicated                = value as? Communicated
            case .retrieve:
                let data                    = value as! AnyDictionary
                communicated                = Communicated(fromData: data)
            }
        }
        else
        {
            printNilChildObjectFound(object: .communicated)
        }
        
        return (success, communicated)
    }
    
    func actionService      (
                                    action:             ActionType,
                    setOrSaveValue  object:             Service?
                            )           ->              ResultService
    {
        var success         : Bool          = false
        var value           : Any?          = nil
        var service         : Service?      = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                              ,
                                    object:             object                              ,
                                    forKey:             self.keyService                     ,
                                    andPrintMessage:    self.shouldPrintServiceAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                service                     = value as? Service
            case .retrieve:
                let data                    = value as! AnyDictionary
                service                     = Service(fromData: data)
            }
        }
        else
        {
            printNilChildObjectFound(object: .service)
        }
        
        return (success, service)
    }
    
    func actionPayed        (
                                    action:             ActionType,
                    setOrSaveValue  object:             Payed?
                            )           ->              ResultPayed
    {
        var success         : Bool          = false
        var value           : Any?          = nil
        var payed           : Payed?        = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                              ,
                                    object:             object                              ,
                                    forKey:             self.keyPayed                       ,
                                    andPrintMessage:    self.shouldPrintPayedAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                payed                       = value as? Payed
            case .retrieve:
                let data                    = value as! AnyDictionary
                payed                       = Payed(fromData: data)
            }
        }
        else
        {
            printNilChildObjectFound(object: .payed)
        }
        
        return (success, payed)
    }
    
    func actionReviewed     (
                                    action:             ActionType,
                    setOrSaveValue  object:             Reviewed?
                            )           ->              ResultReviewed
    {
        var success         : Bool          = false
        var value           : Any?          = nil
        var reviewed        : Reviewed?     = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                              ,
                                    object:             object                              ,
                                    forKey:             self.keyReviewed                    ,
                                    andPrintMessage:    self.shouldPrintReviewedAction
                                                            )
        
        if success
        {
            switch action
            {
            case .save:
                reviewed                    = value as? Reviewed
            case .retrieve:
                let data                    = value as! AnyDictionary
                reviewed                    = Reviewed(fromData: data)
            }
        }
        else
        {
            printNilChildObjectFound(object: .reviewed)
        }
        
        return (success, reviewed)
    }
    
    func actionTime         (
                                    action:             ActionType,
                    setOrSaveValue  object:             TimeObject?
                            )           ->              ResultTime
    {
        var success         : Bool          = false
        var value           : Any?          = nil
        var time            : TimeObject?   = nil
        
        (success, value)                    = actionObject  (
                                    action:             action                          ,
                                    object:             object                          ,
                                    forKey:             self.keyTimeSequence            ,
                                    andPrintMessage:    self.shouldPrintTimeAction
                                                            )
        
        if success
        {
            time                            = value as! TimeObject
        }
        else
        {
            printNilChildObjectFound(object: .time)
        }
        
        return (success, time)
    }

    
    func actionRequest      (
                                    action:             ActionType,
                    setOrSaveValue  object:             Request?
                            )           ->              ResultRequest
    {
        var success         : Bool                  =   false
        var request         : Request?              =   nil
        
        var created         : ResultCreated         =   (false, nil)
        var accepted        : ResultAccepted        =   (false, nil)
        var communicated    : ResultCommunicated    =   (false, nil)
        var service         : ResultService         =   (false, nil)
        var payed           : ResultPayed           =   (false, nil)
        var reviewed        : ResultReviewed        =   (false, nil)
        
        created             = actionCreated     (
                                    action:             action,
                                    setOrSaveValue:     object?.created
                                                )
        accepted            = actionAccepted    (
                                    action:             action,
                                    setOrSaveValue:     object?.accepted
                                                )
        communicated        = actionCommunicated(
                                    action:             action,
                                    setOrSaveValue:     object?.communicated
                                                )
        service             = actionService     (
                                    action:             action,
                                    setOrSaveValue:     object?.service
                                                )
        payed               = actionPayed       (
                                    action:             action,
                                    setOrSaveValue:     object?.payed
                                                )
        reviewed            = actionReviewed    (
                                    action:             action,
                                    setOrSaveValue:     object?.reviewed
                                                )

        success             = created.success
        
        if success
        {
            switch action
            {
            case .save:
                request     = object
            case .retrieve:
                request     = Request   (
                            created:                    created         .created!               ,
                            accepted:                   accepted        .accepted               ,
                            communicated:               communicated    .communicated           ,
                            service:                    service         .service                ,
                            payed:                      payed           .payed                  ,
                            reviewed:                   reviewed        .reviewed
                                        )
            }
        }
        else
        {
            printNilParentObjectFound(object: .requests)
        }
        
        return (success, request)
    }
    
    func actionSignUp       (action: ActionType) -> ResultBool
    {
        return actionBool   (
                                    action:             action                      ,
                                    bool:               self.hasSignedUp            ,
                                    forKey:             self.keyHasSignedUp         ,
                                    andPrintMessage:    self.shouldPrintBoolActions
                            )
    }
    
    func actionLogIn        (action: ActionType) -> ResultBool
    {
        return actionBool   (
                                    action:             action                      ,
                                    bool:               self.isLoggedIn             ,
                                    forKey:             self.keyIsLoggedIn          ,
                                    andPrintMessage:    self.shouldPrintBoolActions
                            )
    }
    
    func saveUser           ()                  -> Bool
    {
        return actionUser   (action: .save, setOrSaveValue: self.user   ).success
    }
    
    func saveStudent        ()                  -> Bool
    {
        return actionStudent(action: .save, setOrSaveValue: self.student).success
    }
    
    mutating func performMethodBool (
                                    method:             MethodType                  ,
                    setOrSaveValue  bool:               Bool?                       ,
                    forKey          key:                Key                         ,
                    toSetVariable   privateVar:         inout Bool!
                                    )           -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var value           : Bool?                 =   nil
        
        (success, value)                            =   actionBool  (
                                    action:             action                      ,
                                    bool:               bool                        ,
                                    forKey:             key                         ,
                                    andPrintMessage:    self.shouldPrintBoolActions
                                                                    )
        if success
        {
            privateVar                              =   value!
        }
        
        return success
    }
    
    mutating func performMethodIsCoach  (
                                    method: MethodType                              ,
                    setOrSaveValue bool:    Bool?
                                        ) -> Bool
    {
        return performMethodBool    (
                                    method:             method                      ,
                                    setOrSaveValue:     bool                        ,
                                    forKey:             self.keyIsCoach             ,
                                    toSetVariable:      &self.privateCoachOrNot
                                    )
    }
    
    mutating func performMethodLogIn    (
                                    method:             MethodType                  ,
                    setOrSaveValue  bool:               Bool?
                                        ) -> Bool
    {
        return performMethodBool    (
                                    method:             method                      ,
                                    setOrSaveValue:     bool                        ,
                                    forKey:             self.keyIsLoggedIn          ,
                                    toSetVariable:      &self.privateIsLoggedIn
                                    )
    }
    
    mutating func performMethodSignUp   (
                                    method:             MethodType,
                    setOrSaveValue  bool:               Bool?
                                        ) -> Bool
    {
        return performMethodBool    (
                                    method:             method                      ,
                                    setOrSaveValue:     bool                        ,
                                    forKey:             self.keyHasSignedUp         ,
                                    toSetVariable:      &self.privateHasSignedUp
                                    )
    }
    
    mutating func performMethodUser     (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             User?
                                        ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var user            : User?                 =   nil
        
        (success, user)                             =   actionUser  (
                                    action:             action,
                                    setOrSaveValue:     object
                                                                    )
        
        if success
        {
            self.privateUser                        =   user!
        }
        
        return success
    }
    
    mutating func performMethodStudent  (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Student?
                                        ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var student         : Student?              =   nil
        
        
        (success, student)                          =   actionStudent   (
                                    action:             action,
                                    setOrSaveValue:     object
                                                                        )
        
        if success
        {
            self.privateStudent                     =   student!
        }
        
        return success
    }
    
    mutating func performMethodCoach    (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Coach?
                                        ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var coach           : Coach?                =   nil
        
        (success, coach)                            =   actionCoach (
                                    action:             action,
                                    setOrSaveValue:     object
                                                                    )
        
        if success
        {
            self.privateCoach                       =   coach!
        }
        
        return success
    }
    
    mutating func performMethodCreated  (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Created?
                                        ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var created         : Created?              =   nil
        
        (success, created)                          =   actionCreated   (
                                    action:             action,
                                    setOrSaveValue:     object
                                                                        )
        
        if success
        {
            self.privateRequest                     =   Request(created: created!)
        }
        
        return success
    }
    
    mutating func performMethodAccepted     (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Accepted?
                                            ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var accepted        : Accepted?             =   nil
        
        (success, accepted)                         =   actionAccepted  (
                                    action:             action,
                                    setOrSaveValue:     object
                                                                        )
        
        if success
        {
            if let request = self.privateRequest
            {
                request.privateAccepted             =   accepted!
            }
            else
            {
                printNilParentObjectFound(object: .requests)
            }
        }
        
        return success
    }
    
    mutating func performMethodCommunicated (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Communicated?
                                            ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var communicated    : Communicated?         =   nil
        
        (success, communicated)                     =   actionCommunicated  (
                                                        action:             action,
                                                        setOrSaveValue:     object
                                                                            )
        
        if success
        {
            if let request = self.privateRequest
            {
                request.privateCommunicated         =   communicated!
            }
            else
            {
                printNilParentObjectFound(object: .requests)
            }
        }
        
        return success
    }
    
    mutating func performMethodService      (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Service?
                                            ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var service         : Service?              =   nil
        
        (success, service)                          =   actionService       (
                                                        action:             action,
                                                        setOrSaveValue:     object
                                                                            )
        
        if success
        {
            if let request = self.privateRequest
            {
                request.privateService              =   service!
            }
            else
            {
                printNilParentObjectFound(object: .requests)
            }
        }
        
        return success
    }
    
    mutating func performMethodPayed        (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Payed?
                                            ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var payed           : Payed?                =   nil
        
        (success, payed)                            =   actionPayed         (
                                                        action:             action,
                                                        setOrSaveValue:     object
                                                                            )
        
        if success
        {
            if let request = self.privateRequest
            {
                request.privatePayed                =   payed!
            }
            else
            {
                printNilParentObjectFound(object: .requests)
            }
        }
        
        return success
    }
    
    mutating func performMethodReviewed     (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Reviewed?
                                            ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var reviewed        : Reviewed?             =   nil
        
        (success, reviewed)                         =   actionReviewed      (
                                                        action:             action,
                                                        setOrSaveValue:     object
                                                                            )
        
        if success
        {
            if let request = self.privateRequest
            {
                request.privateReviewed             =   reviewed!
            }
            else
            {
                printNilParentObjectFound(object: .requests)
            }
        }
        
        return success
    }
    
    mutating func performMethodRequest      (
                                    method:             MethodType                  ,
                    setOrSaveValue  object:             Request?
                                            ) -> Bool
    {
        let action          : ActionType            =   method.action
        var success         : Bool                  =   false
        var request         : Request?              =   nil
        
        (success, request)                          =   actionRequest       (
                                                        action:             action,
                                                        setOrSaveValue:     object
                                                                            )
        
        if success
        {
            self.privateRequest                     =   request!
        }
        
        return success
    }
    
    mutating func registerIsCoach       (isCoach: Bool) -> Bool
    {
        return performMethodIsCoach(method: .register, setOrSaveValue: isCoach)
    }
    
    mutating func registerLogIn         ()  -> Bool
    {
        return performMethodLogIn       (method: .register, setOrSaveValue: true)
    }
    mutating func registerLogOff        () -> Bool
    {
        return performMethodLogIn       (method: .register, setOrSaveValue: false)
    }
    mutating func registerSignUp        ()  -> Bool
    {
        return performMethodSignUp      (method: .register, setOrSaveValue: true)
    }
    mutating func registerUser          (
                                    user:               User?
                                        )   -> Bool
    {
        return performMethodUser               (method: .register, setOrSaveValue: user)
    }
    mutating func registerStudent       (
                                    student:            Student?
                                        )   -> Bool
    {
        return performMethodStudent            (method: .register, setOrSaveValue: student)
    }
    mutating func registerCoach         (
                                    coach:              Coach?
                                        )   -> Bool
    {
        return performMethodCoach              (method: .register, setOrSaveValue: coach)
    }
    mutating func registerCreated       (
                                    created:            Created?
                                        )   -> Bool
    {
        return performMethodCreated            (method: .register, setOrSaveValue: created)
    }
    mutating func registerAccepted      (
                                    accepted:           Accepted?
                                        )   -> Bool
    {
        return performMethodAccepted           (method: .register, setOrSaveValue: accepted)
    }
    mutating func registerCommunicated  (
                                    communicated:       Communicated?
                                        )   -> Bool
    {
        return performMethodCommunicated       (method: .register, setOrSaveValue: communicated)
    }
    mutating func registerService       (
                                    service:            Service?
                                        )   -> Bool
    {
        return performMethodService            (method: .register, setOrSaveValue: service)
    }
    mutating func registerPayed         (
                                    payed:              Payed?
                                        )   -> Bool
    {
        return performMethodPayed              (method: .register, setOrSaveValue: payed)
    }
    mutating func registerReviewed      (
                                    reviewed:           Reviewed?
                                        )   -> Bool
    {
        return performMethodReviewed           (method: .register, setOrSaveValue: reviewed)
    }
    mutating func registerRequest       (
                                    request:            Request?
                                        )   -> Bool
    {
        return performMethodRequest            (method: .register, setOrSaveValue: request)
    }
    
    mutating func configureIsCoach      () -> Bool
    {
        return performMethodIsCoach         (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureLogIn        () -> Bool
    {
        return performMethodLogIn           (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureSignUp       () -> Bool
    {
        return performMethodSignUp          (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureUser         () -> Bool
    {
        return performMethodUser            (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureStudent      () -> Bool
    {
        return performMethodStudent         (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureCoach        () -> Bool
    {
        return performMethodCoach           (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureCreated      () -> Bool
    {
        return performMethodCreated         (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureAccepted     () -> Bool
    {
        return performMethodAccepted        (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureCommunicated () -> Bool
    {
        return performMethodCommunicated    (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureService      () -> Bool
    {
        return performMethodService         (method: .configure, setOrSaveValue: nil)
    }
    mutating func configurePayed        () -> Bool
    {
        return performMethodPayed           (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureReviewed     () -> Bool
    {
        return performMethodReviewed        (method: .configure, setOrSaveValue: nil)
    }
    mutating func configureRequest      () -> Bool
    {
        return performMethodRequest         (method: .configure, setOrSaveValue: nil)
    }
}

class Persistence: PersistenceType
{
    var isCoach: Bool = false

    enum Action: String
    {
        case save
        case retrieve
        
        var verbPastTense       : String
        {
            return "\(key)d"
        }
    }
    
    enum Method: String
    {
        case register
        case configure
        
        var action              : ActionType
        {
            switch self
            {
            case .configure:
                return Persistence.Action.retrieve
            case .register:
                return Persistence.Action.save
            }
        }
        
        var verbPastTense       : String
        {
            switch self
            {
            case .configure:
                return "\(key)d"
            case .register:
                return "\(key)ed"
            }
        }
    }
    
    var privateIsLoggedIn       : Bool!             = false
    var privateHasSignedUp      : Bool!             = false
    var privateIsCoach          : IsCoach           = IsCoach.none
    var privateCoachOrNot       : Bool!             = false

    var privateUser             : User?
    var privateStudent          : Student?
    var privateCoach            : Coach?
    var privateRequest          : Request?
    
    static var shared           : Persistence       = Persistence()
}

