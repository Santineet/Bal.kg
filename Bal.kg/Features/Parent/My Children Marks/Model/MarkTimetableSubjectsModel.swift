//
//  MarkTimetableSubjectsModel.swift
//  Bal.kg
//
//  Created by Mairambek on 11/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class MarkTimetableSubjectsModel: NSObject, Mappable {
    
    var id: String = ""
    var nameSubject: String = ""
    var timeStart: String = ""
    var mark: String = ""
    var comment: String = ""
    var date: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        nameSubject <- map["name_subject"]
        timeStart <- map["time_start"]
        mark <- map["mark"]
        comment <- map["comm"]
        date <- map["date"]
               
    }
    
}
