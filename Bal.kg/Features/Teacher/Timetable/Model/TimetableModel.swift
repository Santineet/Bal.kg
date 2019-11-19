//
//  TimetableModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class TimetableModel: NSObject, Mappable {
    
    var dayName: String = ""
    var subjects = [SubjectsModel]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        dayName <- map["day_name"]
        subjects <- map["list_subjects"]
    }
    
}
