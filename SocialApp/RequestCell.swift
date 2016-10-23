//
//  RequestCell.swift
//  TableVCPractice
//
//  Created by Kris Rajendren on Oct/23/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var gymSelectButton: UIButton!
    @IBOutlet weak var acceptRequestButton: UIButton!
    @IBOutlet weak var userSelectButton: UIButton!
    
    @IBOutlet weak var gymSelectButtonDescription: UILabel!
    @IBOutlet weak var acceptRequestButtonDescription: UILabel!
    @IBOutlet weak var userSelectButtonDescription: UILabel!
    
    
    @IBAction func gymSelect(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func acceptRequest(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func userSelect(_ sender: AnyObject)
    {
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(request: Request)
    {
        gymSelectButtonDescription.text = request.gymName
        acceptRequestButtonDescription.text = request.action
        userSelectButtonDescription.text = request.user
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
