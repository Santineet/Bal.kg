//
//  HomeworkViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/24/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeworkViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let resultBehaviorRelay = BehaviorRelay<HomeworkModel>(value: HomeworkModel())
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = HomeworkRepository()
    
    func postHomework(classId: String, subjectId: String, date: String, text: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.postHomework(classId: classId, subjectId: subjectId, date: date, text: text).subscribe(onNext: { (result) in
                self.resultBehaviorRelay.accept(result)
            }, onError: { (error) in
                self.errorBehaviorRelay.accept(error)
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
