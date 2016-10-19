//
//  GymStatistics.swift
//  UpcomingMetalShows
//
//  Created by Kris Rajendren on Oct/12/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import Foundation
import MapKit

enum Building: String
{
    case White = "White Bldg"
    case IM = "IM Bldg"
    case Rec = "Rec Hall"
    
    var location: CLLocation
    {
        switch self
        {
            case .White: return Constants.Gym.Location.WhiteBldg
            case .IM: return Constants.Gym.Location.IMBldg
            case .Rec: return Constants.Gym.Location.RecHall
        }
    }
}

class Gym
{
    static var statistics: GymStat = [:]
}
