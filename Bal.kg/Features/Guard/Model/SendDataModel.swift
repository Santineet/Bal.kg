//
//  SendDataModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/16/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class SendDataModel: NSObject, Mappable {
    
    var status: String = ""
    var message: String = ""
    var fio: String = ""
    var about: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        fio <- map["fio"]
        message <- map["mess"]
        status <- map["status"]
        about <- map["about"]
    }
    
}
