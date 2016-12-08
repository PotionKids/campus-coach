//
//  RequestCell.swift
//  TableVCPractice
//
//  Created by Kris Rajendren on Oct/23/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell
{
    @IBOutlet weak var gymIcon: UIImageView!
    @IBOutlet weak var acceptRequestButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var gymBldg: UILabel!
    @IBOutlet weak var acceptRequestButtonDescription: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func acceptRequest(_ sender: AnyObject)
    {
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(request: Request)
    {
        gymBldg.text = request.created.forGym
        acceptRequestButtonDescription.text = Constants.DataService.Request.Accept
        userName.text = request.created.student.firstName
        
        let urlstr = request.created.student.facebookImageURLString
        
        if let urlstring = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        {
            if let url = URL(string: urlstring)
            {
                do
                {
                    let data                = try Data(contentsOf: url)
                    let image               = UIImage(data: data)
                    userImage.contentMode   = .scaleAspectFit
                    userImage.clipsToBounds = true
                    userImage.image         = image
                }
                catch Errors.DataRetrival
                {
                    print(Errors.DataRetrival.message)
                }
                catch let error
                {
                    fatalError("\(error)")
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
