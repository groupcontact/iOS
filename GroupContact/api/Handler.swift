import Foundation

struct Handler {
    
    /* 网络错误的GeneralAO */
    static let ERR_NET_GENERAL_AO = GeneralAO(status: -1, id: nil, info: "网络连接失败")
    
    /* 处理GeneralAO的函数 */
    static func GENERAL_HANDLER(resp: JSON?, cb: (GeneralAO) -> ()) {
        if let json = resp {
            let status = json["status"].asInt!
            let id = json["id"].asInt64
            let info = json["info"].asString
            cb(GeneralAO(status: status, id: id, info: info))
        } else {
            cb(ERR_NET_GENERAL_AO)
        }
    }
    
    /* 处理[String: [UserAO]]的函数 */
    static func USER_DATA_HANDLER(resp: JSON?, cb: ([String: [UserAO]]) -> ()) {
        var result = [String: [UserAO]]()
        if let json = resp {
            for (i, v) in json {
                var key = i as! String
                var users = [UserAO]()
                for (_, jsonUser) in v {
                    users.append(UserAO.fromJSON(jsonUser) as! UserAO)
                }
                result[key] = users
            }
        }
        cb(result)
    }
    
    /* 处理[GroupAO]的函数 */
    static func GROUP_LIST_HANDLER(resp: JSON?, cb: ([GroupAO]) -> ()) {
        var result = [GroupAO]()
        if let json = resp {
            for (i, v) in json {
                result.append(GroupAO.fromJSON(v) as! GroupAO)
            }
        }
        cb(result)
    }
    
    /* 处理UserAO的函数 */
    static func USER_HANDLER(resp: JSON?, cb: (UserAO?) -> ()) {
        if let json = resp {
            // 如果是数组
            if json.isArray {
                if json.length == 1 {
                    cb(UserAO.fromJSON(json[0]) as? UserAO)
                    return
                }
            } else {
                cb(UserAO.fromJSON(json) as? UserAO)
            }
        }
        cb(nil)
    }

    /* 处理JSON的函数 */
    static func JSON_HANDLER(resp: String?, cb: (JSON?) -> ()) {
        if let string = resp {
            cb(JSON(string: string))
        } else {
            cb(nil)
        }
    }
}