//
//  ChildMoveRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class ChildMoveRepository: NSObject {
    
    func getChildMove(id: String) -> Observable<[ChildMoveModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getChildMove(id: id, completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else if !(responseJSON is [[String: Any]]){
                    
                    observer.onError(NSError.init(message: "Нет посещений"))
                    
                } else {

                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var childMove = [ChildMoveModel]()
                    for i in 0..<jsonArray.count{
                        guard let info = Mapper<ChildMoveModel>().map(JSON: jsonArray[i]) else { return }
                        
                        childMove.append(info)
                        
                        if childMove.count == jsonArray.count {
                            observer.onNext(childMove)
                            observer.onCompleted()
                        }
                        
                    }
                }
            })
            
            return Disposables.create()
        })
    }
    
    
    
    
}
