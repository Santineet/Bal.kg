//
//  GuardViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 10/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GuardViewModel: NSObject {

    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    var errorLogoutBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let logoutBehaviorRelay = BehaviorRelay<LogInModel>(value: LogInModel())
    let guestInfoBehaviorRelay = BehaviorRelay<SendDataModel>(value: SendDataModel())
    var reachability:Reachability?

    private let disposeBag = DisposeBag()
    private let repository = GuardRepository()
    
    func logout(completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.logout().subscribe(onNext: { (result) in
                self.logoutBehaviorRelay.accept(result)
            }, onError: { (error) in
                self.errorLogoutBehaviorRelay.accept(error)
            }).disposed(by: disposeBag) 
        } else {
            completion(NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func sendInfo(id: String, status: Int, type: String, time: String, imageData: Data?,imageName: String?, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.sendData(id: id, status: status, type: type, time: time, imageData: imageData, imageName: imageName) .subscribe(onNext: { (result) in
                print(result)
                self.guestInfoBehaviorRelay.accept(result)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func isConnnected() -> Bool{
        do {
            try reachability = Reachability.init()
            
            if (self.reachability?.connection) == .wifi || (self.reachability?.connection) == .cellular {
                return true
            } else if self.reachability?.connection == .unavailable {
                return false
            } else if self.reachability?.connection == .none {
                return false
            } else {
                return false
            }
        }catch{
            return false
        }
    }


}


