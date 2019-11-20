//
//  MyMarksTimetableTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 11/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class MyMarksTimetableTVCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
