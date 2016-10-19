//
//  Student.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/18/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import UIKit

protocol StudentType: UserType
{
    
}

class Student: UserType
{
    private var Name: String!
    private var Cell: String!
    private var Image: UIImage!
    private var IsCoach: Bool!
    
    var name: String
    {
        return Name
    }
    
    var cell: String
    {
        return Cell
    }
    
    var image: UIImage
    {
        return Image
    }
    
    var location: CLLocation
    {
        return Location
    }
    
    var isCoach: Bool
    {
        return IsCoach
    }
}
