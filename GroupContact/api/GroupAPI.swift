import Foundation

/*
 * 群组相关API
 *
 * @author: 周海兵
 */
class GroupAPI {
    
    /*
     * 创建群组
     *
     * @uid: 用户ID
     * @password: 用户ID对应的密码
     * @group: 要创建的群组对象信息
     * @callback: 处理返回结果的回调函数
     */
    class func createGroup(uid: Int64, password: String, group: GroupAO, accessToken: String, modifyToken: String, callback: (result: GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/groups"
        Req.post(url, parameters: [
            "name": group.name,
            "desc": group.desc,
            "accessToken": AESCrypt.encrypt(accessToken, password: Let.KEY),
            "modifyToken": AESCrypt.encrypt(modifyToken, password: Let.KEY),
            "uid": NSNumber(longLong: uid),
            "password": AESCrypt.encrypt(password, password: Let.KEY)
            ]) {
                Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 列举群组中的成员
     *
     * @gid: 群组ID
     * @callback: 处理返回结果的回调函数
     */
    class func listMember(gid: Int64, callback: ([String: [UserAO]]) -> ()) {
        let url = "\(Let.BASE_URL)/groups/\(gid)/members2"
        Req.get(url) {
            Handler.USER_DATA_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 搜索群组
     *
     * @name: 搜索的关键词
     */
    class func search(name: String, callback: (result: [GroupAO]) -> ()) {
        let searchKey = name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let url = "\(Let.BASE_URL)/groups?name=\(searchKey!)"
        Req.get(url) {
            Handler.GROUP_LIST_HANDLER($0, cb: callback)
        }
    }
}