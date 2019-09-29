//
//  ChildInfoTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/29/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class ChildInfoTVCell: UITableViewCell {

    @IBOutlet weak var firstLastName: UILabel!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var parentName: UILabel!
    @IBOutlet weak var childClass: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var moveAbout: UILabel!
    @IBOutlet weak var timeOfVisitButton: UIButton!
    @IBOutlet weak var timetableButton: UIButton!
    @IBOutlet weak var marksButton: UIButton!
    @IBOutlet weak var homeworksButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    
    @IBOutlet weak var childImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
