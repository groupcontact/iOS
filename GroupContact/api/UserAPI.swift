import Foundation

/*
 * 用户相关API
 *
 * @author: 周海兵
 */
class UserAPI {
    
    /*
     * 创建用户
     *
     * @phone: 手机号
     * @password: 密码
     * @callback: 处理返回结果的回调函数
     */
    class func register(phone: String, password: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users"
        Req.post(url, parameters: [
            "phone" : phone,
            "password": AESCrypt.encrypt(password, password: Let.KEY)
            ]) {
                Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 保存用户信息
     *
     * @user: 用户对象, 总是做全量保存
     * @password: 用户的密码
     * @callback: 处理返回结果的回调函数
     */
    class func save(user: UserAO, password: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(user.uid!)"
        Req.put(url, parameters: [
            "name": user.name,
            "phone": user.phone,
            "ext": user.ext,
            "password": AESCrypt.encrypt(password, password: Let.KEY)
            ]) {
                Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 列举用户加入的群组
     *
     * @uid: 用户ID
     * @callback: 处理返回结果的回调函数
     */
    class func listGroup(uid: Int64, callback: ([GroupAO]) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/groups"
        Req.get(url) {
            Handler.GROUP_LIST_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 加入新的群组
     *
     * @uid: 用户ID
     * @password: 用户ID对应密码
     * @gid: 群组ID
     * @accessToken: 群组ID对应访问密码
     * @callback: 处理返回结果的回调函数
     */
    class func join(uid: Int64, password: String, gid: Int64, accessToken: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/groups"
        Req.post(url, parameters: [
            "password": AESCrypt.encrypt(password, password: Let.KEY),
            "gid": NSNumber(longLong: gid),
            "accessToken": AESCrypt.encrypt(accessToken, password: Let.KEY)
            ]) {
                Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 退出已经加入的群组
     *
     * @uid: 用户ID
     * @password: 用户对应的密码
     * @gid: 群组ID
     * @callback: 处理返回结果的回调函数
     */
    class func leave(uid: Int64, password: String, gid: Int64, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/groups?gid=\(gid)&password=\(AESCrypt.encrypt(password, password: Let.KEY))"
        Req.delete(url) {
            Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 列举用户添加的好友
     *
     * @uid: 用户ID
     * @callback: 处理返回结果的回调函数
     */
    class func listFriend(uid: Int64, callback: ([String: [UserAO]]) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/friends2"
        Req.get(url) {
            Handler.USER_DATA_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 添加用户为好友
     *
     * @uid: 用户ID
     * @password: 用户对应的密码
     * @name: 好友的姓名
     * @phone: 好友的手机号
     * @callback: 处理返回结果的回调函数
     */
    class func addFriend(uid: Int64, password: String, name: String, phone: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/friends"
        Req.post(url, parameters: [
            "password": AESCrypt.encrypt(password, password: Let.KEY),
            "name": name,
            "phone": phone
            ]) {
                Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 删除好友关系
     *
     * @uid: 用户ID
     * @password: 用户对应的密码
     * @fid: 好友的用户ID
     * @callback: 处理返回结果的回调函数
     */
    class func deleteFriend(uid: Int64, password: String, fid: Int64, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/friends?fid=\(fid)&password=\(AESCrypt.encrypt(password, password: Let.KEY))"
        Req.delete(url) {
            Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 查询指定用户ID的用户信息
     *
     * @uid: 用户ID
     * @callback: 处理返回结果的回调函数
     */
    class func find(uid: Int64, callback: (UserAO?) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)"
        Req.get(url) {
            Handler.USER_HANDLER($0, cb: callback)
        }
    }
    
    /*
     * 重新设置密码
     *
     * @uid: 用户ID
     * @password: 用户ID对应的密码
     * @newPassword: 需要设置的新密码
     * @callback: 处理返回结果的回调函数
     */
    class func resetPassword(uid: Int64, password: String, newPassword: String, callback: (GeneralAO) -> ()) {
        let url = "\(Let.BASE_URL)/users/\(uid)/password"
        Req.put(url, parameters:[
            "password": AESCrypt.encrypt(password, password: Let.KEY),
            "newpassword": AESCrypt.encrypt(newPassword, password: Let.KEY)
            ]) {
                Handler.GENERAL_HANDLER($0, cb: callback)
        }
    }
}
