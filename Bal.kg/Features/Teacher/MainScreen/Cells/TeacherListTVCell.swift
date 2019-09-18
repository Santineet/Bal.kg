//
//  TeacherListTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/18/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class TeacherListTVCell: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        dropShadow(label: listLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func dropShadow(label: UILabel) {
        label.layer.masksToBounds = false
        label.layer.shadowColor = UIColor(displayP3Red: 0.0, green: 0.64, blue: 1.0, alpha: 0.1).cgColor
        label.layer.shadowOpacity = 0.9
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 8
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }

    
    

}
