//
//  LoginModel.swift
//  Bal.kg
//
//  Created by Mairambek on 10/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class LogInModel: NSObject, Mappable {
    
    var status: String = ""
    var message: String = ""
    var token: String = ""
    var userType: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        token <- map["token"]
        message <- map["mess"]
        status <- map["status"]
        userType <- map["user_type"]

    }
    
}
