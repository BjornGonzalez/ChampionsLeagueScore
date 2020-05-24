//
//  LoginViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-02-17.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import FirebaseAuth
import FBSDKShareKit

class LoginViewController: UIViewController   {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var googleLoginBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        self.navigationController?.navigationBar.isHidden = true
        
        setUpElements()

    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleFilledButton(loginBtn)
        
        loginBtn.layer.cornerRadius = 25
        loginBtn.layer.shadowColor = UIColor.white.cgColor
        loginBtn.layer.shadowOpacity = 1
        loginBtn.layer.shadowOffset = CGSize.zero
        loginBtn.layer.shadowRadius = 4
        loginBtn.clipsToBounds = true
        
        btnSkip.layer.cornerRadius = 25
        btnSkip.layer.shadowColor = UIColor.white.cgColor
        btnSkip.layer.shadowOpacity = 1
        btnSkip.layer.shadowOffset = CGSize.zero
        btnSkip.layer.shadowRadius = 4
        btnSkip.clipsToBounds = true

        
        
        emailTextField.addLeftView()
        userPasswordTextField.addLeftView()
        
    }
    @IBAction func forgotPassword(_ sender: Any) {
     
    }
    
    @IBAction func googleLoginBtnAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButton(_ sender: Any) {
        fbLogin()
    }
    
    func fbLogin () {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions:[ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            
            switch loginResult {
                
            case .failed(let error):
                //HUD.hide()
                print(error)
                
            case .cancelled:
                //HUD.hide()
                print("User cancelled login.")
                
            case .success( _, _, _):
                print("Logged in!")
                self.getFBUserData()
                
                self.moveOnHomeScreen() // This call should be done when use successfuly login into the system.
                
            }
        }
        
    }
    
    func  getFBUserData() {
        //which if my function to get facebook user details
        
        if((AccessToken.current) != nil) {
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: {
                (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    print (result!)
                    print(dict)
                    let picutreDic = dict as NSDictionary
                    let tmpURL1 = picutreDic.object(forKey: "picture") as! NSDictionary
                    let tmpURL2 = tmpURL1.object(forKey: "data") as! NSDictionary
                    _ = tmpURL2.object(forKey: "url") as! String
                    
                    let nameOfUser = picutreDic.object(forKey: "name") as! String
                    self.emailTextField.text = nameOfUser
                    
                    var tmpEmailAdd = ""
                    if let emailAdress = picutreDic.object(forKey: "email") {
                        tmpEmailAdd = emailAdress as! String
                        self.userPasswordTextField.text = tmpEmailAdd
                        
                    }
                    else {
                        var usrName = nameOfUser
                        usrName = usrName.replacingOccurrences(of: " ", with: " ")
                        tmpEmailAdd = usrName+"@facebook.com"
                    }
                }
            })
            
        }
        
        
    }
    
    
    // All the things which is related to the twitter login in below.
    @IBAction func twitterButton(_ sender: Any) {
   
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if (session != nil) {
                _ = session?.userName ?? ""   // received first name
                _ = session?.userName ?? ""
                let client = TWTRAPIClient.withCurrentUser()
                UserDefaults.standard.saveIDToken(userID: session?.userID)
                self.moveOnHomeScreen()
                client.requestEmail { email, error in
                    if (email != nil) {
                        print("signed in as \(String(describing: session?.userName))");
                        _ = session?.userName ?? ""   // received first name
                        _ = session?.userName ?? ""  // received last name
                        _ = email ?? ""   // received email
                        
                        
                    }else {
                        print("error: \(String(describing: error?.localizedDescription))");
                    }
                }
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    // If user previously logged into the system then directly move onto the home page.
    func moveOnHomeScreen() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "TableResultMatchesViewController") as! TableResultMatchesViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        login()
    }
    
    func login() {
        // TODO: Validate Text Fields

        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = userPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            print("user authenticated")

            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                //let defaults = UserDefaults.standard
                
               // if defaults.bool(forKey: "isUserSignIn") {
                guard let homePageViewController = self.storyboard?.instantiateViewController(identifier: "TableResultMatchesViewController") as? TableResultMatchesViewController else {
                    return
                }
                let navVC = UINavigationController(rootViewController: homePageViewController)
                navVC.navigationBar.isTranslucent = true
                navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navVC.navigationBar.shadowImage = UIImage()
                navVC.view.backgroundColor = .clear
                
                self.view.window?.rootViewController = navVC
                self.view.window?.makeKeyAndVisible()
            }



        }
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let registerVC = self.storyboard?.instantiateViewController(identifier: "RegisterUserViewController") as? RegisterUserViewController else {
            return
        }
        
        self.present(registerVC, animated: true, completion: nil)
        
    }
    
    @IBAction func skipButton(_ sender: Any) {
        guard let homePageViewController = self.storyboard?.instantiateViewController(identifier: "TableResultMatchesViewController") as? TableResultMatchesViewController else {
            return
        }
        let navVC = UINavigationController(rootViewController: homePageViewController)
        navVC.navigationBar.isTranslucent = true
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.shadowImage = UIImage()
        navVC.view.backgroundColor = .clear
        
        self.view.window?.rootViewController = navVC
        self.view.window?.makeKeyAndVisible()
    
    }
    
}



