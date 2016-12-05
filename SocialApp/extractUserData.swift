//
//  extractUserData.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/29/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Firebase
import FirebaseAuth

func extractUserData(isCoach: Bool, cell: String, user: FIRUser?, credential: FIRAuthCredential?) -> (String?, FirebaseData?, User?)
{
    if let user = user
    {
        let id = user.uid
        var userData: FirebaseData? = [:]
        var userObject: User?
        if let credential = credential
        {
            (userData, userObject) = extractProviderData(isCoach: isCoach, cell: cell, user: user, credential: credential)
        }
        else
        {
            let loggedInAtTime  = timeStamp().stampNanoseconds
            let defaultName     = Constants.DataService.User.DefaultUserName
            userData            =
            [
                Constants.DataService.User.FirebaseUID      : user.uid,
                Constants.DataService.User.IsCoach          : isCoach.stringYesNo,
                Constants.DataService.User.Provider         : user.providerID,
                Constants.DataService.User.LoggedInAtTime   : loggedInAtTime,
                Constants.DataService.User.FacebookUID      : Constants.DataService.User.DefaultFacebookUID,
                Constants.DataService.User.FullName         : defaultName,
                Constants.DataService.User.Email            : user.email!,
                Constants.DataService.User.Cell             : cell,
                Constants.DataService.User.FirebaseRID      : Constants.Literal.Empty,
                Constants.DataService.User.Requests         : Constants.Literal.Empty,
                Constants.DataService.User.FirebaseUIDs     : user.uid,
                Constants.DataService.User.Rating           : Constants.DataService.User.DefaultRating.string,
                Constants.DataService.User.Ratings          : Constants.DataService.User.DefaultRating.string,
                Constants.DataService.User.Reviews          : Constants.Literal.Empty
            ]
            print(userData!)
            userObject      = User(fromUserData: userData! as AnyDictionary)
            print(userObject!.stringDictionary)
        }
        return (id, userData, userObject)
    }
    else
    {
        print("KRIS: Firebase Authentication Failed.")
        return (nil, nil, nil)
    }
}
