
//
//  MarksViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/23/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MarksViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let childsListBehaviorRelay = BehaviorRelay<[ChildsModel]>(value: [])
    let postResultBehaviorRelay = BehaviorRelay<HomeworkModel>(value: HomeworkModel())
    var errorPostResultBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))


    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = MarksRepository()
    
    func getChildrens(classId: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getChildrens(classId: classId).subscribe(onNext: { (childsList) in
                self.childsListBehaviorRelay.accept(childsList)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func postMarks(marksObjc: [String: String], subjectId: String, date: String, comment: String, part: String, typeMark: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.postMarks(marksObjc: marksObjc, subjectId: subjectId, date: date, comment: comment, part: part, typeMark: typeMark).subscribe(onNext: { (result) in
                self.postResultBehaviorRelay.accept(result)
            }, onError: { (error) in
                self.errorPostResultBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func isConnnected() -> Bool{
        do {
            try reachability = Reachability.init()
            
            if (self.reachability?.connection) == .wifi || (self.reachability?.connection) == .cellular {
                return true
            } else if self.reachability?.connection == .unavailable {
                return false
            } else if self.reachability?.connection == .none {
                return false
            } else {
                return false
            }
        }catch{
            return false
        }
    }
    
    
    
    
}
