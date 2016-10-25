//
//  Errors.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/25/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation

enum Errors: Error
{
    case DataRetrival
    
    var message: String
    {
        switch self
        {
            case .DataRetrival:
                return Constants.Error.Message.DataRetrieval
        }
    }
}
