//
//  Student.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/22/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation

protocol StudentType: UserType
{
    
}

class Student: StudentType
{
    var privateFirebaseID: String?
    var privateFacebookID: String?
    var privateFullName: String?
    var privateCell: String?
    var privateImageURL: String?
    
    var firebaseID: String?
    {
        return privateFirebaseID
    }
    var facebookID: String?
    {
        return privateFacebookID
    }
    
    var fullName: String?
    {
        return privateFullName
    }
    var firstName: String?
    {
        return self.parseFirstName()
    }
    
    var cell: String?
    {
        return privateCell
    }
    var imageURL: String?
    {
        return privateImageURL
    }
    
    required init() {}
}
