//
//  MarkCommentTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/23/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class MarkCommentTVCell: UITableViewCell {

    @IBOutlet weak var markSwitch: UISwitch!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var markComment: UITextView!
    
    var link: MarksTVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        markComment.text = "Комментарий..."
        markComment.textColor = UIColor.lightGray
        markComment.delegate = self
        markSwitch.addTarget(self, action: #selector(switchTarget(paramTarget:)), for: .valueChanged)
        dropShadow(button: termButton)
        textViewShadow(txtView: markComment)
    }
    @objc func switchTarget(paramTarget: UISwitch){
        self.link?.switchTarget(sender: paramTarget)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
    
    func textViewShadow(txtView: UITextView) {
        txtView.layer.masksToBounds = false
        txtView.layer.cornerRadius = 6
        txtView.clipsToBounds = false
        txtView.layer.shadowOpacity=0.7
        txtView.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    

}

extension MarkCommentTVCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty
        {
            textView.text = "Комментарий..."
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }

}
