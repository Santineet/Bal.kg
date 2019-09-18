//
//  GuardRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 10/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class GuardRepository: NSObject {
    
    func logout() -> Observable<LogInModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.logout(completion: { (responseJSON, error) in
                guard let jsonArray = responseJSON as? [String:Any] else { return }
                guard let result = Mapper<LogInModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(result)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
    func sendData(id: String, status: Int, type: String, time: String, image: UIImage?) -> Observable<SendDataModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.sendData(id: id, status: status, type: type, time: time, image: image, completion: { (responseJSON, error) in
                
                guard let jsonArray = responseJSON as? [String:Any] else { return }
                guard let result = Mapper<SendDataModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(result)
                observer.onCompleted()
            })
            
            return Disposables.create()
        })
        
        
    }
    
    
}
