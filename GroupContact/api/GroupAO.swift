import Foundation

/*
 * 群组对象
 */
struct GroupAO: JSONConvertable {
    
    // 群组ID
    var gid: Int64?
    // 群组名字
    var name: String
    // 群组描述
    var desc: String
    
    // 转成JSON字符串
    func toJSON() -> String {
        var dict = [String: AnyObject]()
        if let id = gid {
            dict["gid"] = NSNumber(longLong: gid!)
        }
        dict["name"] = name
        dict["desc"] = desc
        
        return JSON(dict).toString(pretty: true)
    }
    
    // 从JSON字符串中生成对象
    static func fromJSON(string: String) -> JSONConvertable {
        return fromJSON(JSON(string: string))
    }
    
    // 从JSON对象中生成对象
    static func fromJSON(json: JSON) -> JSONConvertable {
        return GroupAO(gid: json["gid"].asInt64,
            name: json["name"].asString!,
            desc: json["desc"].asString!)
    }
}