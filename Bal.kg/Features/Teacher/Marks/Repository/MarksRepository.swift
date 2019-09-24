//
//  MarksRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/23/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class MarksRepository: NSObject {
    
    func getChildrens(classId: String) -> Observable<[ChildsModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getChildrens(classId: classId, completion: { (responseJSON, error) in
        
                guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                
                var childs = [ChildsModel]()
                for i in 0..<jsonArray.count{
                    guard let child = Mapper<ChildsModel>().map(JSON: jsonArray[i]) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                    
                    childs.append(child)
                    
                    if childs.count == jsonArray.count {
                        observer.onNext(childs)
                        observer.onCompleted()
                    }
                }
                
            })

            return Disposables.create()
        })
    }
    
    
    
    
}
