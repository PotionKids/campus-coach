//
//  fetchFirebaseObject.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/7/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

func fetchFirebaseObject(from ref: FIRDatabaseReference) -> [Key : Value]
{
    var data = [Key : Value]()
    let _refHandle: FIRDatabaseHandle = ref.observe(.value, with:
        { (snapshot) -> Void in
            guard let fetchedData = snapshot as? [Key : Value] else { return } // MARK: Debug Check...
            data = fetchedData
    })
    ref.removeObserver(withHandle: _refHandle)
    return data
}
