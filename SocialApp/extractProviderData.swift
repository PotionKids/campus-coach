//
//  extractProviderData.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/29/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Firebase
import FirebaseAuth

func extractProviderData(user: FIRUser, credential: FIRAuthCredential) -> FirebaseData
{
    var userData: FirebaseData = [:]
    var name: String?
    var email: String?
    var uid: String?
    var imageURLString: String!
    
    let userProfile = user.providerData
    for profile in userProfile
    {
        name = profile.displayName
        email = profile.email
        uid = profile.uid
        if let uid = uid
        {
            imageURLString = "\(Constants.Facebook.Profile.ImageURLPrefix)\(uid)\(Constants.Facebook.Profile.ImageURLSuffix)"
            if let name = name,
                let email = email
            {
                userData = [
                    Constants.Firebase.Key.UID : user.uid,
                    Constants.Facebook.Key.Provider : credential.provider,
                    Constants.Facebook.Key.UID : uid,
                    Constants.Facebook.Key.Name : name,
                    Constants.Facebook.Key.Email : email,
                    Constants.Facebook.Key.ImageURLString : imageURLString
                ]
            }
            else
            {
                print("Facebook Profile Details couldn't be retrieved for the user.")
                imageURLString = Constants.String.Empty
            }
        }
        else
        {
            print("The Facebook Profile UID couldn't be retrieved.")
        }
    }
    return userData
}

