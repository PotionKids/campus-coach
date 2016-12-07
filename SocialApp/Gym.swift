//
//  GymStatistics.swift
//  UpcomingMetalShows
//
//  Created by Kris Rajendren on Oct/12/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import Foundation

class Gym
{
    static var privateAllStats: GymStat = [:]
    static var allStats: GymStat
    {
        return privateAllStats
    }
}
