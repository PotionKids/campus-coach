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

func firebaseAuth(_ isCoach: Bool, credential: FIRAuthCredential, vc: UIViewController)
{
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
        if let error = error
        {
            print("KRIS: ERROR - Unable to authenticate with Firebase = \(error)")
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
            completeSignIn(isCoach: isCoach, user: user, credential: credential, vc: vc)
        }
    })
}

func extractUserData(user: FIRUser?, isCoach: Bool, credential: FIRAuthCredential?) -> (String?, FirebaseData?)
{
    if let user = user
    {
        let id = user.uid
        var userData: FirebaseData = [:]
        if let credential = credential
        {
            userData = extractProviderData(user: user, isCoach: isCoach, credential: credential)
        }
        else
        {
            let loggedInAtTime  = timeStamp().stampNanoseconds
            userData            =
                [
                    Constants.DataService.User.FirebaseUID      : user.uid,
                    Constants.DataService.User.IsCoach          : isCoach.stringYesNo,
                    Constants.DataService.User.Provider         : user.providerID,
                    Constants.DataService.User.LoggedInAtTime   : loggedInAtTime,
                    Constants.DataService.User.FacebookUID      : Constants.DataService.User.DefaultFacebookUID,
                    Constants.DataService.User.FullName         : Constants.DataService.User.DefaultUserName,
                    Constants.DataService.User.Email            : user.email!,
                    Constants.DataService.User.Cell             : Constants.Literal.Empty,
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

func extractProviderData(user: FIRUser, isCoach: Bool, credential: FIRAuthCredential) -> FirebaseData
{
    var userData: FirebaseData = [:]
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
            if  let name    = name,
                let email   = email
            {
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
                        Constants.DataService.User.Cell             : Constants.Literal.Empty,
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
                print("KRIS: Facebook Profile Details couldn't be retrieved for the user.")
            }
        }
        else
        {
            print("KRIS: The Facebook Profile UID couldn't be retrieved.")
        }
    }
    return userData
}

func completeSignIn(isCoach: Bool, user: FIRUser?, credential: FIRAuthCredential?, vc: UIViewController)
{
    var id: String?
    var userData: FirebaseData?
    (id, userData) = extractUserData(user: user, isCoach: isCoach, credential: credential)
    
    if let id = id, let userData = userData
    {
        KeychainWrapper.standard.set(id, forKey: Constants.DataService.User.UID)
        let userObject = User(fromUserData: userData)!
        Persistence.shared.registerUser(user: userObject)
        vc.performSegue(withIdentifier: loginSegueIdentifier(isCoach: isCoach), sender: Persistence.shared.user)
    }
    else
    {
        print("KRIS: Authentication Failed.")
    }
}

func registerSignUp()
{
    let _ = Persistence.shared.registerSignUp()
    print("KRIS: Firebase Keys                  \(User.keys.firebase)")
    print("KRIS: Save Keys Register Sign Up     \(User.keys.save)")
    print("KRIS: User Saved Register Sign Up    \(Persistence.shared.user.anyDictionaryForSaving.forcedStringLiteral)")
    print("KRIS: The User Has Signed Up Register Sign Up.")
}

func userIsLoggedIn() -> Bool
{
    var status = false
    if let loggedIn = KeychainWrapper.standard.bool(forKey: Constants.DataService.User.UID)
    {
        status = loggedIn
    }
    return status
}

func userHasSignedUp() -> Bool
{
    let status  = false
    let _ = Persistence.shared.registerSignUp()
    return status
}

func signedUpOrLoggedIn() -> Bool
{
    var status: Bool!
    if let signedIn    = KeychainWrapper.standard.bool(forKey: Constants.DataService.User.UID)
    {
        status = signedIn
    }
    else if let signedUp = UserDefaults.standard.value(forKey: Constants.DataService.User.HasSignedUp) as? Bool

    {
        print("KRIS: Sign Up Status as Stored is \(status)")
        status = signedUp
    }
    return status
}

func loginSegueIdentifier(isCoach: Bool) -> String
{
    if signedUpOrLoggedIn()
    {
        if isCoach
        {
            return Constants.SignUpVC.Segue.SignUpToCoachRequests
        }
        else
        {
            return Constants.SignUpVC.Segue.SignUpToSetGymMap
        }
    }
    else
    {
        return Constants.SignUpVC.Segue.ToSaveCellVC
    }
}

func signUpSegueIdentifier(isCoach: Bool) -> String
{
    if isCoach
    {
        return Constants.SaveCellVC.Segue.ToCoachRequestsVC
    }
    else
    {
        return Constants.SaveCellVC.Segue.ToSetGymVC
    }
}

func serviceSegueIdentifier(isCoach: Bool) -> String
{
    if isCoach
    {
        return Constants.SignUpVC.Segue.ToCoachServiceVC
    }
    else
    {
        return Constants.SignUpVC.Segue.ToStudentService
    }
}

//func serviceSegueSender(isCoach: Bool) -> FirebaseIDable
//{
//    if isCoach
//    {
//        return selfStudent
//    }
//    else
//    {
//        return selfRequest
//    }
//}

func performLoginSegue(fromViewController vc: UIViewController, forUserWhoIsACoach isCoach: Bool, sender: Any? = nil)
{
    vc.performSegue(withIdentifier: loginSegueIdentifier(isCoach: isCoach), sender: sender)
}

func performSignUpSegue(fromViewController vc: UIViewController, forUserWhoIsACoach isCoach: Bool, sender: Any? = nil)
{
    vc.performSegue(withIdentifier: signUpSegueIdentifier(isCoach: isCoach), sender: sender)
}

func performServiceSegue(fromViewController vc: UIViewController, forUserWhoIsACoach isCoach: Bool, sender: Any? = nil)
{
    vc.performSegue(withIdentifier: serviceSegueIdentifier(isCoach: isCoach), sender: sender)
}
