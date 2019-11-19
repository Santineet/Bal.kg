//
//  File.swift
//  Bal.kg
//
//  Created by Mairambek on 9/27/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class MyChildrensModel: NSObject, Mappable {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var secondName: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        secondName <- map["second_name"]

    }
    
}
