//
//  Subjects_list.swift
//  Bal.kg
//
//  Created by Mairambek on 10/1/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class SubjectsListModel: NSObject, Mappable {
    
    var id: String = ""
    var name_subject: String = ""
    var time_start: String = ""
    var homework: String = ""
    var date: String = ""
    var className: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name_subject <- map["name_subject"]
        time_start <- map["time_start"]
        homework <- map["homework"]
        date <- map["date"]

    }
    
}
