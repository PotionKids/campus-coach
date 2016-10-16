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
            print("KRIS: Successfully authenticated with Firebase.")
            if let user = user
            {
                completeSignIn(id: user.uid, vc: vc)
            }
        }
    })
}

func completeSignIn(id: String, vc: UIViewController)
{
    KeychainWrapper.defaultKeychainWrapper.set(id, forKey: Constants.Firebase.KeychainWrapper.KeyUID)
    vc.performSegue(withIdentifier: Constants.ViewController.Segue.SignUpToSetGym, sender: nil)
}



