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
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag) 
        } else {
            completion(NSError.init(message: "Нет соединения"))
        }
    }
    
    func sendInfo(id: String, status: Int, type: String, time: String, image: UIImage?, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.sendData(id: id, status: status, type: type, time: time, image: image) .subscribe(onNext: { (result) in
                self.guestInfoBehaviorRelay.accept(result)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Нет соединения"))
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


