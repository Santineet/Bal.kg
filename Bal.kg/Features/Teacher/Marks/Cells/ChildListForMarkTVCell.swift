//
//  ChildListForMarkTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/23/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class ChildListForMarkTVCell: UITableViewCell {

    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dropShadow(button: markButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dropShadow(button: UIButton) {
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 8
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        button.showsTouchWhenHighlighted = false
    }
    

}
