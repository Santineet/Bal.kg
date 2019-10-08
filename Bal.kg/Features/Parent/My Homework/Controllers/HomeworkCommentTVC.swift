//
//  HomeworkCommentTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 10/2/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class HomeworkCommentTVC: UITableViewController {

    
    var homeworkObject = [SubjectsListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsSelection = false
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return homeworkObject.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let homework = self.homeworkObject[indexPath.row]
        
        if homework.homework == "" {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeworkCommentTVCell", for: indexPath) as! HomeworkCommentTVCell


        print(homework.homework)
        
        cell.dateLabel.text = homework.date
        cell.commentLabel.text = homework.homework
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let homework = self.homeworkObject[indexPath.row]
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 17.0)!, myText: homework.homework)
        let labelWidth: CGFloat = UIScreen.main.bounds.width - 125.0
        let originalLabelHeight: CGFloat = 21.0
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))

        if labelLines == 0 {
            return 65.0
        }
        
        let height =  65.0 - originalLabelHeight + CGFloat(labelLines*21)
        
        return height
                
    }
    
    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        
        return size
    }

   

}
