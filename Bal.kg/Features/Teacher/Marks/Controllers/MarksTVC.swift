//
//  MarksTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/23/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class MarksTVC: UITableViewController {
    
    let marksVM = MarksViewModel()
    let disposeBag = DisposeBag()
    var childsList = [ChildsModel]()
    var classId: String?
    var subjectId: String?
    var termStatus = 0
    var marksObject: [String: String] = [:]
    var part: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Поставить оценку"
        if let classId = classId {
            getChildsList(slassId: classId)
        }
        
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()
        

        
        
        
    }
    
    //MARK: Get Childs List

    func getChildsList(slassId: String){
        HUD.show(.progress)
        self.marksVM.getChildrens(classId: slassId) { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription , vc: self)
            }
        }
        
        self.marksVM.childsListBehaviorRelay.skip(1).subscribe(onNext: { (childsList) in
            self.childsList = childsList
            self.tableView.reloadData()
            HUD.hide()
        }).disposed(by: disposeBag)
        
        self.marksVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
    }
    
    //MARK: numberOfRowsInSection
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return childsList.count + 2
    }
    
    //MARK: cellForRowAt
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCommentTVCell") as! MarkCommentTVCell
            cell.link = self
            cell.termButton.addTarget(self, action: #selector(self.termButtonTarget(button:)), for: .touchUpInside)
            return cell
        } else if indexPath.row == childsList.count + 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendHomeworkTVCell") as! SendHomeworkTVCell
            cell.sendButton.addTarget(self, action: #selector(self.sendButtonTarget), for: .touchUpInside)
            return cell
        }
        
        
        let childInfo = childsList[indexPath.row - 1]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildListForMarkTVCell", for: indexPath) as! ChildListForMarkTVCell
        cell.markButton.tag = indexPath.row - 1
        cell.childName.text = childInfo.fio
        cell.markButton.addTarget(self, action: #selector(marksButtonTarget(button:)), for: .touchUpInside)
        
        return cell
    }
    
    //MARK: heightForRowAt
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        } else if indexPath.row == childsList.count + 1 {
            return 100
        } else {
            return 75
        }
    }
    
    //MARK: switch Target for cell

    func switchTarget(sender: UISwitch){
        if sender.isOn {
            self.termStatus = 1
        } else {
            self.termStatus = 0
        }
    }
    
    //MARK: send Button Target

    @objc func sendButtonTarget(){

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateFormat = dateFormatter.string(from: date)
        print(dateFormat)

        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCommentTVCell") as! MarkCommentTVCell
        
        let comment = cell.comment
        var typeMark = "0"
        
        if self.termStatus == 1 {
            typeMark = "part"
        }
        
        print(typeMark)
        print(comment)
        print(part)

        
        if part == "" {
            Alert.displayAlert(title: "", message: "Выберите четверть", vc: self)
            return
        } else if comment == "Комментарий..." {
            Alert.displayAlert(title: "", message: "Введите комментарий", vc: self)
            return
        }
    
        
        
        
    }
    
    //MARK: term Button Target

    @objc func termButtonTarget(button: UIButton){
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fourthAction: UIAlertAction = UIAlertAction(title: "4", style: .default) { action -> Void in

            self.part = "4"
            button.setTitle("Четверть: 4", for: .normal)
        }
        
        let thirdtion: UIAlertAction = UIAlertAction(title: "3", style: .default) { action -> Void in
            self.part = "3"
            button.setTitle("Четверть: 3", for: .normal)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "2", style: .default) { action -> Void in
            self.part = "2"
            button.setTitle("Четверть: 2", for: .normal)
        }
        
        let firstAction: UIAlertAction = UIAlertAction(title: "1", style: .default) { action -> Void in
            self.part = "1"
            button.setTitle("Четверть: 1", for: .normal)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        // add actions
        actionSheetController.addAction(fourthAction)
        actionSheetController.addAction(thirdtion)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = view
        present(actionSheetController, animated: true) {
        }

    }
    
      //MARK: marks Button Target

    @objc func marksButtonTarget(button: UIButton){
        
        let childId = childsList[button.tag].id

        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fourthAction: UIAlertAction = UIAlertAction(title: "5", style: .default) { action -> Void in
            self.marksObject[childId] = "5"
            button.setTitle("5", for: .normal)
            
        }
        let thirdtion: UIAlertAction = UIAlertAction(title: "4", style: .default) { action -> Void in
            self.marksObject[childId] = "4"
            button.setTitle("4", for: .normal)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "3", style: .default) { action -> Void in
            self.marksObject[childId] = "4"
            button.setTitle("3", for: .normal)
        }
        
        let firstAction: UIAlertAction = UIAlertAction(title: "2", style: .default) { action -> Void in
            self.marksObject[childId] = "2"
            button.setTitle("2", for: .normal)
        }
        
        let nbAction: UIAlertAction = UIAlertAction(title: "Н/Б", style: .default) { action -> Void in
            self.marksObject[childId] = "Н/Б"
            button.setTitle("Н/Б", for: .normal)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            print(self.marksObject.count)
            
        }
        // add actions
        actionSheetController.addAction(fourthAction)
        actionSheetController.addAction(thirdtion)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(nbAction)
        actionSheetController.addAction(cancelAction)
        
        
        actionSheetController.popoverPresentationController?.sourceView = view // works for both iPhone & iPad
        
        present(actionSheetController, animated: true) {
        }
        
    }
    
    
    
}

