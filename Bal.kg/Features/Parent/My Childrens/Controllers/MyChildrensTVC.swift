//
//  MyChildrensTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/27/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD


class MyChildrensTVC: UITableViewController {

    let parentVM = ParentViewModel()
    let disposeBag = DisposeBag()
    var myChildrens = [MyChildrensModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Родитель"
        
        let token = UserDefaults.standard.value(forKey: "token") as! String
        print("token \(token)")
        getMyhChildrens()
        self.tableView.tableFooterView = UIView()

        self.tableView.allowsSelection = false
    }

    @IBAction func notificationBarButton(_ sender: UIBarButtonItem) {
    
        let notifVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationTVC") as! NotificationTVC
        
        navigationController?.pushViewController(notifVC, animated: true)
 
    }
    
    
    
    //MARK: getMyhChildrens
    
    func getMyhChildrens(){
        
        HUD.show(.progress)
        
        self.parentVM.getMyChildrens { (error) in
            HUD.hide()
            if let error = error {
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        self.parentVM.myChildsListBehaviorRelay.skip(1).subscribe(onNext: { (myChilds) in
            
            self.myChildrens = myChilds
            self.tableView.reloadData()
            HUD.hide()
            
        }).disposed(by: disposeBag)
        
        self.parentVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }
    
    
    
    //MARK: numberOfRowsInSection
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myChildrens.count + 1
    }
    
    //MARK: cellForRowAt
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.myChildrens.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParentLogoutTVCell", for: indexPath) as! ParentLogoutTVCell
            
            cell.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
            
            return cell
        }
        
        let child = self.myChildrens[indexPath.row]
        let name = child.firstName + " " + child.lastName
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyChildrensListTVCell", for: indexPath) as! MyChildrensListTVCell
        
        cell.childrenNameButton.setTitle( name, for: .normal)
        cell.childrenNameButton.tag = indexPath.row
        cell.childrenNameButton.addTarget(self, action: #selector(pressedButton(button:)), for: .touchUpInside)
        
        return cell
    }
    
    
    //MARK: heightForRowAt
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: logout
    
    @objc func logout(){
        
        HUD.show(.progress)
        self.parentVM.logout { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
            
        }
        
        self.parentVM.logoutBehaviorRelay.skip(1).subscribe(onNext: { (success) in
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
        
        self.parentVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userType")
            LoginLogoutManager.instance.updateRootVC()
            
        }).disposed(by: disposeBag)
    }
    
    //MARK: pressed Button
    
    @objc func pressedButton(button: UIButton){
        
        let index = button.tag
        let id = self.myChildrens[index].id
        let childInfovc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildInfoTVC") as! ChildInfoTVC
        
        childInfovc.id = id
        
        navigationController?.pushViewController(childInfovc, animated: true)
        
    }
    
    
    
    
}







