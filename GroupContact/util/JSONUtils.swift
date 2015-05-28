import Foundation

/*
 * 表示一个对象可以表示成JSON字符串, 也可以从JSON字符串中恢复
 */
protocol JSONConvertable {
    
    func toJSON() -> String
    
    static func fromJSON(string: String) -> JSONConvertable
    
    static func fromJSON(json: JSON) -> JSONConvertable
}

/*
 * 关于JSON的一些辅助方法
 */
struct JSONUtils {
    
    // 转换成JSONArray的字符串
    static func toJSONArray(targets: [JSONConvertable]) -> String {
        var result = "[";
        var count = targets.count
        for var i = 0; i < count; ++i {
            let target = targets[i]
            result += target.toJSON()
            if i == (count - 1) {
                // 最后一个
                result += "]"
                break
            } else {
                result += ","
            }
        }
        return result
    }
    
    // 从JSONArray字符串转成JSONConvertable列表
    static func fromJSONArray(arrayString: String) -> [JSONConvertable] {
        var result = [JSONConvertable]()
        let arrayJSON = JSON(string: arrayString)
        for (_, json) in arrayJSON {
            // 只有GeneralAO有status字段
            if let status = json["status"].asInt {
                result.append(GeneralAO.fromJSON(json))
            }
            // 只有UserAO有phone字段
            else if let phone = json["phone"].asString {
                result.append(UserAO.fromJSON(json))
            }
            // 只有GroupAO有desc字段
            else if let desc = json["desc"].asString {
                result.append(GroupAO.fromJSON(json))
            }
        }
        return result
    }
}