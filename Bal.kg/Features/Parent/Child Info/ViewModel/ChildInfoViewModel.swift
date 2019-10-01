//
//  ChildInfoTVCell.swift
//  Bal.kg
//
//  Created by Mairambek on 9/29/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChildInfoViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    var childInfoBehaviorRelay = BehaviorRelay<ChildInfoModel>(value: ChildInfoModel())
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = ChildInfoRepository()
    
    func getChildInfo(id: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getChildInfo(id: id).subscribe(onNext: { (childInfo) in
                self.childInfoBehaviorRelay.accept(childInfo)
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
