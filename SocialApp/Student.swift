//
//  Student.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/22/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

class Student: User, RevieweeArchivable
{
    var keys: KeysType
    {
        return Constants.Protocols.StudentType.keys
    }
}
