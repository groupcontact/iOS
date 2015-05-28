//
//  UserAPI.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/28/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import Foundation
import Alamofire

class UserAPI {
    
    // 创建用户
    class func register(phone: String, password: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users"
        Req.post(url, parameters: ["phone" : phone, "password": AESCrypt.encrypt(password, password: Let.KEY)]) {
            if let json = $0 {
                callback(GeneralAO.fromJSON(json) as! GeneralAO)
            }
        }
    }
    
    // 保存用户信息
    class func save(user: UserAO, password: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/\(user.uid!)"
//        Req.put(url, parameters: [
//            "name": user.name,
//            "phone": user.phone,
//            "ext": user.ext,
//            "password": AESCrypt.encrypt(password, password: Let.KEY)
//            ]) {
//                var status = $0["status"]
//                var id = $0["id"]
//                var info = $0["info"]
//                var result = GeneralAO(status: -1, id: 0, info: "")
//                if status != nil {
//                    result.status = Int(status.double!)
//                }
//                if id != nil {
//                    result.id = UInt64(id.double!)
//                }
//                if info != nil {
//                    result.info = info.stringValue
//                }
//                callback(result)
//        }
    }
    
    // 列举用户加入的群组
    class func listGroup(uid: Int64, callback: ([GroupAO]) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/groups"
        Req.get(url) {
            var result = [GroupAO]()
            if let json = $0 {
                for (i, v) in json {
                    result.append(GroupAO.fromJSON(v) as! GroupAO)
                }
            }
            callback(result)
        }
    }
    
    // 加入给定的群组
    class func join(uid: Int64, password: String, gid: Int64, accessToken: String, callback: (GeneralAO) -> ()) {
        
    }
    
    // 退出给定的群组
    class func leave(uid: Int64, password: String, gid: Int64, callback: (GeneralAO) -> ()) {
        
    }
    
    // 列举用户添加的好友
    class func listFriend(uid: Int64, callback: ([UserAO]) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/friends"
        Req.get(url) {
            var result = [UserAO]()
            if let json = $0 {
                for (i, v) in json {
                    result.append(UserAO.fromJSON(v) as! UserAO)
                }
            }
            callback(result)
        }
    }
    
    // add a new friend
    class func addFriend(uid: Int64, password: String, name: String, phone: String, callback: (GeneralAO) -> ()) {
        
    }
    
    // delete friend
    class func deleteFriend(uid: Int64, password: String, fid: Int64, callback: (GeneralAO) -> ()) {
        
    }
    
    // 查询给定用户ID的信息
    class func find(uid: Int64, callback: (UserAO) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)"
        Req.get(url) {
            if let json = $0 {
                if json.length == 1 {
                    callback(UserAO.fromJSON(json[0]) as! UserAO)
                }
            }
        }
        
    }
    
    // reset the password
    class func resetPassword(uid: Int64, password: String, newPassword: String, callback: (GeneralAO) -> ()) {
        
    }
}
