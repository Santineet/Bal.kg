//
//  MyHomeworkModel.swift
//  Bal.kg
//
//  Created by Mairambek on 10/1/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class MyHomeworkModel: NSObject, Mappable {
    
    var day_name: String = ""
    var list_subjects = [SubjectsListModel]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        day_name <- map["day_name"]
        list_subjects <- map["list_subjects"]
    }
    
}
