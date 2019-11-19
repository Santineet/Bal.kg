//
//  HomeworkModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/24/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeworkModel: NSObject, Mappable {
    
    var status: String = ""
    var message: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["mess"]
    }
    
}
