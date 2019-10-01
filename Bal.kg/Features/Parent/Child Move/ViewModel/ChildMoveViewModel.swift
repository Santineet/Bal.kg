//
//  ChildMoveViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChildMoveViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let childMoveBehaviorRelay = BehaviorRelay<[ChildMoveModel]>(value: [])
    
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = ChildMoveRepository()
    
    func getMyChildrens(id: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getChildMove(id: id).subscribe(onNext: { (childMove) in
                self.childMoveBehaviorRelay.accept(childMove)
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
