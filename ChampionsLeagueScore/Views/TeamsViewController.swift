//
//  TeamsViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-03.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController {

 let transition = SlideInTransition()

        
        @IBOutlet weak var SearchBarNew: UISearchBar!
        
        @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
        
        @IBOutlet weak var searchTableView: UITableView!
        
        let nameArray = [
                   "FC Barcelona",
                   "Real Madrid",
                   "Atletico Madrid",
                   "Manchester City",
                   "Manchester United",
               ]
                   
            var filteredArray : [String] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()

             searchTableView.isHidden = true
                    
                    filteredArray = nameArray
        
         DesignPart()
        }
        
        func DesignPart() {
            SearchBarNew.layer.cornerRadius = 20
            SearchBarNew.layer.borderWidth = 0.7
            SearchBarNew.clipsToBounds = true
            
        }
        
        
        @IBAction func CancelButtonTapped(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
        
     

            }


            extension TeamsViewController: UIViewControllerTransitioningDelegate {
                func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                    transition.isPresenting = true
                    return transition
                }
                
                func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                    transition.isPresenting = false
                    return transition
                    
                }
                
    }
        
            // extension TeamsViewController : UISearchBarDelegate {
               //  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
                 //    tableViewTopConstraint.constant = 0
                  //   UIView.animate(withDuration: 0.3) {
                    //     self.view.layoutIfNeeded()
                    // }
                   //  searchTableView.isHidden = false
                // }
                
               //  func searchBar(_ searchBar:  UISearchBar, textDidChange searchText: String) {
                   //  filteredArray = nameArray
                    
                  //   if searchText.isEmpty == false {
                   //  filteredArray = nameArray.filter({ $0.contains(searchText) })
                    
                // }
                
                 //searchTableView.reloadData()
                
            // }
            
        // }

            // extension TeamsViewController : UITableViewDataSource, UITableViewDelegate {
               //  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                 //    return filteredArray.count
                    
              //  }
                
                // func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                  //   let cell = tableView.dequeueReusableCell(withIdentifier: "arrayCell", for: indexPath)
                  //   cell.textLabel?.text = filteredArray[indexPath.row]
                  //   return cell
               //  }
 
        // }
        
