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
    class func createUserWith(phone: String, password: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users"
        HttpUtil.post(url, parameters: ["phone" : phone, "password": AESCrypt.encrypt(password, password: Let.KEY)]) {
            var status = $0["status"]
            var id = $0["id"]
            var info = $0["info"]
            var result = GeneralAO(status: -1, id: 0, info: "")
            if status != nil {
                result.status = Int(status.double!)
            }
            if id != nil {
                result.id = UInt64(id.double!)
            }
            if info != nil {
                result.info = info.stringValue
            }
            callback(result)
        }
    }
    
    // 保存用户信息
    class func save(user: UserAO, password: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/\(user.uid!)"
        HttpUtil.put(url, parameters: [
            "name": user.name,
            "phone": user.phone,
            "ext": user.ext,
            "password": AESCrypt.encrypt(password, password: Let.KEY)
            ]) {
                var status = $0["status"]
                var id = $0["id"]
                var info = $0["info"]
                var result = GeneralAO(status: -1, id: 0, info: "")
                if status != nil {
                    result.status = Int(status.double!)
                }
                if id != nil {
                    result.id = UInt64(id.double!)
                }
                if info != nil {
                    result.info = info.stringValue
                }
                callback(result)
        }
    }
    
    // 列举用户加入的群组
    class func groupsJoinedBy(uid: UInt64, callback: ([GroupAO]) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/groups"
        HttpUtil.get(url) {
            var groups = [GroupAO]()
            for (_, jo) in $0 {
                groups.append(GroupAO(gid: UInt64(jo["id"].double!), name: jo["name"].stringValue, desc: jo["desc"].stringValue))
            }
            callback(groups)
        }
    }
    
    // 加入给定的群组
    class func join(uid: UInt64, password: String, gid: UInt64, accessToken: String, callback: (GeneralAO) -> ()) {
        
    }
    
    // 退出给定的群组
    class func leave(uid: UInt64, password: String, gid: UInt64, callback: (GeneralAO) -> ()) {
        
    }
    
    // 列举用户添加的好友
    class func friendsAddedBy(uid: UInt64, callback: ([UserAO]) -> ()) {
        let url = "\(Let.BASE_URL)users/\(uid)/friends"
        HttpUtil.get(url) {
            var friends = [UserAO]()
            for (_, jo) in $0 {
                friends.append(UserAO(uid: UInt64(jo["id"].double!), name: jo["name"].stringValue, phone: jo["phone"].stringValue, ext: jo["ext"].stringValue))
            }
            callback(friends)
        }
    }
    
    // add a new friend
    class func addFriend(uid: UInt64, password: String, name: String, phone: String, callback: (GeneralAO) -> ()) {
        
    }
    
    // delete friend
    class func deleteFriend(uid: UInt64, password: String, fid: UInt64, callback: (GeneralAO) -> ()) {
        
    }
    
    // retrieve the user information
    class func find(uid: UInt64, callback: ([UserAO]) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)"
        HttpUtil.get(url) {
            var users = [UserAO]()
            for (_, jo) in $0 {
                users.append(UserAO(uid: UInt64(jo["id"].double!), name: jo["name"].stringValue, phone: jo["phone"].stringValue, ext: jo["ext"].stringValue))
            }
            callback(users)
        }
    }
    
    // reset the password
    class func resetPassword(uid: UInt64, password: String, newPassword: String, callback: (GeneralAO) -> ()) {
        
    }
}
