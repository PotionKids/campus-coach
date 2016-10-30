//
//  extractUserData.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/29/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Firebase
import FirebaseAuth

func extractUserData(user: FIRUser?, credential: FIRAuthCredential?) -> (String?, FirebaseData?)
{
    if let user = user
    {
        let id = user.uid
        var userData: FirebaseData = [:]
        if let credential = credential
        {
            userData = extractProviderData(user: user, credential: credential)
        }
        else
        {
            userData = [
                Constants.Firebase.Key.UID : id,
                Constants.DataService.User.Provider : user.providerID,
                Constants.DataService.User.Email : (user.email)!
            ]
        }
        return (id, userData)
    }
    else
    {
        print("KRIS: Firebase Authentication Failed.")
        return (nil, nil)
    }
}
