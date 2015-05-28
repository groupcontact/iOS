import Foundation

/*
 * 结果响应
 */
struct GeneralAO: JSONConvertable {
    
    // 状态码
    var status: Int
    // ID信息, 如果有的话
    var id: Int64?
    // 错误信息, 如果有的话
    var info: String?
    
    // 转成JSON字符串
    func toJSON() -> String {
        var dict = [String: AnyObject]()
        dict["status"] = status
        if id != nil {
            dict["id"] = NSNumber(longLong: id!)
        }
        if info != nil {
            dict["info"] = info!
        }
        return JSON(dict).toString(pretty: true)
    }
    
    // 从JSON字符串中生成对象
    static func fromJSON(string: String) -> JSONConvertable {
        return fromJSON(JSON(string: string))
    }
    
    // 从JSON对象中生成对象
    static func fromJSON(json: JSON) -> JSONConvertable {
        return GeneralAO(status: json["status"].asInt!,
            id: json["id"].asInt64,
            info: json["info"].asString)
    }
}
