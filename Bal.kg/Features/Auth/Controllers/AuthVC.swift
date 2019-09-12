//
//  AuthVC.swift
//  Bal.kg
//
//  Created by Mairambek on 10/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class AuthVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginVM = LoginViewModel() 
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.addTarget(self, action: #selector(self.didTapedLoginButton), for: .touchUpInside)
        
    }
    
    
    @objc func didTapedLoginButton(){
        HUD.show(.progress)
        
        guard let email = self.emailField.text  else { return }
        guard let password = self.passwordField.text  else { return }
        
        if(!email.isEmpty && !password.isEmpty){
            
            let md5Data = self.loginVM.MD5(string: password)
            let md5Password = md5Data.map { String(format: "%02hhx", $0) }.joined()
            
            self.loginVM.login(email: email, password: md5Password) { (error) in
                if error != nil {
                    HUD.hide()
                    Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
                }
            }
            
            self.loginVM.loginBehaviorRelay.skip(1).subscribe(onNext: { (user) in
                HUD.hide()
                if user.status == "ok" {
                    let token = user.token
                    let userType = user.userType
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(userType, forKey: "userType")

                    LoginLogoutManager.instance.updateRootVC()
                } else if user.status == "error" {
                    Alert.displayAlert(title: "Ошибка", message: user.message, vc: self)
                }
                
            }).disposed(by: disposeBag)
            
        } else {
            HUD.hide()
            Alert.displayAlert(title: "Внимание", message: "Заполните все поля!", vc: self)
        }

    }

}
