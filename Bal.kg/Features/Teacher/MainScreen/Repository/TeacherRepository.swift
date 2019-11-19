//
//  TeacherRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class TeacherRepository: NSObject {
    
    func logout() -> Observable<LogInModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.logout(completion: { (responseJSON, error) in
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
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
    
    func getClasses() -> Observable<[ClassesModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getClasses(completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else {
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    var classes = [ClassesModel]()
                    
                    for i in 0..<jsonArray.count{
                        guard let result = Mapper<ClassesModel>().map(JSON: jsonArray[i]) else {
                            return
                        }
                        
                        classes.append(result)
                        
                        if classes.count == jsonArray.count {
                            observer.onNext(classes)
                            observer.onCompleted()
                        }
                    }
                    
                }
                
            })
            return Disposables.create()
        })
    }
    
    
    
}
