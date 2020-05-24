//
//  RegisterUserViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-02-27.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
  
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!

    @IBOutlet weak var signUpD: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpElements()
        
    }
    
    func setUpElements() {
        
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleFilledButton(signUpD)
        
        emailTextField.addLeftView()
        userNameTextField.addLeftView()
        userPasswordTextField.addLeftView()
        
        
    }
    
    // Check the field and validate that the data is correct. If everything is correct, this metod returns nil. Otherwise, it returns the error message
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = userPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
            
        }
        else {
            
            // Create cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = userPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                   //--self.fetchUser()
                // Check for errors
                if err != nil {
                    print(error!)
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the email and username
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["username":username, "email":email, "pic": "", "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                            
                        }
                        
        
                    }
                    
                    // Transition to the home screen
                    self.transitionToHome()
                }
                
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        guard let homePageViewController = storyboard?.instantiateViewController(identifier: "TableResultMatchesViewController") as? TableResultMatchesViewController else {return}
        let navVC = UINavigationController(rootViewController: homePageViewController)
        navVC.navigationBar.isTranslucent = true
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.shadowImage = UIImage()
        navVC.view.backgroundColor = .clear
        view.window?.rootViewController = navVC
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func LoginPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
      
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: userPasswordTextField.text!) {
            (authResult, error) in
            guard let _ = authResult?.user, error == nil else {
                print("Error \(error!.localizedDescription)")
                return
            }
        }
    }
    

}
