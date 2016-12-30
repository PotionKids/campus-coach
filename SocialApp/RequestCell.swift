//
//  RequestCell.swift
//  TableVCPractice
//
//  Created by Kris Rajendren on Oct/23/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RequestCell: UITableViewCell
{
    private var request: Request!
    private var studentRef: FIRDatabaseReference!
    private var _studentRefHandle: FIRDatabaseHandle!
    
    @IBOutlet weak var gymIcon: UIImageView!
    @IBOutlet weak var acceptRequestButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var gymBldg: UILabel!
    @IBOutlet weak var acceptRequestButtonDescription: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func acceptRequest(_ sender: AnyObject)
    {
        studentRef          = Persistence.shared.studentRef!
        _studentRefHandle   = studentRef.observe(.value, with:
        {(snapshot) in
            print("KRIS: Snap \(snapshot)")
            print("KRIS: Default selfStudent \(Persistence.shared.student?.stringDictionary)")
            if let data = snapshot.value as? AnyDictionary
            {
                Persistence.shared.privateStudent = Student(fromUserData: data)!
                let _ = Persistence.shared.saveStudent()
                print("KRIS: Accepted Request Created by Student \(Persistence.shared.student?.stringDictionary))")
            }
        })
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(request: Request)
    {
        self.request                        = request
        gymBldg.text                        = request.created.forGym
        acceptRequestButtonDescription.text = Constants.DataService.Request.Accept.capitalized
        userName.text                       = request.created.firstName
        
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
    
    deinit
    {
        studentRef.removeObserver(withHandle: _studentRefHandle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
