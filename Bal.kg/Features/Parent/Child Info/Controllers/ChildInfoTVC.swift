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
import SDWebImage

class ChildInfoTVC: UITableViewController {

    let childInfoVM = ChildInfoViewModel()
    let disposeBag = DisposeBag()
    var childInfo = ChildInfoModel()
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        getChildInfo(id: id)
        navigationItem.title = self.childInfo.firstName
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
        
        cell.firstLastName.text = self.childInfo.firstName + " " + self.childInfo.lastName
        cell.secondName.text = self.childInfo.secondName
        cell.childClass.text = self.childInfo.child_class
        cell.number.text = self.childInfo.phone
        cell.parentName.text = self.childInfo.parent_1
        cell.parent_2.text = self.childInfo.parent_2
        cell.schoolName.text = self.childInfo.school
        cell.moveAbout.text = self.childInfo.move_about
        let childImage = "https://bal.kg/" + self.childInfo.image

        cell.childImage.sd_setImage(with: URL(string: childImage), placeholderImage: UIImage(named: ""))
        
        cell.timeOfVisitButton.addTarget(self, action: #selector(self.childMoveButtonPressed), for: .touchUpInside)
        cell.timetableButton.addTarget(self, action: #selector(self.timetableButtonPressed), for: .touchUpInside) 
        cell.marksButton.addTarget(self, action: #selector(self.marksButtonPressed), for: .touchUpInside)
        cell.notificationsButton.addTarget(self, action: #selector(self.notificationsButtonPressed), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    @objc func childMoveButtonPressed(){
        
        let childMoveVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildMoveTVC") as! ChildMoveTVC
        
        childMoveVC.id = self.childInfo.id
        
        navigationController?.pushViewController(childMoveVC, animated: true)
        
    }
    
    @objc func timetableButtonPressed(){
        let timetablevc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyChildsTimetableCVC") as! MyChildsTimetableCVC
        
        timetablevc.id = self.childInfo.id
        
        navigationController?.pushViewController(timetablevc, animated: true)
        
    }
    
    @objc func marksButtonPressed(){
        let timetablevc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyChildsTimetableCVC") as! MyChildsTimetableCVC
        
        timetablevc.id = self.childInfo.id
        print(self.childInfo.id)
        timetablevc.isMarksVC = true
        
        navigationController?.pushViewController(timetablevc, animated: true)
        
    }

    @objc func notificationsButtonPressed(){
      
        let notificationvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationTVC") as! NotificationTVC
        
        navigationController?.pushViewController(notificationvc, animated: true)

    }

}
