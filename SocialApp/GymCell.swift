//
//  GymCell.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/8/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

class GymCell: UITableViewCell
{
    @IBOutlet weak var gymIcon: UIImageView!
    @IBOutlet weak var acceptRequestButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var gymBldg: UILabel!
    @IBOutlet weak var acceptRequestButtonDescription: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var gymSelected: String!
    @IBAction func selectRequest(_ sender: AnyObject)
    {
        gymSelected = gymBldg.text!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(gym: Gym)
    {
        gymBldg.text = gym.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
