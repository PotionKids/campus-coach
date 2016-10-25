//
//  CustomTableView.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/25/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTableView: UITableView {

    @IBInspectable var backgroundImage: UIImage?
        {
        didSet
        {
            if let image = backgroundImage
            {
                let backgroundImage = UIImageView(image: image)
                backgroundImage.contentMode = .scaleToFill
                backgroundImage.clipsToBounds = false
                self.backgroundView = backgroundImage
            }
        }
    }

}
