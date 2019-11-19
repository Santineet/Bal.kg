//
//  MyMarksModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class MyMarksModel: NSObject, Mappable {
    
    var part: String = ""
    var mark: String = ""
    var comment: String = ""
    var type_mark: String = ""
    var date: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        part <- map["part"]
        mark <- map["mark"]
        comment <- map["comm"]
        type_mark <- map["type_mark"]
        date <- map["date"]

    }
    
}
