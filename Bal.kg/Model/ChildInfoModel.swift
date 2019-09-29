//
//  ChildsInfoModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/29/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class ChildInfoModel: NSObject, Mappable {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var secondName: String = ""
    var parent_1: String = ""
    var parent_2: String = ""
    var phone: String = ""
    var status: String = ""
    var child_class: String = ""
    var school: String = ""
    var image: String = ""
    var move_about: String = ""
    var move_status: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        secondName <- map["second_name"]
        parent_1 <- map["parent_1"]
        parent_2 <- map["parent_2"]
        phone <- map["phone"]
        status <- map["status"]
        child_class <- map["class"]
        school <- map["school"]
        image <- map["img"]
        move_about <- map["move_about"]
        move_status <- map["move_status"]

    }
    
}
