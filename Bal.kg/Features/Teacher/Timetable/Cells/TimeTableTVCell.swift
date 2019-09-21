//
//  TimeTableTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class TimeTableTVCell: UITableViewCell {

    @IBOutlet weak var timeLesson: UILabel!
    
    @IBOutlet weak var nameLesson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
