//
//  CoachServiceVC.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/10/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import Alamofire

class CoachServiceVC: UIViewController, MFMessageComposeViewControllerDelegate
{

    private var startingVC      = ViewController.CoachService
    //MARK: Outlets
    
    var gymChoiceSelected:  Int = 0
    var gymBldg:            String!
    var studentName:        String!
    var studentImageURL:    String!
    var studentCell:        String!
    
    @IBOutlet weak var gymFirstChoiceLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceLabel: UILabel!
    
    @IBOutlet weak var gymFirstChoiceOccupancyLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceOccupancyLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceOccupancyLabel: UILabel!
    
    @IBOutlet weak var gymFirstChoiceHoursLabel: UILabel!
    @IBOutlet weak var gymSecondChoiceHoursLabel: UILabel!
    @IBOutlet weak var gymThirdChoiceHoursLabel: UILabel!
    
    @IBAction func gymFirstChoiceSelected(_ sender: AnyObject)
    {
        if gymChoiceSelected != 1
        {
            gymChoiceSelected = 1
        }
    }
    
    @IBAction func gymSecondChoiceSelected(_ sender: AnyObject)
    {
        if gymChoiceSelected != 2
        {
            gymChoiceSelected = 2
        }
    }
    
    @IBAction func gymThirdChoiceSelected(_ sender: AnyObject)
    {
        if gymChoiceSelected != 3
        {
            gymChoiceSelected = 3
        }
    }
    
    @IBOutlet weak var gym:                 UILabel!
    @IBOutlet weak var clock:               UILabel!
    @IBOutlet weak var signOutLabel:        UILabel!
    
    @IBOutlet weak var clockPressButton:    UIButton!
    @IBOutlet weak var signOutButton:       UIButton!
    
    @IBOutlet weak var userName:            UILabel!
    @IBOutlet weak var userImage:           CustomImageView!
    
    @IBAction func call(_ sender: Any)
    {
        callNumber(phoneNumber: studentCell)
    }
    
    @IBAction func text(_ sender: Any)
    {
        sendText(phoneNumber: studentCell)
    }
    
    @IBAction func start(_ sender: Any)
    {
    
    }
    
    @IBAction func stop(_ sender: Any)
    {
    
    }
    
    @IBAction func clockPress(_ sender: Any)
    {
        self.clockPressButton   .isHidden = true
        self.clock              .isHidden = true
        self.signOutButton      .isHidden = false
        self.signOutLabel       .isHidden = false
    }
    
    
    @IBAction func signOut(_ sender: Any)
    {
        signOutOf(vc: self, viewController: startingVC)
    }
    
    
    func callNumber(phoneNumber:String)
    {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL as URL)) {
                application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func sendText(phoneNumber: String)
    {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func CURLscrapeWebPage(link: String) {
        let CURLscraping = ConstantsDictionary[Constants.Mirror.Key.CURLscraping]!
        let headers = CURLscraping[Constants.Mirror.CURLscraping.Key.HeadersPSUFitness]!
        
        Alamofire.request(link, headers: headers).responseJSON { [weak weakSelf = self] (response) in
            DispatchQueue.main.async {
                let string = "\(response)"
                Gym.privateAllStats = stringParser(string: string)
                
                let whiteBldgStats = Gym.allStats[Constants.Gym.Name.WhiteBldg]!
                let whiteBldgOccupancy = Int(whiteBldgStats[Constants.Gym.Parsing.CurrentVal]!)
                let whiteBldgCapacity = Int(whiteBldgStats[Constants.Gym.Parsing.MaxVal]!)
                let whiteBldgOccupancyPercentage = Int(whiteBldgOccupancy! * 100 / whiteBldgCapacity!)
                
                let recHallStats = Gym.allStats[Constants.Gym.Name.RecHall]!
                let recHallOccupancy = Int(recHallStats[Constants.Gym.Parsing.CurrentVal]!)
                let recHallCapacity = Int(recHallStats[Constants.Gym.Parsing.MaxVal]!)
                let recHallOccupancyPercentage = Int(recHallOccupancy! * 100 / recHallCapacity!)
                
                let imBldgStats = Gym.allStats[Constants.Gym.Name.IMBldg]!
                let imBldgOccupancy = Int(imBldgStats[Constants.Gym.Parsing.CurrentVal]!)
                let imBldgCapacity = Int(imBldgStats[Constants.Gym.Parsing.MaxVal]!)
                let imBldgOccupancyPercentage = Int(imBldgOccupancy! * 100 / imBldgCapacity!)
                
                var gymStatisticsDisplay: [(name: String, occupancy: Int)] = [
                    (Constants.Gym.Name.WhiteBldg, whiteBldgOccupancyPercentage),
                    (Constants.Gym.Name.RecHall, recHallOccupancyPercentage),
                    (Constants.Gym.Name.IMBldg, imBldgOccupancyPercentage)
                ]
                
                gymStatisticsDisplay = gymStatisticsDisplay.sorted(by: { (first, second) -> Bool in
                    first.occupancy <= second.occupancy
                })
                
                print("KRIS: GYM STATISTICS DISPLAY = \(gymStatisticsDisplay)")
                
                print("KRIS: White Building Occupancy = \(whiteBldgOccupancy)")
                
                weakSelf?.gymFirstChoiceLabel.text = "\(gymStatisticsDisplay[0].name)"
                weakSelf?.gymSecondChoiceLabel.text = "\(gymStatisticsDisplay[1].name)"
                weakSelf?.gymThirdChoiceLabel.text = "\(gymStatisticsDisplay[2].name)"
                
                weakSelf?.gymFirstChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[0].occupancy) %"
                weakSelf?.gymSecondChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[1].occupancy) %"
                weakSelf?.gymThirdChoiceOccupancyLabel.text = "\(gymStatisticsDisplay[2].occupancy) %"
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        CURLscrapeWebPage(link: Constants.Web.Link.PSUfitnessCURLscraping)
        // Do any additional setup after loading the view.
        gym.text            = gymBldg
        userName.text       = studentName
        if let urlstring    = studentImageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        {
            if let url = URL(string: urlstring)
            {
                do
                {
                    let data                = try Data(contentsOf: url)
                    let image               = UIImage(data: data)
                    userImage.contentMode = .scaleAspectFit
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
