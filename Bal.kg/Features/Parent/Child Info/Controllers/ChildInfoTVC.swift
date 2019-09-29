//
//  ChildInfoTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/29/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class ChildInfoTVC: UITableViewController {

    let childInfoVM = ChildInfoViewModel()
    let disposeBag = DisposeBag()
    var childInfo = ChildInfoModel()
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        getChildInfo(id: id)
    }
    
    
    func getChildInfo(id: String){
        HUD.show(.progress)
        self.childInfoVM.getChildInfo(id: id) { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        self.childInfoVM.childInfoBehaviorRelay.skip(1).subscribe(onNext: { (info) in
            
            HUD.hide()
            self.childInfo = info
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.childInfoVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            
        }).disposed(by: disposeBag)
        
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildInfoTVCell", for: indexPath) as! ChildInfoTVCell
        
        cell.firstLastName.text = self.childInfo.firstName + "" + self.childInfo.lastName
        cell.secondName.text = self.childInfo.secondName
        cell.childClass.text = self.childInfo.child_class
        cell.number.text = self.childInfo.phone
        cell.parentName.text = self.childInfo.parent_1
        cell.schoolName.text = self.childInfo.school
        cell.moveAbout.text = self.childInfo.move_about

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    




}
