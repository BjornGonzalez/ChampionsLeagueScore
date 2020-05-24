//
//  ResetPasswordViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-20.
//  Copyright © 2020 Björn Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var emailV: UIButton!
    
    @IBOutlet weak var cancelbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
            
        }
        
        func setUpElements() {
            
            // Style the elements
            Utilities.styleFilledButton(emailV)
            Utilities.styleFilledButton(cancelbtn)
            
            EmailTextField.addLeftView()
        
            
    }
    @IBAction func SendEmail(_ sender: Any) {
        sendEmail()
    }
    
    func sendEmail() {
        if self.EmailTextField.text == "" {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            
            } else {
                Auth.auth().sendPasswordReset(withEmail: self.EmailTextField.text!, completion: { (error) in
                    
                    var title = ""
                    var message = ""
                    
                    if error != nil {
                        title = "Error!"
                        message = (error?.localizedDescription)!
                    } else {
                        title = "Success!"
                        message = "Password reset email sent."
                        self.EmailTextField.text = ""
                    }
                    
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }
    @IBAction func CancelBtn(_ sender: Any) {
     
    }
}

