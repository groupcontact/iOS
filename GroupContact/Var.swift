//
//  Var.swift
//  GroupContact
//
//  Created by Haibing Zhou on 5/2/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import Foundation

struct Var {
    
    static var uid = UInt64(5)
    
    static var name: String = "周海兵"
    
    static var password: String = "199311"
    
    static var user = UserAO(uid: Var.uid, name: Var.name, phone: "18205082827", ext: "{\"email\": \"877498144@qq.com\", \"wechat\": \"zhouhaibing089\"}")
    
}
