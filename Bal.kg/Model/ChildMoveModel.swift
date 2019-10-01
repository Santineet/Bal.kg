//
//  ChildMoveModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class ChildMoveModel: NSObject, Mappable {
    
    var id: String = ""
    var about: String = ""
    var date: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        about <- map["about"]
        date <- map["date"]

    }
    
}
