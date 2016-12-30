//
//  signOut.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/12/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

func signOutOf(viewController vc: UIViewController, withSegue identifier: String)
{
    KeychainWrapper.standard.removeObject(forKey: Constants.Firebase.KeychainWrapper.KeyUID)
    try! FIRAuth.auth()?.signOut()
    vc.performSegue(withIdentifier: identifier, sender: nil)
}
