//
//  TeacherViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TeacherViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let logoutBehaviorRelay = BehaviorRelay<LogInModel>(value: LogInModel())
    let classesBehaviorRelay = BehaviorRelay<[ClassesModel]>(value: [])
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = TeacherRepository()
    
    func logout(completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.logout().subscribe(onNext: { (result) in
                self.logoutBehaviorRelay.accept(result)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func getClasses(completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getClasses().subscribe(onNext: { (classes) in
                self.classesBehaviorRelay.accept(classes)
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


