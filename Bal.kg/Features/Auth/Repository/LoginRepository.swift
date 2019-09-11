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
                guard let jsonArray = responseJSON as? [String:Any] else { return }
                guard let user = Mapper<LogInModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(user)
                observer.onCompleted()
            })
            return Disposables.create()
        })
    }
    
}
