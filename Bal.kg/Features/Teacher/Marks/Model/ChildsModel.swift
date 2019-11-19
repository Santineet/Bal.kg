//
//  ChildrensModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/23/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class ChildsModel: NSObject, Mappable {
    
    var id: String = ""
    var fio: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        fio <- map["fio"]
    }
    
}
