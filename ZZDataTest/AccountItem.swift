//
//  AccountItem.swift
//  ZZDataTest
//
//  Created by zry on 2019/11/19.
//  Copyright © 2019 ZRY. All rights reserved.
//

import Foundation

class AccountItem:NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(password, forKey: "password")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as! String
        name = coder.decodeObject(forKey: "name") as! String
        password = coder.decodeObject(forKey: "password") as! String
    }
    
    var id :String
    var name:String
    var password:String
    
    init(id:String,name:String,password:String) {
        self.id = id
        self.name = name
        self.password = password
    }
    
    
}
