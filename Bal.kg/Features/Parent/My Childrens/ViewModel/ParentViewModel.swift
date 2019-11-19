//
//  ParentViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/27/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ParentViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let myChildsListBehaviorRelay = BehaviorRelay<[MyChildrensModel]>(value: [])
    let logoutBehaviorRelay = BehaviorRelay<LogInModel>(value: LogInModel())
    let logouterrorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))

    
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = ParentRepository()
    
    func getMyChildrens(completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getMyChildrens().subscribe(onNext: { (childsList) in
             
                self.myChildsListBehaviorRelay.accept(childsList)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func logout(completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.logout().subscribe(onNext: { (result) in
                self.logoutBehaviorRelay.accept(result) 
            }, onError: { (error) in
                self.logouterrorBehaviorRelay.accept(error)
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
