//
//  MyChildTimetableRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class MyChildTimetableRepository: NSObject {
    
    func getChildTimetable(id: String) -> Observable<[TimetableModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getMyChildTimetable(id: id, completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else {
                  
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var subjectList = [TimetableModel]()
                    for i in 0..<jsonArray.count{
                        guard let subject = Mapper<TimetableModel>().map(JSON: jsonArray[i]) else {
                            return
                        }
                        
                        subjectList.append(subject)
                        
                        if subjectList.count == jsonArray.count {
                            observer.onNext(subjectList)
                            observer.onCompleted()
                        }
                        
                    }
                    
                }
            })
            
            return Disposables.create()
        })
    }
    
    
    
    
}
