//
//  TeamSquardViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-08.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

enum SelectedScreen {
    case team
    case squard
}

class Team {
    let img: UIImage?
    let name: String
    
    init(img: UIImage, name: String) {
        self.img = img
        self.name = name
    }
}

class TeamSquardViewController: UIViewController {
    
    let transition = SlideInTransition()

    @IBOutlet weak var btnTeam: UIButton!
    @IBOutlet weak var btnSquard: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var topLabel: UILabel!
    var type = SelectedScreen.team
    
   lazy var teamArray = [
        Team(img: #imageLiteral(resourceName: "bayern"), name: "Bayern Munich"),
        Team(img: #imageLiteral(resourceName: "chelsea"), name: "Chelsea"),
        Team(img: #imageLiteral(resourceName: "barcelona"), name: "Barcelona"),
        Team(img: #imageLiteral(resourceName: "psg"), name: "PSG"),
        Team(img: #imageLiteral(resourceName: "napoli"), name: "Napoli"),
        Team(img: #imageLiteral(resourceName: "manchester city"), name: "Manchester City"),
        Team(img: #imageLiteral(resourceName: "borussia dortmund"), name: "Dortmund"),
        Team(img: #imageLiteral(resourceName: "juventus"), name: "Juventus"),
        Team(img: #imageLiteral(resourceName: "liverpool"), name: "Liverpool"),
        Team(img: #imageLiteral(resourceName: "real madrid"), name: "Real Madrid"),
        Team(img: #imageLiteral(resourceName: "atletico madrid"), name: "Atletico Madrid"),
        Team(img: #imageLiteral(resourceName: "tottenham"), name: "Tottenham"),
        Team(img: #imageLiteral(resourceName: "inter"), name: "Inter"),
        Team(img: #imageLiteral(resourceName: "lyon"), name: "Lyon"),
        Team(img: #imageLiteral(resourceName: "rasenballsport leipzig"), name: "RB Leipzig"),
        Team(img: #imageLiteral(resourceName: "valencia"), name: "Valencia"),
        
    ]
    
    var favroiteTeam = [Int]()
    var selectedTeam: Team?
    var sqardArr: SquadData?
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the navigation Bar
       // self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapeMenu)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        // Do any additional setup after loading the view.
        if let list =  UserDefaults.standard.getFavList() {
            self.favroiteTeam = list
        }
        
         DesignPart()
        }
        
        func DesignPart() {
        backView.layer.cornerRadius = 25
        backView.clipsToBounds = true
        tableView.layer.cornerRadius = 25
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        onClickTeam(self)
    }
    
    @IBAction func btnCheckMark(_ sender: Any) {
    }
    
    @IBAction func onClickTeam(_ sender: Any) {
        topLabel.text = "Team"
        btnTeam.setTitleColor(UIColor.gray, for: .normal)
        btnSquard.setTitleColor(UIColor.white, for: .normal)
        type = .team
        tableView.reloadData()
    }
    
    @IBAction func onClickSquard(_ sender: Any) {
        if selectedTeam?.name != nil {
            sqardArr = nil
        topLabel.text = "Squad"
        btnTeam.setTitleColor(UIColor.white, for: .normal)
        btnSquard.setTitleColor(UIColor.gray, for: .normal)
        type = .squard
        scorerAPI()
        }
        tableView.reloadData()
        
    }
    
    @IBAction func didTapeMenu(_ sender: UIBarButtonItem) {
    
        guard let sideBarMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SideBarMenuViewController") else { return }
        sideBarMenuViewController.modalPresentationStyle = .overCurrentContext
        sideBarMenuViewController.transitioningDelegate = self
        present(sideBarMenuViewController, animated: true)
    }
    
    func scorerAPI() {
        self.view.showLoading()
       
        ResultModel.getAllSquad(teamName: selectedTeam?.name ?? "", success: { (matched) in
                self.view.hideLoading()
                DispatchQueue.main.async {
                    if let catObj = matched {
                        self.sqardArr = catObj
                        self.tableView.reloadData()
                    }
                }
            }, failure:  { (error) in
                self.view.hideLoading()
            })
    }
    
}

extension TeamSquardViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if type != .team {
            guard let header = tableView.dequeueReusableCell(withIdentifier: "squard_header") as? TeamSquardHeaderCell else {
                return UIView()
            }
            header.name.text = selectedTeam?.name
            header.img.image = selectedTeam?.img
            return header
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .team {
            return teamArray.count
        } else {
            return self.sqardArr?.players?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if type == .team {
            guard let tblCell = tableView.dequeueReusableCell(withIdentifier: "team_cell", for: indexPath) as? TeamSquardTableViewCell else {
                return UITableViewCell()
            }
            tblCell.teamName.text = teamArray[indexPath.row].name
            tblCell.teamImage.image = teamArray[indexPath.row].img
            tblCell.clickedIndex = indexPath.row
            
            if self.favroiteTeam.contains(indexPath.row) {
                           tblCell.favButton.setImage(#imageLiteral(resourceName: "full"), for: .normal)
                       } else {
                           tblCell.favButton.setImage(#imageLiteral(resourceName: "onfull"), for: .normal)
                       }
            
            tblCell.passIndexPath = { indexRow in
                    if self.favroiteTeam.contains(indexRow) {
                        if let index = self.favroiteTeam.firstIndex(of: indexRow) {
                            self.favroiteTeam.remove(at: index)
                        }
                    } else {
                        self.favroiteTeam.append(indexRow)
                        
                    }
                    UserDefaults.standard.saveFavrioteList(favList: self.favroiteTeam)
                
                print(self.favroiteTeam)
                self.tableView.reloadData()
            }
            cell = tblCell
        } else {
            guard let tblCell = tableView.dequeueReusableCell(withIdentifier: "squard_cell", for: indexPath) as? TeamSquardTableViewCell else {
                return UITableViewCell()
            }
            tblCell.selectedIndex.text = "\(indexPath.row+1)."
            tblCell.selectedTeamLogo.image = selectedTeam?.img
            tblCell.selectedTeamName.text = sqardArr?.players?[indexPath.row].playerName
            tblCell.positionLbl.text = sqardArr?.players?[indexPath.row].position
            tblCell.ageLbl.text = "\(sqardArr?.players?[indexPath.row].age ?? 18)"

            
            cell = tblCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .team {
            selectedTeam = teamArray[indexPath.row]
            onClickSquard(self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if type == .team {
            return 0
        } else {
            return 50
        }
        
        }
        
}

extension TeamSquardViewController: UIViewControllerTransitioningDelegate {
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed
        dismissed: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            transition.isPresenting = false
            return transition
    }
    
}


