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

class SignUpVC: UIViewController {
    
    var isCoach = false
    var userID: String!
    
    @IBOutlet weak var cellNumberTextField: UITextField!
    
    
    @IBAction func facebookClockIn(_ sender: AnyObject)
    {
        if let cell = cellNumberTextField.text
        {
            if cell.isEmpty
            {
                displayAlert(self, title: Constants.Alert.Title.EmptyCellNumber, message: Constants.Alert.Message.EmptyCellNumber)
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
                        firebaseAuth(self.isCoach, cell: cell, credential: credential, vc: self)
                    }
                }
            }
        }
    }
    
    @IBAction func userIndicate(_ sender: AnyObject)
    {
        if isCoach
        {
            isCoach = false
        }
    }
    
    @IBAction func coachIndicate(_ sender: AnyObject)
    {
        if !isCoach
        {
            isCoach = true
        }
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBAction func signIn(_ sender: AnyObject)
    {
        if let cell = cellNumberTextField.text
        {
            if cell.isEmpty
            {
                displayAlert(self, title: Constants.Alert.Title.EmptyCellNumber, message: Constants.Alert.Message.EmptyCellNumber)
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
                                        completeSignIn(isCoach: self.isCoach, cell: cell, user: user, credential: nil, vc: self)
                                    }
                                })
                            }
                            else
                            {
                                completeSignIn(isCoach: self.isCoach, cell: cell, user: user, credential: nil, vc: self)
                            }
                        })
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: Constants.Firebase.KeychainWrapper.KeyUID)
        {
            print("KRIS: ID found in Keychain.")
            performSegue(withIdentifier: Constants.SignUpVC.Segue.SignUpToSetGymMap, sender: nil)
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
