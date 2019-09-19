//
//  LoginLogoutManager.swift
//  BffClient
//
//  Created by Avazbek Kodiraliev on 6/10/19.
//  Copyright © 2019 Avazbek Kodiraliev. All rights reserved.
//

import UIKit


class LoginLogoutManager: NSObject {
    static let instance = LoginLogoutManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func updateRootVC() {
        if UserDefaults.standard.value(forKey: Constant.USER_TOKEN_KEY) == nil{
            let vc = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            let userType =  UserDefaults.standard.value(forKey: "userType") as! String
            if userType == "guard" {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GuardVC") as! GuardVC
                appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
            } else if userType == "teacher" {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeacherTVC") as! TeacherTVC
                appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
            }
        }
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
}
