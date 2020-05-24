//
//  TopScorerCellTableViewCell.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-07.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class TopScorerCellTableViewCell: UITableViewCell {

    @IBOutlet weak var topScoreIndex: UILabel!
    @IBOutlet weak var topScoreImage: UIImageView!
    @IBOutlet weak var topScoreName: UILabel!
    @IBOutlet weak var topScoreGoals: UILabel!
    @IBOutlet weak var topScorePen: UILabel!
    
    
    @IBOutlet weak var playerIndex: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerP: UILabel!
    @IBOutlet weak var playerA: UILabel!
    @IBOutlet weak var playerImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
