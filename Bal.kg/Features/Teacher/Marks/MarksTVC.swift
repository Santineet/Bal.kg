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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Поставить оценку"
        if let classId = classId {
            getChildsList(slassId: classId)
        }
        
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()
    }
    
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
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return childsList.count + 2
    }
    
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
        
        cell.childName.text = childInfo.fio
        cell.markButton.addTarget(self, action: #selector(marksButtonTarget(button:)), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        } else if indexPath.row == childsList.count + 1 {
            return 100
        } else {
            return 75
        }
    }
    
    func switchTarget(sender: UISwitch){
        if sender.isOn {
            self.termStatus = 1
        } else {
            self.termStatus = 0
        }
    }
    
    
    @objc func sendButtonTarget(){
        print("button is work")
        
    }
    
    @objc func termButtonTarget(button: UIButton){
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fourthAction: UIAlertAction = UIAlertAction(title: "4", style: .default) { action -> Void in
        

            button.setTitle("Четверть: 4", for: .normal)
            
        }
        let thirdtion: UIAlertAction = UIAlertAction(title: "3", style: .default) { action -> Void in
            button.setTitle("Четверть: 3", for: .normal)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "2", style: .default) { action -> Void in
            button.setTitle("Четверть: 2", for: .normal)
        }
        
        let firstAction: UIAlertAction = UIAlertAction(title: "1", style: .default) { action -> Void in
            button.setTitle("Четверть: 1", for: .normal)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        // add actions
        actionSheetController.addAction(fourthAction)
        actionSheetController.addAction(thirdtion)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)
        
        
        // present an actionSheet...
        // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad
        
        actionSheetController.popoverPresentationController?.sourceView = view // works for both iPhone & iPad
        
        present(actionSheetController, animated: true) {
        }

    }
    
  
    
    @objc func marksButtonTarget(button: UIButton){
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fourthAction: UIAlertAction = UIAlertAction(title: "5", style: .default) { action -> Void in
            
            
            button.setTitle("5", for: .normal)
            
        }
        let thirdtion: UIAlertAction = UIAlertAction(title: "4", style: .default) { action -> Void in
            button.setTitle("4", for: .normal)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "3", style: .default) { action -> Void in
            button.setTitle("3", for: .normal)
        }
        
        let firstAction: UIAlertAction = UIAlertAction(title: "2", style: .default) { action -> Void in
            button.setTitle("2", for: .normal)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        // add actions
        actionSheetController.addAction(fourthAction)
        actionSheetController.addAction(thirdtion)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)
        
        
        actionSheetController.popoverPresentationController?.sourceView = view // works for both iPhone & iPad
        
        present(actionSheetController, animated: true) {
        }
        
        
    }
    
    
    
}

