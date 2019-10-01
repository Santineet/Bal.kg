//
//  NotificationModel.swift
//  Bal.kg
//
//  Created by Mairambek on 10/1/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationModel: NSObject, Mappable {
    
    var about: String = ""
    var date: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        about <- map["about"]
        date <- map["date"]
        
    }
    
}
