//
//  ClassesModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class ClassesModel: NSObject, Mappable {
    
    var id: String = ""
    var name: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}
