//
//  TableResultMatchesViewController.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-16
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//
import UIKit

enum SelectionType {
    case table
    case result
    case matches
}

class TableResultMatchesViewController: UIViewController {
    
    let transition = SlideInTransition()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblButton: UIButton!
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var matchBtn: UIButton!
    
    var type = SelectionType.table
    
    let groups = ["A", "B", "C", "D", "E", "F", "G", "H"]
    let resultsGroup =  ["A", "B", "C", "D", "E", "F", "G", "H"]
    var resultModal: [[String: RecordsData]]?
    
    var matchesResult: [[String: ResultModel]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onClickTbl(self)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        
        tableView.layer.cornerRadius = 25
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        tableAPI()
        
    }
    
    func tableAPI() {
        var results = [[String: RecordsData]]()
        let dispatchGroup = DispatchGroup()
        self.view.showLoading()
        for (index, group) in groups.enumerated() {
            dispatchGroup.enter()
            ResultModel.getAllMatchTable(group: group, success: { (matched) in
                DispatchQueue.main.async {
                    // self.view.hideLoading()
                    print("API resonse index of \(index)")
                    if let catObj = matched {
                        var a = [String: RecordsData]()
                        a[group] = catObj
                        results.append(a)
                    }
                }
                dispatchGroup.leave()
            }, failure:  { (error) in
                self.view.hideLoading()
                dispatchGroup.leave()
            })
            
        }
        
        dispatchGroup.notify(queue: .main) {
            
            self.resultModal = results.sorted { (kf, ks) -> Bool in
                kf.first!.key < ks.first!.key
            }
            
            self.tableView.reloadData()
            self.view.hideLoading()
        }
        
    }
    
    func resultAPI() {
        if self.matchesResult != nil {
            self.tableView.reloadData()
            return
        }
        var results = [[String: ResultModel]]()
        
        let dispatchGroup = DispatchGroup()
        self.view.showLoading()
        for (index, group) in resultsGroup.enumerated() {
            dispatchGroup.enter()
            ResultModel.getAllMatchResults(group: group, success: { (matched) in
                DispatchQueue.main.async {
                    // self.view.hideLoading()
                    print("API resonse index of \(index)")
                    if let catObj = matched {
                        var a = [String: ResultModel]()
                        a[group] = catObj
                        results.append(a)
                    }
                }
                dispatchGroup.leave()
            }, failure:  { (error) in
                self.view.hideLoading()
                dispatchGroup.leave()
            })
            
        }
        
        dispatchGroup.notify(queue: .main) {
            
            self.matchesResult = results.sorted { (kf, ks) -> Bool in
                kf.first!.key < ks.first!.key
            }
            
            self.tableView.reloadData()
            self.view.hideLoading()
        }
    }
    
    
    @IBAction func onClickTbl(_ sender: Any) {
        tblButton.setTitleColor(UIColor.gray, for: .normal)
        resultBtn.setTitleColor(UIColor.white, for: .normal)
        matchBtn.setTitleColor(UIColor.white, for: .normal)
        type = .table
        tableView.reloadData()
        
    }
    @IBAction func onClickResult(_ sender: Any) {
        tblButton.setTitleColor(UIColor.white, for: .normal)
        resultBtn.setTitleColor(UIColor.gray, for: .normal)
        matchBtn.setTitleColor(UIColor.white, for: .normal)
        type = .result
        resultAPI()
        //tableView.reloadData()
    }
    @IBAction func onClickMatches(_ sender: Any) {
        tblButton.setTitleColor(UIColor.white, for: .normal)
        resultBtn.setTitleColor(UIColor.white, for: .normal)
        matchBtn.setTitleColor(UIColor.gray, for: .normal)
        type = .matches
        tableView.reloadData()
    }
    
    @IBAction func didTapeMenu(_ sender: Any) {
        
        guard let sideBarMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SideBarMenuViewController") else { return }
        sideBarMenuViewController.modalPresentationStyle = .overCurrentContext
        sideBarMenuViewController.transitioningDelegate = self
        present(sideBarMenuViewController, animated: true)
    }
}

extension TableResultMatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == . table {
            tableView.layer.cornerRadius = 25
            tableView.clipsToBounds = true
            return resultModal?[section].first?.value.records?.count ?? 0
        }else if type == .result {
            tableView.layer.cornerRadius = 25
            tableView.clipsToBounds = true
            return matchesResult?[section].first?.value.matches?.count ?? 0
        } else {
            tableView.layer.cornerRadius = 25
            tableView.clipsToBounds = true
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if type == . table {
            return resultModal?.count ?? 0
        }else if type == .result {
            return matchesResult?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cellHeader = UIView()
        if type == .table {
            guard let header = tableView.dequeueReusableCell(withIdentifier: "section_header") as? SectionTableViewCell else {
                return UIView()
            }
            header.backView.clipsToBounds = true
            header.backView.layer.cornerRadius = 25
            header.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            header.lblGroup.text = "Group \(groups[section])"
            cellHeader = header
        }
        
        if type == .result {
            guard let header = tableView.dequeueReusableCell(withIdentifier: "header_matches") as? SectionTableViewCell else {
                return UIView()
            }
            //            let timeArr = matchesResult?[section].first?.value.matches?[section.].when?.components(separatedBy: " ")
            //            if let month = timeArr?[1], let date = timeArr?[2] {
            //                header.matchDate.text = month + " " + date
            //            }
            header.matchDate.text = "Group \(groups[section])"
            cellHeader = header
            
        }
        
        return cellHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if type == .table {
            guard let cellTbl = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableTableViewCell else {return UITableViewCell()}
            if indexPath.row == 3 {
                cell.contentView.clipsToBounds = true
                cell.contentView.layer.cornerRadius = 25
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            cellTbl.recordIndex.text = "\(indexPath.row+1)."
            cellTbl.teamName.text = resultModal?[indexPath.section].first?.value.records?[indexPath.row].team
            cellTbl.mp.text = "\(resultModal?[indexPath.section].first?.value.records?[indexPath.row].played ?? 0)"
            cellTbl.p.text = "\(resultModal?[indexPath.section].first?.value.records?[indexPath.row].points ?? 0)"
            cellTbl.g.text = "\(resultModal?[indexPath.section].first?.value.records?[indexPath.row].goalsFor ?? 0)" + ":" + "\(resultModal?[indexPath.section].first?.value.records?[indexPath.row].goalsAgainst ?? 0)"
            let img = UIImage(named: resultModal?[indexPath.section].first?.value.records?[indexPath.row].team?.lowercased() ?? "cll")
            cellTbl.img.image = img == nil ? UIImage(named:  "cll") : img
            cell = cellTbl
        }
        if type == .result {
            guard let cellTbl = tableView.dequeueReusableCell(withIdentifier: "matchescell", for: indexPath) as? ResultCell else {return UITableViewCell()}
            if let team1s = matchesResult?[indexPath.section].first?.value.matches?[indexPath.row].team1?.teamScore, let team2s = matchesResult?[indexPath.section].first?.value.matches?[indexPath.row].team2?.teamScore {
                cellTbl.teamScore.text = "\(team1s)" + " - " + "\(team2s)"
                
            }
            if let team1N = matchesResult?[indexPath.section].first?.value.matches?[indexPath.row].team1?.teamName, let team2N = matchesResult?[indexPath.section].first?.value.matches?[indexPath.row].team2?.teamName {
                cellTbl.team1Name.text = team1N
                cellTbl.team2name.text = team2N
                
            }
            tableView.layer.cornerRadius = 25
            tableView.clipsToBounds = true
            cell = cellTbl
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension TableResultMatchesViewController: UIViewControllerTransitioningDelegate {
    
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
