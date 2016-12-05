//
//  GymStatistics.swift
//  UpcomingMetalShows
//
//  Created by Kris Rajendren on Oct/12/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import Foundation

typealias GymStat       = [String : [String : String]]
typealias GymStatClean  = [String : String]
typealias Time          = Date

enum Building: String
{
    case White
    case Rec
    case IM
    
    var name: String
    {
        switch self
        {
            case .White:
                return Constants.Gym.Name.WhiteBldg
            case .Rec:
                return Constants.Gym.Name.RecHall
            case .IM:
                return Constants.Gym.Name.IMBldg
        }
    }
    
    var location: CLLocation
    {
        switch self
        {
        case .White:
            return Constants.Gym.Location.WhiteBldg
        case .Rec:
            return Constants.Gym.Location.RecHall
        case .IM:
            return Constants.Gym.Location.IMBldg
        }
    }
}

protocol GymType: Dictionarizable
{
    static var privateAllStats:     GymStat!        { get set }
    static var privateAllOccupancy: GymStatClean!   { get set }

    static var allStats:            GymStat         { get }
    static var allOccupancy:        GymStatClean    { get }

    
    var privateName:                String!         { get set }
    
    var name:                       String          { get }
    var building:                   Building        { get }
    var statistics:                 GymStatClean    { get }
    var capacity:                   Int             { get }
    var occupancy:                  Int             { get }
    var occupancyPercentage:        Percentage      { get }
    var waitingTime:                String          { get }
    var waitingTimeInterval:        TimeInterval    { get }
    var location:                   CLLocation      { get }
    
    init()
}
extension GymType
{
    init(withNameOf gym: String)
    {
        self.init()
        self.privateName    = gym
    }
    static var allStats:            GymStat
    {
        return privateAllStats
    }
    static var allOccupancy:        GymStatClean
    {
        return privateAllOccupancy
    }
    
    var name:                       String
    {
        return privateName
    }
    var building:                   Building
    {
        return Building(rawValue: name)!
    }
    var statistics:                 GymStatClean
    {
        return Self.allStats[name]!
    }
    var capacity:                   Int
    {
        return Int(statistics[Constants.Gym.Statistic.MaxVal]!)!
    }
    var occupancy:                  Int
    {
        return Int(statistics[Constants.Gym.Statistic.CurrentVal]!)!
    }
    var occupancyPercentage:        Percentage
    {
        return (occupancy.double * 100.00 / capacity.double)
    }
    var waitingTime:                String
    {
        return statistics[Constants.Gym.Statistic.FullCapacityWaiTime]!
    }
    var waitingTimeInterval:        TimeInterval
    {
        return (waitingTime.double! * 60.00)
    }
    var location:                   CLLocation
    {
        return building.location
    }
}

class Gym: GymType, Dictionarizable
{
    static var privateAllStats:     GymStat!        = GymStat()
    static var privateAllOccupancy: GymStatClean!   = GymStatClean()
    var privateName:                String!
    
    required init()
    {
        self.privateName    = Building.White.name
    }
}






