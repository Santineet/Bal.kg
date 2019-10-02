//
//  MyMarksTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class MyMarksTVC: UITableViewController {

    let myMarksVM = MyMarksViewModel()
    let disposeBag = DisposeBag()
    var myMarks = [MyMarksModel]()
    var id: String = ""
    var subject_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMyMarks(id: id, subject_id: subject_id)
        tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()

    }
    
    
    func getMyMarks(id: String, subject_id: String){
        HUD.show(.progress)
        
        self.myMarksVM.getMyMarks(id: id, subject_id: subject_id) { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        self.myMarksVM.myMarksTimetableBehaviorRelay.skip(1).subscribe(onNext: { (myMarks) in
            self.myMarks = myMarks
            self.tableView.reloadData()
            HUD.hide()
        }).disposed(by: disposeBag)
        
        self.myMarksVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.myMarks.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mark = self.myMarks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMarksTVCell", for: indexPath) as! MyMarksTVCell

        if mark.type_mark == "part" {
            
            cell.partLabel.text = mark.part
        } else if mark.type_mark == "0" {
            
            cell.partLabel.text = "---"
        }
        
        cell.date.text = mark.date
        cell.mark.text = mark.mark
        cell.comment.text = mark.comment
        cell.comment.numberOfLines = 0

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mark = self.myMarks[indexPath.row]

        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 16.0)!, myText: mark.comment)
        let labelWidth: CGFloat = UIScreen.main.bounds.width - 125.0
        let originalLabelHeight: CGFloat = 24.0
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        let height =  135.0 - originalLabelHeight + CGFloat(labelLines*24)
        return height
        
    }

    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        
        return size
    }
    
}
