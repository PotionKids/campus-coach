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

func completeSignIn(isCoach: Bool, cell: String, user: FIRUser?, credential: FIRAuthCredential?, vc: UIViewController)
{
    var id: String?
    var userData: FirebaseData?
    (id, userData) = extractUserData(user: user, credential: credential)
    let _ = userData?.updateValue(cell, forKey: Constants.DataService.User.Cell)
    
    if let id = id, let userData = userData
    {
        KeychainWrapper.standard.set(id, forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        if isCoach
        {
            DataService.ds.createFirebaseObject(object: .Coaches, instanceID: id, data: userData)
            vc.performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToCoachRequests, sender: nil)
        }
        else
        {
            DataService.ds.createFirebaseObject(object: .Users, instanceID: id, data: userData)
            vc.performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToSetGymMap, sender: nil)
        }
    }
    print("KRIS: Authentication Failed.")
}
