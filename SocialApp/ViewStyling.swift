
//  ViewStyling.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/25/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    @IBInspectable var cornerRadius: CGFloat
    {
        get
        {
            return layer.cornerRadius
        }
        set
        {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
