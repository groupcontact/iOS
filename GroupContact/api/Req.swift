import Foundation
import Alamofire

/*
 * 对于Request的简单封装, 包括发送get, post, put和delete请求, 所有请求返回的数据都是JSON格式, 并且对于get请求需要
 * 进行先解密
 */
class Req {
    
    // GET请求
    class func get(url: String, cb: (result: JSON?) -> ()) {
        Alamofire.request(.GET, url).responseString {
            (_, _, string, _) in
            // 如果没有数据返回
            if string == nil {
                cb(result: nil)
            } else {
                // 先解密
                let decrypted = AESCrypt.decrypt(string, password: Let.KEY)
                // 转成JSON                
                cb(result: JSON(string: decrypted))
            }
        }
    }
    
    // POST请求
    class func post(url: String, parameters: [String: AnyObject], cb: (JSON?) -> ()) {
        Alamofire.request(.POST, url, parameters: parameters).responseString {
            (_, _, string, _) in
            // 如果没有数据返回
            if string == nil {
                cb(nil)
            } else {
                // 转成JSON
                cb(JSON(string: string!))
            }
        }
    }
    
    // PUT请求
    class func put(url: String, parameters: [String: AnyObject], cb: (result: JSON?) -> ()) {
        Alamofire.request(.PUT, url, parameters: parameters).responseString {
            (_, _, string, _) in
            // 如果没有数据返回
            if string == nil {
                cb(result: nil)
            } else {
                // 转成JSON
                cb(result: JSON(string: string!))
            }
        }
    }
    
    // DELETE请求
    class func delete(url: String, cb: (result: JSON?) -> ()) {
        Alamofire.request(.GET, url).responseString {
            (_, _, string, _) in
            // 如果没有数据返回
            if string == nil {
                cb(result: nil)
            } else {
                // 转成JSON
                cb(result: JSON(string: string!))
            }
        }
    }
}
