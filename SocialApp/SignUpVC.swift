//
//  SignUpVC.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/15/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

import FBSDKCoreKit
import FBSDKLoginKit

import SwiftKeychainWrapper

extension String
{
    func isEmpty() -> Bool
    {
        return self == ""
    }
}

extension Optional
{
    func isNil() -> Bool
    {
        return self == nil
    }
}

enum IsCoach: String
{
    case yes
    case no
    case none
}

internal var hasSignedUp: Bool?

class SignUpVC: UIViewController {
    
    private var isCoach: IsCoach = .none
    {
        willSet
        {
            coachOrNot = newValue.bool
        }
    }
    private var coachOrNot: Bool?
    
    var userID:     String!
    
    @IBOutlet weak var cellNumberTextField: UITextField!
    
    
    @IBAction func facebookClockIn(_ sender: AnyObject)
    {
        if isCoach  == .none
        {
            displayAlert(self, title: Constants.Alert.Title.UserStatusBlank, message: Constants.Alert.Message.UserStatusBlank)
        }
        else
        {
            let facebookLogin = FBSDKLoginManager()
            facebookLogin.logIn(withReadPermissions: ["email"], from: self)
            { (result, error) in
                if let error = error
                {
                    print("KRIS ERROR: Unable to authenticate with Facebook = \(error)")
                }
                else if result?.isCancelled == true
                {
                    print("KRIS ERROR: Sorry, the user cancelled Facebook authentication.")
                }
                else
                {
                    print("KRIS: Successfully authenticated with Facebook.")
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    firebaseAuth(self.coachOrNot!, credential: credential, vc: self)
                }
            }
        }
    }
    
    @IBOutlet weak var userIndicateButton: UIButton!
    @IBOutlet weak var coachIndicateButton: UIButton!
    
    @IBAction func userIndicate(_ sender: AnyObject)
    {
        if isCoach == .none
        {
            isCoach = .no
        }
        else if isCoach == .yes
        {
            isCoach = .none
            displayAlert(self, title: Constants.Alert.Title.UserStatusAmbiguous, message: Constants.Alert.Message.UserStatusAmbiguous)
        }
    }
    
    @IBAction func coachIndicate(_ sender: AnyObject)
    {
        if isCoach == .none
        {
            isCoach = .yes
        }
        else if isCoach == .no
        {
            isCoach = .none
            displayAlert(self, title: Constants.Alert.Title.UserStatusAmbiguous, message: Constants.Alert.Message.UserStatusAmbiguous)
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBAction func signIn(_ sender: AnyObject)
    {
        if isCoach  == .none
        {
            displayAlert(self, title: Constants.Alert.Title.UserStatusBlank, message: Constants.Alert.Message.UserStatusBlank)
        }
        else
        {
            if let email = emailTextField.text,
                let password = passwordTextField.text
            {
                if email.isEmpty() && !password.isEmpty()
                {
                    displayAlert(self, title: Constants.Alert.Title.EmptyUserName, message: Constants.Alert.Message.EmptyUserName)
                }
                else if !email.isEmpty() && password.isEmpty()
                {
                    displayAlert(self, title: Constants.Alert.Title.EmptyPassword, message: Constants.Alert.Message.EmptyPassword)
                }
                else if email.isEmpty() && password.isEmpty()
                {
                    displayAlert(self, title: Constants.Alert.Title.EmptyUserNameAndPassword, message: Constants.Alert.Message.EmptyUserNameAndPassword)
                }
                else
                {
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil
                        {
                            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                                if let error = error
                                {
                                    print("KRIS: Unable to create user using email in Firebase. Erro \(error)")
                                }
                                else
                                {
                                    print("KRIS: Successfully created a new user with email in Firebase.")
                                    completeSignIn(isCoach: self.coachOrNot!, user: user, credential: nil, vc: self)
                                }
                            })
                        }
                        else
                        {
                            completeSignIn(isCoach: self.coachOrNot!, user: user, credential: nil, vc: self)
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if signedUpOrLoggedIn()
        {
            print("KRIS: The User has Signed Up View Did Load.")
            Persistence.shared.configureUser()
            print("KRIS: selfUserDefault is \(Persistence.shared.user.anyDictionaryForSaving.forcedStringLiteral)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if signedUpOrLoggedIn()
        {
            Persistence.shared.configureUser()
            if !Persistence.shared.user.firebaseUID.isEmpty
            {
                print("KRIS: ID found in Keychain. \(Persistence.shared.user.firebaseUID)")
                if Persistence.shared.isCoach != .none
                {
                    if Persistence.shared.firebaseRID.isNil()
                    {
                        performLoginSegue(fromViewController: self, forUserWhoIsACoach: Persistence.shared.user.coachOrNot!)
                     }
                    else
                    {
                        print("KRIS: The Firebase RID is \(Persistence.shared.firebaseRID)")
                        print("KRIS: The Request is \(Persistence.shared.request!.stringDictionary)")
                        Persistence.shared.configureCreated()
                        performServiceSegue(fromViewController: self, forUserWhoIsACoach: Persistence.shared.isCoach!)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let serviceVC = segue.destination as? StudentServiceVC
        {
            if let request = sender as? Request
            {
                serviceVC.request       = Persistence.shared.request
                serviceVC.requestRef    = request.firebaseRequestRef
            }
        }
        if let serviceVC = segue.destination as? CoachServiceVC
        {
            serviceVC.gymBldg           = Persistence.shared.created?.forGym
            print("KRIS: Gym \(Persistence.shared.created?.forGym)")
            serviceVC.studentName       = Persistence.shared.student?.firstName
            serviceVC.studentImageURL   = Persistence.shared.student?.facebookImageURLString
            serviceVC.studentCell       = Persistence.shared.student?.cell
            print("KRIS: Student Name \(Persistence.shared.student?.firstName)")
        }
        if let saveCellVC = segue.destination as? SaveCellVC
        {
            saveCellVC.user = Persistence.shared.user
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
