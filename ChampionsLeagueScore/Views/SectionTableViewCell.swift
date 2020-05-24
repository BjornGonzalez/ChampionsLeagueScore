//
//  SectionTableViewCell.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-06.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblGroup: UILabel!
    
    @IBOutlet weak var round: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var matchDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
