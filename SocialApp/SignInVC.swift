//
//  ViewController.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/13/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {

    var isCoach = false
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    @IBAction func facebookLogin(_ sender: AnyObject)
    {
    
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
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
                firebaseAuth(self.isCoach, credential: credential, vc: self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

