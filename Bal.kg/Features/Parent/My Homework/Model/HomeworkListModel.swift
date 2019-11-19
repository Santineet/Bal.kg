//
//  HomeworkListModel.swift
//  Bal.kg
//
//  Created by Mairambek on 11/15/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import ObjectMapper

class HomeworkListModel: NSObject, Mappable {
    
    var homework: String = ""
    var date: String = ""
    var className: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        homework <- map["homework"]
        date <- map["date"]
        className <- map["class"]

    }
    
}
