//
//  TeamSquardTableViewCell.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-08.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class TeamSquardTableViewCell: UITableViewCell {

    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var selectedTeamName: UILabel!
    @IBOutlet weak var selectedTeamLogo: UIImageView!
    @IBOutlet weak var selectedIndex: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    
    var clickedIndex = Int()
    var passIndexPath: ((_ indexpath: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onClickStart(_ sender: Any) {
      
        passIndexPath?(clickedIndex)
        
    }
}

class TeamSquardHeaderCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
