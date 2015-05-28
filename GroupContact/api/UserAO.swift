import Foundation

/*
 * 用户对象
 */
struct UserAO: JSONConvertable {
    
    // 用户ID
    var uid: Int64?
    // 用户名字
    var name: String
    // 用户的手机号
    var phone: String
    // 用户的扩展信息
    var ext: String
    
    // 转成JSON字符串
    func toJSON() -> String {
        var dict = [String: AnyObject]()
        if let id = uid {
            dict["id"] = NSNumber(longLong: uid!)
        }
        dict["name"] = name
        dict["phone"] = phone
        dict["ext"] = ext
        return JSON(dict).toString(pretty: true)
    }
    
    // 从JSON字符串中生成对象
    static func fromJSON(string: String) -> JSONConvertable {
        return fromJSON(JSON(string: string))
    }
    
    // 从JSON对象中生成对象
    static func fromJSON(json: JSON) -> JSONConvertable {
        return UserAO(uid: json["id"].asInt64,
            name: json["name"].asString!,
            phone: json["phone"].asString!,
            ext: json["ext"].asString!)
    }
}