//
//  completeSignIn.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/29/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import SwiftKeychainWrapper

extension Bool
{
    func toString() -> String
    {
        if self { return "true" }
        else    { return "false" }
    }
}

func completeSignIn(isCoach: Bool, cell: String, user: FIRUser?, credential: FIRAuthCredential?, vc: UIViewController)
{
    var id: String?
    var userData: FirebaseData?
    var userObject: User?
    (id, userData, userObject) = extractUserData(isCoach: isCoach, cell: cell, user: user, credential: credential)
    print("KRIS: ID \(id), userData \(userData) and userObject \(userObject)")
    
    if let id = id, let userObject = userObject
    {
        KeychainWrapper.standard.set(id, forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        userObject.push()
        if isCoach
        {
            vc.performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToCoachRequests, sender: nil)
        }
        else
        {
            vc.performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToSetGymMap, sender: nil)
        }
    }
    else
    {
        print("KRIS: Authentication Failed.")
    }
}
