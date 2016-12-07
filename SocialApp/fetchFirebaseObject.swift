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
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshots
                {
                    print("KRIS: Snapshot is \(snap)")
                }
                guard let fetchedData = snapshots[0].value as? AnyDictionary else { return }
                data = fetchedData
                print("KRIS: User Data is \(fetchedData)")
            }
    })
    ref.removeObserver(withHandle: _refHandle)
    return data
}
