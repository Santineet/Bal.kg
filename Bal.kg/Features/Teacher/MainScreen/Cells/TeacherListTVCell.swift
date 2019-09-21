//
//  TeacherListTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/18/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class TeacherListTVCell: UITableViewCell {

    @IBOutlet weak var classesList: UIButton!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        dropShadow(button: classesList)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func dropShadow(button: UIButton) {
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 8
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        button.showsTouchWhenHighlighted = false
    }

    

}
