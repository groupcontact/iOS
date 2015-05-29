import Foundation

/*
 * 关于群组API的封装
 */
class GroupAPI {
    
    // 创建群组
    class func createGroupWith(uid: Int64, password: String, group: GroupAO, callback: (result: GeneralAO) -> ()) {
        
    }
    
    // 列举群组中的成员
    class func listMember(gid: Int64, callback: ([UserAO]) -> ()) {
        let url = "\(Let.BASE_URL)/groups/\(gid)/members"
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
    
    // 列举群组中的成员(姓名分组后的)
    class func listMember2(gid: Int64, callback: ([String: [UserAO]]) -> ()) {
        let url = "\(Let.BASE_URL)/groups/\(gid)/members2"
        Req.get(url) {
            // 结果数据
            var result = [String: [UserAO]]()
            if let json = $0 {
                for (i, v) in json {
                    var key = i as! String
                    var users = [UserAO]()
                    for (_, jsonUser) in v {
                        users.append(UserAO.fromJSON(jsonUser) as! UserAO)
                    }
                    result[key] = users
                }
            }
            callback(result)
        }
    }
    
    // 搜索群组
    class func searchBy(name: String, callback: (result: [GroupAO]) -> ()) {
        
    }
    
}