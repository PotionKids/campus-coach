//
//  Coach.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/22/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

class Coach: User, ReviewerArchivable
{
    required init()
    {
        super.init()
        self.privateIsCoach = YesOrNo.Yes.string
    }
    var keys: KeysType
    {
        return Constants.Protocols.CoachType.keys
    }
}
