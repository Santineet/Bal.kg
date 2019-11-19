//
//  ChildMoveTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class ChildMoveTVC: UITableViewController {

    
    let childMoveVM = ChildMoveViewModel()
    let disposeBag = DisposeBag()
    var childMove = [ChildMoveModel]()
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getChildMove(id: id)
        
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView()
        navigationItem.title = "Посещения"
    }

    func getChildMove(id: String){
        
        HUD.show(.progress)
        self.childMoveVM.getMyChildrens(id: id) { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        self.childMoveVM.childMoveBehaviorRelay.skip(1).subscribe(onNext: { (moveInfo) in
            
            HUD.hide()
            self.childMove = moveInfo
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.childMoveVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            
            if error.localizedDescription == "Нет посещений" {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
                
            } else {
                HUD.hide()
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "userType")
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
                LoginLogoutManager.instance.updateRootVC()
            }
            
        }).disposed(by: disposeBag)
        
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.childMove.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildMoveTVCell", for: indexPath) as! ChildMoveTVCell

        let move = self.childMove[indexPath.row]

        cell.date.text = move.date
        cell.about.text = move.about
        
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }

}
