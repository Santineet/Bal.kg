//
//  ParentRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/27/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class ParentRepository: NSObject {
    
    func logout() -> Observable<LogInModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.logout(completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                } else {
                    guard let jsonArray = responseJSON as? [String:Any] else { return }
                    guard let result = Mapper<LogInModel>().map(JSON: jsonArray) else {
                        return
                    }
                    observer.onNext(result)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
    func getMyChildrens() -> Observable<[MyChildrensModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getMyChildrens(completion: { (responseJSON, error) in 
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else {
                    
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var childs = [MyChildrensModel]()
                    for i in 0..<jsonArray.count{
                        guard let child = Mapper<MyChildrensModel>().map(JSON: jsonArray[i]) else {
                            return
                        }
                        
                        childs.append(child)
                        
                        if childs.count == jsonArray.count {
                            observer.onNext(childs)
                            observer.onCompleted()
                        }
                        
                    }
                }
                
            })
            
            return Disposables.create()
        })
    }
    
    
}
