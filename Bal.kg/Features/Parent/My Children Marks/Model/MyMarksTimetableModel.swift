//
//  MyMarksTimetableModel.swift
//  Bal.kg
//
//  Created by Mairambek on 11/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import ObjectMapper

class MyMarksTimetableModel: NSObject, Mappable {
    
    var dayName: String = ""
    var subjects = [MarkTimetableSubjectsModel]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        dayName <- map["day_name"]
        subjects <- map["list_subjects"]
    }
    
}
