//
//  LoginRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 10/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class LoginRepository: NSObject {
    
    func login(email: String, password: String) -> Observable<LogInModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.login(email: email, password: password, completion: { (responseJSON, error) in
                if error != nil {
                    observer.onError(error ?? NSError.init(message: "Произошла ошибка, попробуйте позже"))
                } else {
                    guard let jsonArray = responseJSON as? [String:Any] else { return }
                    guard let user = Mapper<LogInModel>().map(JSON: jsonArray) else {
                        return
                    }
                    observer.onNext(user)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        })
    }
    
}
