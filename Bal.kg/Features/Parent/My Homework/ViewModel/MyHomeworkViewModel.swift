//
//  MyHomeworkViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 10/1/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyHomeworkViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    var shedulesHomeworkBehaviorRelay = BehaviorRelay<[MyHomeworkModel]>(value: [])
    var errorHomeworkListBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))

    var homeworkListBehaviorRelay = BehaviorRelay<[HomeworkListModel]>(value: [])

    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = MyHomeworkRepository()
    
    func getShedulesHomework(id: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getShedulesHomework(id: id).subscribe(onNext: { (homeworkList) in
                self.shedulesHomeworkBehaviorRelay.accept(homeworkList)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
            }).disposed(by: disposeBag)
        } else {
            completion(NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func getHomeworkList(id: String, subject_id: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getHomeworkList(id: id, subject_id:  subject_id).subscribe(onNext: { (homeworkList) in
                
                self.homeworkListBehaviorRelay.accept(homeworkList)
            }, onError: { (error) in
                self.errorHomeworkListBehaviorRelay.accept(error)
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
