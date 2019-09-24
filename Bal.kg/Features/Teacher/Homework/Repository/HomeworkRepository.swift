//
//  HomeworkRepository.swift
//  Bal.kg
//
//  Created by Mairambek on 9/22/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class HomeworkRepository: NSObject {

    func postHomework(classId: String, subjectId: String, date: String, text: String) -> Observable<HomeworkModel> {
        return Observable.create({ (observer) -> Disposable in
            ServiceManager.sharedInstance.postHomework(classId: classId, subjectId: subjectId, date: date, text: text, completion: { (responseJSON, error) in

                guard let jsonArray = responseJSON as? [String:Any] else { return }
                guard let result = Mapper<HomeworkModel>().map(JSON: jsonArray) else {
                    observer.onError(error ?? Constant.BACKEND_ERROR)
                    return
                }
                observer.onNext(result)
                observer.onCompleted()
            })

            return Disposables.create()
        })
    }




}
