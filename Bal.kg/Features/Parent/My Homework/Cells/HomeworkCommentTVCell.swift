//
//  HomeworkCommentTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 10/2/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class HomeworkCommentTVCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
