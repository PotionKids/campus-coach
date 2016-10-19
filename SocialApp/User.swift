//
//  User.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/18/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol UserType
{
    var Name: String!           { get set }
    var Cell: String!           { get set }
    var Image: String!          { get set }
    var Location: CLLocation!   { get set }
    var IsCoach: Bool!          { get set }
    
    var name: String            { get }
    var cell: String            { get }
    var image: UIImage          { get }
    var location: CLLocation    { get set }
    var isCoach: Bool           { get }
}
