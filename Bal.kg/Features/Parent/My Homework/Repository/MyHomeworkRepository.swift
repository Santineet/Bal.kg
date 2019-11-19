//
//  MyHomeworkRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 10/1/19.
//  Copyright © 2019 Sunrise. All rights reserved.

import Foundation
import ObjectMapper
import RxSwift

class MyHomeworkRepository: NSObject {
    
    func getShedulesHomework(id: String) ->  Observable<[MyHomeworkModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getMyHomework(id: id, subject_id: "", completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else {
                    
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var homeworkList = [MyHomeworkModel]()
                    for i in 0..<jsonArray.count{
                        guard let homework = Mapper<MyHomeworkModel>().map(JSON: jsonArray[i]) else {
                            return
                        }
                        
                        homeworkList.append(homework)
                        
                        if homeworkList.count == jsonArray.count {
                            observer.onNext(homeworkList)
                            observer.onCompleted()
                        }
                    }
                    
                }
            })
            
            return Disposables.create()
        })
    }
    
    
    func getHomeworkList(id: String, subject_id: String) ->  Observable<[HomeworkListModel]> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.getMyHomework(id: id, subject_id: subject_id, completion: { (responseJSON, error) in
                
                if error != nil {
                    observer.onError(Constant.BACKEND_ERROR)
                } else {
                    
                    guard let jsonArray = responseJSON as? [[String:Any]] else { return }
                    
                    var homeworkList = [HomeworkListModel]()
                    for i in 0..<jsonArray.count{
                        guard let homework = Mapper<HomeworkListModel>().map(JSON: jsonArray[i]) else { return }
                        
                        homeworkList.append(homework)
                        if homeworkList.count == jsonArray.count {
                            observer.onNext(homeworkList)
                            observer.onCompleted()
                        }
                    }
                    
                }
            })
            
            return Disposables.create()
        })
    }
    
    
 
    
}
