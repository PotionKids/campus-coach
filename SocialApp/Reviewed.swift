//
//  Reviewed.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/7/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

protocol Reviewable: HappenedType, FirebaseRequestIDable, Pushable
{
    var privateRating:                      String!     { get set }
    var privateReview:                      String!     { get set }
    
    var rating:                             String      { get }
    var review:                             String      { get }
    
    var ratingValue:                        Double      { get }
    
    init    ()
    
    init    (
        internallyWithFirebaseRID
        firebaseRID:    String,
        atTime:         String,
        rating:         String,
        review:         String
    )
    
    init?   (
        fromServerWithFirebaseRID
        firebaseRID:    String
    )
    
    func push()
}
extension Reviewable
{
    var rating: String
    {
        return privateRating
    }
    var review: String
    {
        return privateReview
    }
    var ratingValue: Double
    {
        return rating.double!
    }
    
    func push()
    {
        pushValuesToFirebase(forKeys: keys.firebase, at: requestReviewedRef)
    }
    
    var keys: KeysType
    {
        return Constants.Protocols.Reviewable.keys
    }
}

class Reviewed: Reviewable
{
    var privateOrNot:       String! = YesOrNo.Yes.string
    var privateAtTime:      String!
    var privateRating:      String! = Constants.DataService.User.DefaultRating.string
    var privateReview:      String! = Constants.Literal.Empty
    var privateFirebaseRID: String!
    
    required init()
    {
        self.privateAtTime      = timeStamp().stampNanoseconds
        self.privateFirebaseRID = self.privateAtTime
    }
    
    required convenience init   (
        internallyWithFirebaseRID
        firebaseRID:    String,
        atTime:         String,
        rating:         String,
        review:         String
        )
    {
        self.init()
        self.privateAtTime      = atTime
        self.privateRating      = rating
        self.privateReview      = review
        self.privateFirebaseRID = firebaseRID
    }
    
    required convenience init?  (
        fromServerWithFirebaseRID
        firebaseRID:    String
        )
    {
        let data    = fetchFirebaseObject(from: firebaseRID.requestReviewedRef)
        guard   let atTime  = data[Constants.Protocols.HappenedType .atTime]    as? String,
            let rating  = data[Constants.Protocols.Reviewable   .rating]    as? String,
            let review  = data[Constants.Protocols.Reviewable   .review]    as? String
            else
        {
            return nil
        }
        self.init   (
            internallyWithFirebaseRID:  firebaseRID,
            atTime:                     atTime,
            rating:                     rating,
            review:                     review
        )
    }
}
