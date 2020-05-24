//
//  TableTableViewCell.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-05-06.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit

class TableTableViewCell: UITableViewCell {

    @IBOutlet weak var recordIndex: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var mp: UILabel!
    @IBOutlet weak var g: UILabel!
    @IBOutlet weak var p: UILabel!
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var teams: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
