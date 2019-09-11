//
//  GuardVC.swift
//  Bal.kg
//
//  Created by Mairambek on 10/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class GuardVC: UIViewController {

    var loginVM = GuardViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blue

    }
    
    @IBAction func logoutBarButton(_ sender: Any) {
        HUD.show(.progress)
        self.loginVM.logout { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        
        self.loginVM.logoutBehaviorRelay.skip(1).subscribe(onNext: { (success) in
            HUD.hide()
            if success.status == "ok" {
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "userType")
                Alert.displayAlert(title: "", message: success.message, vc: self)
                LoginLogoutManager.instance.updateRootVC()
            } else if success.status == "error"{
                Alert.displayAlert(title: "Ошибка", message: success.message, vc: self)
            }
        }).disposed(by: disposeBag)
        
        self.loginVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
        
    }
    
   

}
