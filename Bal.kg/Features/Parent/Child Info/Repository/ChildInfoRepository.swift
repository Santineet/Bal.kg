//
//  ChildInfoRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/29/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class ChildInfoRepository: NSObject {
    
    func getChildInfo(id: String) -> Observable<ChildInfoModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getChildsInfo(id: id, completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else {
                    guard let jsonArray = responseJSON as? [String:Any] else { return }
                    guard let childInfo = Mapper<ChildInfoModel>().map(JSON: jsonArray) else { return }
                    print(childInfo.firstName)
                    print("wdsfs")
                    observer.onNext(childInfo)
                    observer.onCompleted()
                    
                }
            })
            
            return Disposables.create()
        })
    }
    
    
    
    
}
