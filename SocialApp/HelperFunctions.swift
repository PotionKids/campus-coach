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

func firebaseAuth(_ isCoach: Bool, cell: String, credential: FIRAuthCredential, vc: UIViewController)
{
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
        if let error = error
        {
            print("KRIS ERROR: Unable to authenticate with Firebase = \(error)")
        }
        else
        {
            if let user = user
            {
                if let vc = vc as? SignUpVC
                {
                    vc.userID = user.uid
                    print("KRIS: User ID = \(vc.userID)")
                }
                else
                {
                    print("KRIS: User ID = \(user.uid). Unable to map SignUpVC")
                }
            }
            else
            {
                print("KRIS: Something's pretty fucked up.")
            }
            completeSignIn(isCoach: isCoach, cell: cell, user: user, credential: credential, vc: vc)
        }
    })
}

func extractUserData(user: FIRUser?, isCoach: Bool, cell: String, credential: FIRAuthCredential?) -> (String?, FirebaseData?)
{
    if let user = user
    {
        let id = user.uid
        var userData: FirebaseData = [:]
        if let credential = credential
        {
            userData = extractProviderData(user: user, isCoach: isCoach, cell: cell, credential: credential)
        }
        else
        {
//            userData =
//            [
//                Constants.Firebase.Key.UID:             id,
//                Constants.DataService.User.Provider:    user.providerID,
//                Constants.DataService.User.Email:       user.email!
//            ]
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
        }
        return (id, userData)
    }
    else
    {
        print("KRIS: Firebase Authentication Failed.")
        return (nil, nil)
    }
}

func extractProviderData(user: FIRUser, isCoach: Bool, cell: String, credential: FIRAuthCredential) -> FirebaseData
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
            if  let name    = name,
                let email   = email
            {
//                userData    =
//                [
//                    Constants.Firebase.Key.UID:             user.uid,
//                    Constants.Facebook.Key.Provider:        credential.provider,
//                    Constants.Facebook.Key.UID:             uid,
//                    Constants.Facebook.Key.Name:            name,
//                    Constants.Facebook.Key.Email:           email,
//                    Constants.Facebook.Key.ImageURLString:  imageURLString
//                ]
                let loggedInAtTime  = timeStamp().stampNanoseconds
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
                
            }
            else
            {
                print("Facebook Profile Details couldn't be retrieved for the user.")
                imageURLString = Constants.Literal.Empty
            }
        }
        else
        {
            print("The Facebook Profile UID couldn't be retrieved.")
        }
    }
    return userData
}

func completeSignIn(isCoach: Bool, cell: String, user: FIRUser?, credential: FIRAuthCredential?, vc: UIViewController)
{
    var id: String?
    var userData: FirebaseData?
    (id, userData) = extractUserData(user: user, isCoach: isCoach, cell: cell, credential: credential)
    let _ = userData?.updateValue(cell, forKey: Constants.DataService.User.Cell)
    
    if let id = id, let userData = userData
    {
        KeychainWrapper.standard.set(id, forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        if isCoach
        {
            DataService.ds.createFirebaseObject(object: .coaches, instanceID: id, data: userData)
            vc.performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToCoachRequests, sender: nil)
        }
        else
        {
            DataService.ds.createFirebaseObject(object: .students, instanceID: id, data: userData)
            vc.performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToSetGymMap, sender: nil)
        }
    }
    print("KRIS: Authentication Failed.")
}



