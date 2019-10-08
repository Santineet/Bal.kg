//
//  MyMarksRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class MyMarksRepository: NSObject {
    
    func getMyMarks(id: String, subject_id: String) ->  Observable<[MyMarksModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getMyMarks(id: id, subject_id: subject_id, completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else if !(responseJSON is [[String: Any]]) {
                    
                    observer.onError(NSError.init(message: "Нет Оценок"))
                    
                } else {
                    
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var marks = [MyMarksModel]()
                    for i in 0..<jsonArray.count{
                        guard let mark = Mapper<MyMarksModel>().map(JSON: jsonArray[i]) else {
                            return
                        }
                        
                        marks.append(mark)
                        
                        if marks.count == jsonArray.count {
                            observer.onNext(marks)
                            observer.onCompleted()
                        }
                    }
                    
                }
            })
            
            return Disposables.create()
        })
    }
    
    
    
    
}
