//
//  SaveCellVC.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/13/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit
import Firebase

class SaveCellVC: UIViewController, UITextFieldDelegate
{
    var user: User!
    
    @IBOutlet weak var cellNumberTextField: UITextField!
    {
        didSet
        {
            cellNumberTextField.delegate = self
        }
    }
    
    @IBAction func save(_ sender: Any)
    {
        if let cell = cellNumberTextField.text
        {
            if cell.isEmpty
            {
                displayAlert(self, title: Constants.Alert.Title.EmptyCellNumber, message: Constants.Alert.Message.EmptyCellNumber)
            }
            else
            {
                Persistence.shared.privateUser!.privateCell = cell
                let _ = Persistence.shared.saveUser()
                print("KRIS: Cell Number is saved as \n\n KRIS: \(Persistence.shared.user!.cell)")
            }
        }
        registerSignUp()
        performSignUpSegue(fromViewController: self, forUserWhoIsACoach: Persistence.shared.isCoach, sender: Persistence.shared.user)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
