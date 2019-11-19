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
        
                if error != nil {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
 
                } else { 
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var childs = [ChildsModel]()
                    for i in 0..<jsonArray.count{
                        guard let child = Mapper<ChildsModel>().map(JSON: jsonArray[i]) else {
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
    
    func postMarks(marksObjc: [String: String], subjectId: String, date: String, comment: String, part: String, typeMark: String) -> Observable<HomeworkModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.postMarks(marksObjc: marksObjc, subjectId: subjectId, date: date, comment: comment, part: part, typeMark: typeMark, completion: { (responseJSON, error) in
            
                if error != nil {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                } else {
                    
                    guard let jsonArray = responseJSON as? [String:Any] else { return }
                    guard let result = Mapper<HomeworkModel>().map(JSON: jsonArray) else {
                        return
                    }
                    observer.onNext(result)
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
        })
        
    }
    
}
