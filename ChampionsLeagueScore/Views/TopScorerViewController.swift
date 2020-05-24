//
//  TopScorerViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-07.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

enum ScreenType {
    case scorer
    case details
    case statistics
}

class TopPlayers {
    let name: String?
    let p: String?
    let a: String?
    let img: UIImage?
    
    init(name: String, p: String, a: String, img: UIImage) {
        self.name = name
        self.p = p
        self.a = a
        self.img = img
    }
}

class TopScorerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnScorer: UIButton!
    @IBOutlet weak var btnDetails: UIButton!
    
    var type = ScreenType.scorer
    var scorerData: ScorerData?
    
    var topPlayers = [TopPlayers]()
    let transition = SlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapeMenu))  // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        type = .scorer
        tableView.layer.cornerRadius = 25
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        addTopPlayers()
        onClickScorer(self)
        scorerAPI()
        
    }
    
    func addTopPlayers() {
        topPlayers = [
        TopPlayers(name: "Robert Lewandowski", p: "FWD", a: "31", img: #imageLiteral(resourceName: "Robert Lewandowski")),
        TopPlayers(name: "Erling Haland", p: "FWD", a: "19", img: #imageLiteral(resourceName: "Erling Haland")),
        TopPlayers(name: "Lionel Messi", p: "RW", a: "32", img: #imageLiteral(resourceName: "Sergio Aguero")),
        TopPlayers(name: "Cristiano Ronaldo", p: "FWD", a: "35", img: #imageLiteral(resourceName: "Cristiano Ronaldo")),
        TopPlayers(name: "Harry Kane", p: "FWD", a: "26", img: #imageLiteral(resourceName: "Harry Kane")),
        TopPlayers(name: "Kylian Mbappe", p: "FWD", a: "21", img: #imageLiteral(resourceName: "Kylian Mbappe")),
        TopPlayers(name: "Virgil van Dijk", p: "CB", a: "28", img: #imageLiteral(resourceName: "Virgil van Dijk")),
        TopPlayers(name: "Sadio Mane", p: "LW", a: "28", img: #imageLiteral(resourceName: "Sadio Mane")),
        TopPlayers(name: "Neymar", p: "LW", a: "28", img: #imageLiteral(resourceName: "Neymar")),
        TopPlayers(name: "Sergio Aguero", p: "FWD", a: "31", img: #imageLiteral(resourceName: "Lionel Messi")),]
    }
    
    @IBAction func onClickScorer(_ sender: Any) {
        btnScorer.setTitleColor(UIColor.gray, for: .normal)
        btnDetails.setTitleColor(UIColor.white, for: .normal)
        type = .scorer
        tableView.reloadData()
    }
    @IBAction func onClickDetails(_ sender: Any) {
        btnScorer.setTitleColor(UIColor.white, for: .normal)
        btnDetails.setTitleColor(UIColor.gray, for: .normal)
        type = .details
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
       
            ResultModel.getAllTopScrorer(success: { (matched) in
                self.view.hideLoading()
                DispatchQueue.main.async {
                    if let catObj = matched {
                        self.scorerData = catObj
                        self.tableView.reloadData()
                    }
                }
            }, failure:  { (error) in
                self.view.hideLoading()
            })
    }
}

extension TopScorerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch type {
        case .scorer:
            return 1
        case .details:
            return 1
        case .statistics:
            print("Stat")
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .scorer:
            print("Details")
            return scorerData?.scorers?.count ?? 0
        case .details:
            print("Scorer")
            return topPlayers.count
        case .statistics:
            print("Stat")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cellHeader = UIView()

        switch type {
        case .details:
            guard let header = tableView.dequeueReusableCell(withIdentifier: "player_details_header") as? TopScorerHeaderTableViewCell else {
                return UIView()
            }
           // header.lblGroup.text = "Group"
            cellHeader = header
        case .scorer:
            guard let header = tableView.dequeueReusableCell(withIdentifier: "topscorer_header") as? TopScorerHeaderTableViewCell else {
                return UIView()
            }
        
            cellHeader = header
        case .statistics:
            guard let header = tableView.dequeueReusableCell(withIdentifier: "match_stat") as? TopScorerHeaderTableViewCell else {
                return UIView()
            }
          
          //  header.lblGroup.text = "Group"
            cellHeader = header
        }
        
        return cellHeader

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch type {
        case .details:
            print("Details")
            guard let tblCell = tableView.dequeueReusableCell(withIdentifier: "player_details", for: indexPath) as? TopScorerCellTableViewCell  else {
                return UITableViewCell()
            }
            tblCell.playerIndex.text = "\(indexPath.row+1)."
            tblCell.playerName.text = topPlayers[indexPath.row].name
            tblCell.playerA.text = topPlayers[indexPath.row].a
            tblCell.playerP.text = topPlayers[indexPath.row].p
            tblCell.playerImg.image = topPlayers[indexPath.row].img
            
            cell = tblCell
        case .scorer:
            guard let tblCell = tableView.dequeueReusableCell(withIdentifier: "topscorer_cell", for: indexPath) as? TopScorerCellTableViewCell  else {
                return UITableViewCell()
            }
            tblCell.topScoreName.text = scorerData?.scorers?[indexPath.row].playerName
            tblCell.topScoreIndex.text = "\(indexPath.row+1)"
            tblCell.topScoreGoals.text = "\(scorerData?.scorers?[indexPath.row].goals ?? 0)"
            tblCell.topScorePen.text = "\(scorerData?.scorers?[indexPath.row].penalties ?? 0)"
            cell = tblCell
        case .statistics:
            guard let tblCell = tableView.dequeueReusableCell(withIdentifier: "stat_cell", for: indexPath) as? TopScorerCellTableViewCell  else {
                return UITableViewCell()
            }
            cell = tblCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch type {
        case .scorer:
            
            return 50
        case .details:
            print("Scorer")
            return 100
        case .statistics:
            print("Stat")
            return 80
        }
    }
}
extension TopScorerViewController: UIViewControllerTransitioningDelegate {
    
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
