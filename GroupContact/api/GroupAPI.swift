//
//  GroupAPI.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/28/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import Foundation

class GroupAPI {
    
    // create group by the specified user
    class func createGroupWith(uid: UInt64, password: String, group: GroupAO, callback: (result: GeneralAO) -> ()) {
        
    }
    
    // list the members in the given group
    class func membersIn(gid: UInt64, callback: ([UserAO]) -> ()) {
        HttpUtil.get("\(Let.BASE_URL)groups/\(gid)/members") {
            var members = [UserAO]()
            for (_, jo) in $0 {
                members.append(UserAO(uid: UInt64(jo["id"].double!), name: jo["name"].stringValue, phone: jo["phone"].stringValue, ext: jo["ext"].stringValue))
            }
            callback(members)
        }
    }
    
    // search group by name
    class func searchBy(name: String, callback: (result: [GroupAO]) -> ()) {
        
    }
    
}