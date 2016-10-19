//
//  HelperFunctions.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/15/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import SwiftKeychainWrapper

func displayAlert(_ target: UIViewController, title: String, message: String, actionTitle: String? = Constants.Alert.Title.OK, actionStyle: UIAlertActionStyle? = .default) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let actionTitle = actionTitle, let actionStyle = actionStyle
    {
        alertController.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
    }
    target.present(alertController, animated: true, completion: nil)
}

func firebaseAuth(_ credential: FIRAuthCredential, vc: UIViewController)
{
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
        if let error = error
        {
            print("KRIS ERROR: Unable to authenticate with Firebase = \(error)")
        }
        else
        {
            completeSignIn(user: user, credential: credential, vc: vc)
        }
    })
}

func completeSignIn(user: FIRUser?, credential: FIRAuthCredential?, vc: UIViewController)
{
    if let user = user
    {
        let id = user.uid
        var userData: [String : String] = [:]
        if let credential = credential
        {
            userData = [Constants.DataService.User.Provider : credential.provider]
        }
        else
        {
            userData = [Constants.DataService.User.Provider : user.providerID]
        }
        
        KeychainWrapper.standard.set(id, forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        vc.performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToSetGymMap, sender: nil)
    }
}



