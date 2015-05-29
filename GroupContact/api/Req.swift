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
            if let resp = string {
                Handler.JSON_HANDLER(AESCrypt.decrypt(resp, password: Let.KEY), cb: cb)
            } else {
                Handler.JSON_HANDLER(nil, cb: cb)
            }
        }
    }
    
    // POST请求
    class func post(url: String, parameters: [String: AnyObject], cb: (JSON?) -> ()) {
        Alamofire.request(.POST, url, parameters: parameters).responseString {
            (_, _, string, _) in
            Handler.JSON_HANDLER(string, cb: cb)
        }
    }
    
    // PUT请求
    class func put(url: String, parameters: [String: AnyObject], cb: (JSON?) -> ()) {
        Alamofire.request(.PUT, url, parameters: parameters).responseString {
            (_, _, string, _) in
            Handler.JSON_HANDLER(string, cb: cb)
        }
    }
    
    // DELETE请求
    class func delete(url: String, cb: (JSON?) -> ()) {
        Alamofire.request(.GET, url).responseString {
            (_, _, string, _) in
            Handler.JSON_HANDLER(string, cb: cb)
        }
    }
}
