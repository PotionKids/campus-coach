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
    
    @IBAction func goToSignInScreen(_ sender: AnyObject)
    {
        performSegue(withIdentifier: "SignUpToSignIn", sender: nil)
    }
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBAction func signIn(_ sender: AnyObject)
    {
        if let email = emailTextField.text,
            let password = passwordTextField.text
        {
            if email.isEmpty() && !password.isEmpty()
            {
                displayAlert(target: self, title: Constants.Alert.Title.EmptyUserName, message: Constants.Alert.Message.EmptyUserName)
                //displayAlert(title: Constants.Alert.Title.EmptyUserName, message: Constants.Alert.Message.EmptyUserName)
            }
            else if !email.isEmpty() && password.isEmpty()
            {
                displayAlert(target: self, title: Constants.Alert.Title.EmptyPassword, message: Constants.Alert.Message.EmptyPassword)
                //displayAlert(title: Constants.Alert.Title.EmptyPassword, message: Constants.Alert.Message.EmptyPassword)
            }
            else if email.isEmpty() && password.isEmpty()
            {
                displayAlert(target: self, title: Constants.Alert.Title.EmptyUserNameAndPassword, message: Constants.Alert.Message.EmptyUserNameAndPassword)
                //displayAlert(title: Constants.Alert.Title.EmptyUserNameAndPassword, message: Constants.Alert.Message.EmptyUserNameAndPassword)
            }
            else
            {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error
                    {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if let error = error
                            {
                                print("KRIS: Unable to create user using email in Firebase.")
                            }
                            else
                            {
                                print("KRIS: Successfully created a new user with email in Firebase.")
                            }
                        })
                    }
                    else
                    {
                        print("KRIS: User email authenticated with Firebase.")
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
