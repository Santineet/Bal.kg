//
//  HomeworkCommentTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 10/2/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class HomeworkCommentTVC: UITableViewController {

    
    var homeworkList = [HomeworkListModel]()
    let myHomeworkVM = MyHomeworkViewModel()
    let disposeBag = DisposeBag()

    var id: String = ""
    var subjectId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.tableView.allowsSelection = false
        getHomework(id: id, subject_id: subjectId)
        
    }

    
    func getHomework(id: String, subject_id: String){
        
        self.myHomeworkVM.getHomeworkList(id: id, subject_id: subject_id) { (error) in
            if let error = error {
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        self.myHomeworkVM.homeworkListBehaviorRelay.skip(1).subscribe(onNext: { (homeworkList) in
            self.homeworkList = homeworkList
            self.tableView.reloadData()
            HUD.hide()
            
        }).disposed(by: disposeBag)
        
        
        self.myHomeworkVM.errorHomeworkListBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            
            HUD.hide()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userType")
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            LoginLogoutManager.instance.updateRootVC()
            
        }).disposed(by: disposeBag)
    
        
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return homeworkList.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let homework = self.homeworkList[indexPath.row]
        
        if homework.homework == "" {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeworkCommentTVCell", for: indexPath) as! HomeworkCommentTVCell
        
        cell.dateLabel.text = homework.date
        cell.commentLabel.text = homework.homework
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let homework = self.homeworkList[indexPath.row]
        
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
