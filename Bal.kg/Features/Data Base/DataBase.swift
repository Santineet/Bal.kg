//
//  DataBase.swift
//  Bal.kg
//
//  Created by Mairambek on 9/18/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import RealmSwift

class DataBase: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var status = 0
    @objc dynamic var image: Data? = nil
//    @objc dynamic var imageName: String? = nil
//    @objc dynamic var time = ""

}

