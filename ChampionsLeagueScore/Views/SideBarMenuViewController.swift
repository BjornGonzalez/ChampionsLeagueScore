//
//  SideBarMenuViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-02-25.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn


enum MenuType: Int {
    case profile
    case table
    case team
    case stats
    case settings
    case logout
}

class SideBarMenuViewController: UITableViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.userName.text = Auth.auth().currentUser?.email
        } else {
            self.userName.text = "Login"
        }
       
           
       }
           

    @IBAction func HomeBtn(_ sender: Any) {
        guard let homePageViewController = storyboard?.instantiateViewController(identifier: "TableResultMatchesViewController") as? TableResultMatchesViewController else {return}
        let navVC = UINavigationController(rootViewController: homePageViewController)
        navVC.navigationBar.isTranslucent = true
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.shadowImage = UIImage()
        navVC.view.backgroundColor = .clear
        view.window?.rootViewController = navVC
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func FavoriteBtn(_ sender: Any) {
        guard let homePageViewController = storyboard?.instantiateViewController(identifier: "TeamSquardViewController") as? TeamSquardViewController else {return}
        let navVC = UINavigationController(rootViewController: homePageViewController)
        navVC.navigationBar.isTranslucent = true
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.shadowImage = UIImage()
        navVC.view.backgroundColor = .clear
        view.window?.rootViewController = navVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func MatchesBtn(_ sender: Any) {
        guard let homePageViewController = storyboard?.instantiateViewController(identifier: "TopScorerViewController") as? TopScorerViewController else {return}
        let navVC = UINavigationController(rootViewController: homePageViewController)
        navVC.navigationBar.isTranslucent = true
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.shadowImage = UIImage()
        navVC.view.backgroundColor = .clear
        view.window?.rootViewController = navVC
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func SettingsBtn(_ sender: Any) {
        guard let homePageViewController = storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else {return}
        let navVC = UINavigationController(rootViewController: homePageViewController)
        navVC.navigationBar.isTranslucent = true
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.shadowImage = UIImage()
        navVC.view.backgroundColor = .clear
        view.window?.rootViewController = navVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func LogoutBtn(_ sender: Any) {
        signOut()
    
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "nav_controller")
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        } catch let error {
            print("Failed to sign out with error", error)
        }
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
    
}
