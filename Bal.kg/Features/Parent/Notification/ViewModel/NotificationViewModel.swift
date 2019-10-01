//
//  NotifView.swift
//  Bal.kg
//
//  Created by Mairambek on 9/27/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let notificationsBehaviorRelay = BehaviorRelay<[NotificationModel]>(value: [])
    
    
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = NotificationRepository()
    
    func getNotifications(completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getNotifications().subscribe(onNext: { (notifications) in
                self.notificationsBehaviorRelay.accept(notifications)
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
