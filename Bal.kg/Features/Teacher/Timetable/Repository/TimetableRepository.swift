//
//  TimetableRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class TimetableRepository: NSObject {
    
    func getTimetable(classId: String) -> Observable<[TimetableModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getTimetable(classId: classId, completion: { (responseJSON, error) in
               
                guard let jsonArray = responseJSON as? [[String:Any]] else { return }

                var subjects = [TimetableModel]()
                for i in 0..<jsonArray.count{
                    guard let subject = Mapper<TimetableModel>().map(JSON: jsonArray[i]) else {
                        observer.onError(error ?? Constant.BACKEND_ERROR)
                        return
                    }
                    
                    subjects.append(subject)
                    
                    if subjects.count == jsonArray.count {
                        observer.onNext(subjects)
                        observer.onCompleted()
                    }
                }
                
            })

            return Disposables.create()
        })
    }
    
    
    
    
}
