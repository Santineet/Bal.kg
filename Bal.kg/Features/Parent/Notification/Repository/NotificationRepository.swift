//
//  NotificationRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/27/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class NotificationRepository: NSObject {
    
    func getNotifications() ->  Observable<[NotificationModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getNotifictions(completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else {
                    
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var notifications = [NotificationModel]()
                    for i in 0..<jsonArray.count{
                        guard let object = Mapper<NotificationModel>().map(JSON: jsonArray[i]) else {
                            return
                        }
                        
                        notifications.append(object)
                        
                        if notifications.count == jsonArray.count {
                            observer.onNext(notifications)
                            observer.onCompleted()
                        }
                    }
                    
                }
            })
            
            return Disposables.create()
        })
    }
    
    
}


