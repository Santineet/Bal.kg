//
//  SubjectsModel.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import ObjectMapper

class SubjectsModel: NSObject, Mappable {
    
    var id: String = ""
    var nameSubject: String = ""
    var timeStart: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        nameSubject <- map["name_subject"]
        timeStart <- map["time_start"]

    }
    
}
