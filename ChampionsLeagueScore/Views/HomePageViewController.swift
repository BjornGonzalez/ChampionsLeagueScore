//
//  HomePageViewController.swift
//  ChampionsLeagueaScore
//
//  Created by Björn Gonzalez on 2020-02-14.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    let transition = SlideInTransition()

    @IBOutlet weak var tableView: UITableView!
        
        var matchesResult: ResultModel?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.layer.cornerRadius = 20
            tableView.clipsToBounds = true
            
            
            // URL
    //        let url = URL(string: "https://heisenbug-champions-league-live-scores-v1.p.rapidapi.com/api/championsleague?group=A&matchday=1")
            
            callAPI()
        }
        
        func callAPI() {
            self.view.showLoading()
            ResultModel.getAllMatchResults(group: "A", success: { (matched) in
                // self.view.hideLoading()
                DispatchQueue.main.async {
                    self.view.hideLoading()
                    if let catObj = matched {
                       // self.matchesResult = catObj
                        self.tableView.reloadData()
                    }
                }
                
            }, failure:  { (error) in
                self.view.hideLoading()
            })
        }
    
    
    @IBAction func didTapeMenu(_ sender:UIBarButtonItem) {
        guard let sideBarMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SideBarMenuViewController") else { return }
                sideBarMenuViewController.modalPresentationStyle = .overCurrentContext
        sideBarMenuViewController.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
                present(sideBarMenuViewController, animated: true)
    }
  
    }

    extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return matchesResult?.matches?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableCell(withIdentifier: "header_cell")
            if let dateView = header?.viewWithTag(111) as? UILabel {
                let timeArr = matchesResult?.matches?[section].when?.components(separatedBy: " ")
                if let month = timeArr?[1], let date = timeArr?[2] {
                    dateView.text = month + " " + date
                }
                 //matchesResult?.matches?[section].when
            }
            return header
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "result_cell", for: indexPath) as? ResultCell else {return UITableViewCell()}
            
            if let team1s = matchesResult?.matches?[indexPath.section].team1?.teamScore, let team2s = matchesResult?.matches?[indexPath.section].team2?.teamScore {
                cell.teamScore.text = "\(team1s)" + " - " + "\(team2s)"

            }
            if let team1N = matchesResult?.matches?[indexPath.section].team1?.teamName, let team2N = matchesResult?.matches?[indexPath.section].team2?.teamName {
                cell.team1Name.text = team1N
                cell.team2name.text = team2N

            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 40
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
        
        
        
    }

    class ResultCell: UITableViewCell {
        @IBOutlet weak var teamScore: UILabel!
        @IBOutlet weak var team2name: UILabel!
        @IBOutlet weak var team1Name: UILabel!
        
    }



