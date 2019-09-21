//
//  TimetableViewModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TimetableViewModel: NSObject {
    
    var errorBehaviorRelay = BehaviorRelay<Error>(value: NSError.init(message: ""))
    let timetableBehaviorRelay = BehaviorRelay<[TimetableModel]>(value: [])
    var reachability:Reachability?
    
    private let disposeBag = DisposeBag()
    private let repository = TimetableRepository()
    
    func getTimetable(class_id: String, completion: @escaping (Error?) -> ()) {
        if self.isConnnected() == true {
            self.repository.getTimetable(classId: class_id).subscribe(onNext: { (subjectsList) in
                self.timetableBehaviorRelay.accept(subjectsList)
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
