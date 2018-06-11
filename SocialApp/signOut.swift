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


func signOutOf(vc: UIViewController, viewController startingVC: ViewController)
{
    KeychainWrapper.standard.removeObject(forKey: Constants.Firebase.KeychainWrapper.KeyUID)
    try! FIRAuth.auth()?.signOut()
    Persistence.shared.registerLogOff()
    let endingVC    = ViewController.SignUp
    let identifier  = startingVC.segueIdentifier(toEndingVC: endingVC)
    vc.performSegue(withIdentifier: identifier, sender: nil)
}
