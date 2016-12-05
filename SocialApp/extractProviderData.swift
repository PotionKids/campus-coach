//
//  extractProviderData.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/29/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Firebase
import FirebaseAuth

func extractProviderData(isCoach: Bool, cell: String, user: FIRUser, credential: FIRAuthCredential) -> (FirebaseData?, User?)
{
    var userData: FirebaseData = [:]
    var userObject: User?
    var name: String?
    var email: String?
    var uid: String?
    
    let userProfile = user.providerData
    for profile in userProfile
    {
        name = profile.displayName
        email = profile.email
        uid = profile.uid
        if let uid = uid
        {
            if  let name = name,
                let email = email
            {
                let loggedInAtTime = timeStamp().stampNanoseconds
                
                userData =
                [
                    Constants.DataService.User.FirebaseUID      : user.uid,
                    Constants.DataService.User.IsCoach          : isCoach.stringYesNo,
                    Constants.DataService.User.Provider         : credential.provider,
                    Constants.DataService.User.LoggedInAtTime   : loggedInAtTime,
                    Constants.DataService.User.FacebookUID      : uid,
                    Constants.DataService.User.FullName         : name,
                    Constants.DataService.User.Email            : email,
                    Constants.DataService.User.Cell             : cell,
                    Constants.DataService.User.FirebaseRID      : Constants.Literal.Empty,
                    Constants.DataService.User.Requests         : Constants.Literal.Empty,
                    Constants.DataService.User.FirebaseUIDs     : user.uid,
                    Constants.DataService.User.Rating           : Constants.DataService.User.DefaultRating.string,
                    Constants.DataService.User.Ratings          : Constants.DataService.User.DefaultRating.string,
                    Constants.DataService.User.Reviews          : Constants.Literal.Empty
                ]
                print(userData)
                userObject = User(fromUserData: userData as AnyDictionary)
                print(userObject!.stringDictionary)

            }
            else
            {
                print("Facebook Profile Details couldn't be retrieved for the user. Returning default user.")
                userObject = User()
            }
        }
        else
        {
            print("The Facebook Profile UID couldn't be retrieved.")
            return (nil, nil)
        }
    }
    return (userData, userObject)
}

