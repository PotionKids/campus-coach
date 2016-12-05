//
//  fetchFirebaseObject.swift
//  SocialApp
//
//  Created by Kris Rajendren on Nov/13/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

func fetchFirebaseObject(from ref: FIRDatabaseReference) -> [Key : Value]
{
    var data = [Key : Value]()
    var _refHandle: FIRDatabaseHandle = ref.observe(.value, with:
    { (snapshot) -> Void in
        guard let fetchedData = snapshot as? [Key : Value] else { return }
        data = fetchedData
    })
    ref.removeObserver(withHandle: _refHandle)
    return data
}
