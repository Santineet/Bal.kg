//
//  TeacherTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/18/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class TeacherTVC: UITableViewController {

    let teacherVM = TeacherViewModel()
    let disposeBag = DisposeBag()
    var classesList = [ClassesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Учитель"
        self.tableView.allowsSelection = false
        
        getClasses()
        
        let token = UserDefaults.standard.value(forKey: "token") as! String
        print("token \(token)") 
        
    }
    
    func getClasses(){
        HUD.show(.progress)
        self.teacherVM.getClasses { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "", message: error?.localizedDescription ?? "Connection error", vc: self)
            }
        }
        
        self.teacherVM.classesBehaviorRelay.skip(1).subscribe(onNext: { (classes) in
            
            self.classesList = classes
            self.tableView.reloadData()
            HUD.hide()
            
        }).disposed(by: disposeBag)
        
        self.teacherVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }
    
    @objc func logout(){
        
        HUD.show(.progress)
        self.teacherVM.logout { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
            
        }
        
        self.teacherVM.logoutBehaviorRelay.skip(1).subscribe(onNext: { (success) in
            if success.status == "ok" {
               
                HUD.hide()
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "userType")
                Alert.displayAlert(title: "", message: success.message, vc: self)
                LoginLogoutManager.instance.updateRootVC()
                
            } else if success.status == "error"{
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: success.message, vc: self)
            }
        }).disposed(by: disposeBag)
        
        self.teacherVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.classesList.count + 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == classesList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutTVCell", for: indexPath) as! LogoutTVCell
            
            cell.logoutButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
            return cell
        }
        
        let grade = classesList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherListTVCell", for: indexPath) as! TeacherListTVCell

        cell.classesList.tag = indexPath.row
        cell.classesList.setTitle(grade.name, for: .normal)
        cell.classesList.addTarget(self, action: #selector(didTappedButton(button:)), for: .touchUpInside)
        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == classesList.count {
            return 110
        }
        
        return 80
    }
    
    @objc func didTappedButton(button: UIButton){
        let index = button.tag
        let classId = classesList[index].id
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimetableCV") as! TimetableCV
        vc.classId = classId
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
