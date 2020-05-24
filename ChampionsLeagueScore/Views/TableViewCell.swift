//
//  TableViewCell.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-03-12.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnCheckMark: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
