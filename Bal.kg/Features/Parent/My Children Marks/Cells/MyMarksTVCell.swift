//
//  MyMarksTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class MyMarksTVCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var comment: UILabel!
   
    @IBOutlet weak var partOutlet: UILabel!
   
    @IBOutlet weak var partLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
