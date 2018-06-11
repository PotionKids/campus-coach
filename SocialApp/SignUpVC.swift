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
    var isEmpty: Bool
    {
        return self == ""
    }
}

extension Optional
{
    var isNil: Bool
    {
        return self == nil
    }
    var isNotNil: Bool
    {
        return self != nil
    }
}

enum IsCoach: String
{
    case yes
    case no
    case none
}

class SignUpVC: UIViewController, UITextFieldDelegate
{
    private var startingVC              = ViewController.SignUp
    private var hasSignedUp:    Bool    = false
    private var isLoggedIn:     Bool    = false
    private var coachOrNot:     Bool?
    private var userID:         String?
    private var studentID:      String?
    private var coachID:        String?
    private var requestID:      String?

    private var isCoach:        IsCoach = .none
    {
        willSet
        {
            coachOrNot = newValue.bool
        }
    }
    
    private var user:           User?
    {
        willSet
        {
            userID      = newValue?.firebaseUID
        }
    }
    private var student:        Student?
    {
        willSet
        {
            studentID   = newValue?.firebaseUID
        }
    }
    private var coach:          Coach?
    {
        willSet
        {
            coachID     = newValue?.firebaseUID
        }
    }
    private var request:        Request?
    {
        willSet
        {
            requestID   = newValue?.firebaseRID
        }
    }
    
    @IBOutlet weak var cellNumberTextField: UITextField!
    {
        didSet
        {
            cellNumberTextField.delegate    = self
            cellNumberTextField.text        = "+1(814)321-7651"
        }
    }
    
    
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
                    if !self.hasSignedUp
                    {
                        self.hasSignedUp = true
                        Persistence.shared.registerSignUp()
                    }
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
    {
        didSet
        {
            emailTextField.delegate     = self
            emailTextField.text         = "abc@def.com"
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    {
        didSet
        {
            passwordTextField.delegate  = self
            passwordTextField.text      = "abcdef"
        }
    }
    
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
                if email.isEmpty && !password.isEmpty
                {
                    displayAlert(self, title: Constants.Alert.Title.EmptyUserName, message: Constants.Alert.Message.EmptyUserName)
                }
                else if !email.isEmpty && password.isEmpty
                {
                    displayAlert(self, title: Constants.Alert.Title.EmptyPassword, message: Constants.Alert.Message.EmptyPassword)
                }
                else if email.isEmpty && password.isEmpty
                {
                    displayAlert(self, title: Constants.Alert.Title.EmptyUserNameAndPassword, message: Constants.Alert.Message.EmptyUserNameAndPassword)
                }
                else
                {
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil
                        {
                            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion:
                            { (user, error) in
                                if let error = error
                                {
                                    print("KRIS: Unable to create user using email in Firebase. Erro \(error)")
                                }
                                else
                                {
                                    print("KRIS: Successfully created a new user with email in Firebase.")
                                    self.hasSignedUp    = true
                                    self.isLoggedIn     = true
                                    Persistence.shared.registerSignUp()
                                    completeSignIn(isCoach: self.coachOrNot!, user: user, credential: nil, vc: self)
                                }
                            })
                        }
                        else
                        {
                            self.isLoggedIn     = true
                            completeSignIn(isCoach: self.coachOrNot!, user: user, credential: nil, vc: self)
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidLoad   ()
    {
        super.viewDidLoad       ()
        
        configureSignUp         ()
        configureLogIn          ()
//        configureUser           ()
    }
    
    func configureDatabase      ()
    {
        // Check if the Request Created by User is Accepted if Student
        // Check if the Request Created by User has Started if Student
        // Check if the Request Created by User has Stopped if Student
        // Check if the Request Stopped by User has been Payed for if Coach
        // Check if the Request Stopped by User has been Reviewed if Coach
    }
    
    func configureIsCoach       ()
    {
        let _                   = Persistence.shared.configureIsCoach   ()
        self.coachOrNot         = Persistence.shared.isCoach
        self.isCoach            = coachOrNot!.isCoach
    }
    
    func configureSignUp        ()
    {
        let _                   = Persistence.shared.configureSignUp    ()
        self.hasSignedUp        = Persistence.shared.hasSignedUp
    }
    
    func configureLogIn         ()
    {
        let _                   = Persistence.shared.configureLogIn     ()
        self.isLoggedIn         = Persistence.shared.isLoggedIn
    }
    
    func configureUser          ()
    {
        configureIsCoach        ()
        configureStudent        ()
        configureCoach          ()
        
        switch self.isCoach
        {
        case .yes:
            if let userData     = self.coach?.anyDictionary
            {
                self.user           = User(fromUserData: userData)
            }
        case .no:
            if let userData        = self.student?.anyDictionary
            {
                self.user           = User(fromUserData: userData)
            }
        case .none:
            break
        }
    }
    
    func configureStudent       ()
    {
        let _                   = Persistence.shared.configureStudent   ()
        self.student            = Persistence.shared.student
    }
    
    func configureCoach         ()
    {
        let _                   = Persistence.shared.configureCoach     ()
        self.coach              = Persistence.shared.coach
    }
    
    func configureRequest       ()
    {
        let _                   = Persistence.shared.configureRequest   ()
        self.request            = Persistence.shared.request
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        configureUser           ()
        configureRequest        ()
        configureLogIn          ()
        
        if let userID       = KeychainWrapper.standard.string(forKey: Constants.DataService.User.UID)
        {
            print("KRIS: USERID in Keychain is \(userID)")
            print("KRIS: USERID in Persistence is \(self.coachID!)")

            var endingVC        = ViewController.None
            if coachOrNot!
                {
                    if isLoggedIn
                    {
                        endingVC        = ViewController.CoachRequests
                        let identifier  = startingVC.segueIdentifier(toEndingVC: endingVC)
                        performSegue(withIdentifier: identifier, sender: nil)
                    }
                }
            else
            {
                print("KRIS: It is true that the User is Logged In.")
                if isLoggedIn
                {
                    endingVC        = ViewController.SetGym
                    let identifier  = startingVC.segueIdentifier(toEndingVC: endingVC)
                    performSegue(withIdentifier: identifier, sender: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning()
    {
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
