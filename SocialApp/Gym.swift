//
//  GymStatistics.swift
//  UpcomingMetalShows
//
//  Created by Kris Rajendren on Oct/12/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import Foundation

typealias GymStatClean = [String : String]

class Gym
{
    static var statistics: GymStat = [:]
    static var occupancyPercentage: GymStatClean = [:]
}
