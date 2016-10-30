//
//  firebaseAuth.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/29/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

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
