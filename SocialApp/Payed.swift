//
//  Payed.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/7/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

protocol Payable: HappenedType, Billable, Commissionable, Tippable, TipCommissionable, FirebaseRequestIDable, Pushable
{
    var privateService:             Service?    { get set }
    var service:                    Service?    { get }
    
    var coachFee:                   String      { get }
    var coachFeeInDollars:          Cost        { get }
    
    var amount:                     String      { get }
    var coachAmount:                String      { get }
    var commissionEarned:           String      { get }
    var tipCoach:                   String      { get }
    var tipCommissionEarned:        String      { get }
    
    var amountInDollars:            Dollars     { get }
    var coachAmountInDollars:       Dollars     { get }
    var commissionInDollars:        Dollars     { get }
    var tipCoachInDollars:          Dollars     { get }
    var tipCommissionInDollars:     Dollars     { get }
    
    var totalPayed:                 String      { get }
    var totalCoachAmount:           String      { get }
    var totalCommission:            String      { get }
    
    var totalPayedInDollars:        Dollars     { get }
    var totalCoachAmountInDollars:  Dollars     { get }
    var totalCommissionInDollars:   Dollars     { get }
    
    init    ()
    
    init    (
        internallyWithFirebaseRID
        firebaseRID:    String,
        service:        Service,
        costPerHour:    String,
        commission:     String,
        tipCommission:  String,
        tip:            String
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
extension Payable
{
    var firebaseID: String
    {
        return firebaseRID
    }
    
    var service: Service?
    {
        return privateService
    }
    
    var coachFeeInDollars:          Cost
    {
        return costInDollars * coachFraction
    }
    var coachFee:                   String
    {
        return coachFeeInDollars.string
    }
    
    var amountInDollars:            Dollars
    {
        if let service = service
        {
            return costInDollars.toTotalAmount(for: service.timeInterval)
        }
        else
        {
            return 0.0
        }
    }
    var coachAmountInDollars:       Dollars
    {
        return amountInDollars  *       coachFraction
    }
    var commissionInDollars:        Dollars
    {
        return amountInDollars  *       commissionFraction
    }
    var tipCoachInDollars:          Dollars
    {
        return tipInDollars     *       tipCoachFraction
    }
    var tipCommissionInDollars:     Dollars
    {
        return tipInDollars     *       tipCommissionFraction
    }
    
    var amount:                     String
    {
        return amountInDollars          .string
    }
    var coachAmount:                String
    {
        return coachAmountInDollars     .string
    }
    var commissionEarned:           String
    {
        return commissionInDollars      .string
    }
    var tipCoach:                   String
    {
        return tipCoachInDollars        .string
    }
    var tipCommissionEarned:        String
    {
        return tipCommissionInDollars   .string
    }
    
    var totalPayedInDollars:        Dollars
    {
        return amountInDollars      +   tipInDollars
    }
    var totalCoachAmountInDollars:  Dollars
    {
        return coachAmountInDollars +   tipCoachInDollars
    }
    var totalCommissionInDollars:   Dollars
    {
        return commissionInDollars  +   tipCommissionInDollars
    }
    
    var totalPayed:                 String
    {
        return totalPayedInDollars.string
    }
    var totalCoachAmount:           String
    {
        return totalCoachAmountInDollars.string
    }
    var totalCommission:            String
    {
        return totalCommissionInDollars.string
    }
    
    func push()
    {
        pushValuesToFirebase(forKeys: Self.keys.firebase, at: requestPayedRef)
    }
    
    static var keys: KeysType
    {
        return Constants.Protocols.Payable.keys
    }
}

class Payed: Payable
{
    static var setObject:       Firebase.Object!    = Firebase.Object   .none
    static var setChildOf:      Firebase.Object!    = Firebase.Object   .requests
    static var setChild:        Firebase.Child!     = Firebase.Child    .payed
    
    var privateOrNot:           String!             = YesOrNo.Yes       .string
    var privateAtTime:          String!
    var privateService:         Service?            = nil
    var privateCostPerHour:     String!             =
        Constants.DataService.Cost.StudentCostPerHourString
    var privateCommision:       String!             =
        Constants.DataService.Cost.CampusCoachCommissionString
    var privateTip:             String!             =
        Constants.DataService.Cost.DefaultTipString
    var privateTipCommission:   String!             =
        Constants.DataService.Cost.DefaultTipCommissionString
    var privateFirebaseRID:     String!
    
    required init()
    {
        self.privateAtTime                          = timeStamp().stampNanoseconds
        self.privateFirebaseRID                     = self.privateAtTime
    }
    
    required convenience init   (
        internallyWithFirebaseRID
        firebaseRID:    String,
        service:        Service,
        costPerHour:    String                      =
        Constants.DataService.Cost.StudentCostPerHourString     ,
        commission:     String                      =
        Constants.DataService.Cost.CampusCoachCommissionString  ,
        tipCommission:  String                      =
        Constants.DataService.Cost.DefaultTipCommissionString   ,
        tip:            String
                                )
    {
        self.init()
        self.privateFirebaseRID                     = firebaseRID
        self.privateService                         = service
        self.privateCostPerHour                     = costPerHour
        self.privateCommision                       = commission
        self.privateTipCommission                   = tipCommission
        self.privateTip                             = tip
    }
    
    required convenience init?  (
        withFirebaseRID
        firebaseRID:    String,
        fromData
        data:           AnyDictionary
                                )
    {
        guard   let costPerHour                     =
                data[Constants.Protocols.Billable.costPerHour               ] as? String,
                let commission                      =
                data[Constants.Protocols.Commissionable.commission          ] as? String,
                let tipCommission                   =
                data[Constants.Protocols.TipCommissionable.tipCommission    ] as? String,
                let tip                             =
                data[Constants.Protocols.Tippable.tip                       ] as? String,
                let startedAtTime                   =
                data[Constants.Protocols.Starting.startedAtTime             ] as? String,
                let hasEnded                        =
                data[Constants.Protocols.Ending.hasEnded                    ] as? String,
                let endedAtTime                     =
                data[Constants.Protocols.Ending.endedAtTime                 ] as? String
        else
        {
                return nil
        }
        let service                                 = Service   (
                internallyWithFirebaseRID:  firebaseRID,
                startedAtTime:              startedAtTime,
                hasEnded:                   hasEnded,
                endedAtTime:                endedAtTime
                                                                )
        self.init   (
                internallyWithFirebaseRID:  firebaseRID,
                service:                    service,
                costPerHour:                costPerHour,
                commission:                 commission,
                tipCommission:              tipCommission,
                tip:                        tip
                    )
    }
    
    required convenience init?  (
        fromData
        data:           AnyDictionary
                                )
    {
        guard   let firebaseRID                     =
                data[Constants.Protocols.FirebaseRequestIDable.firebaseRID] as? String
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

