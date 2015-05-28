//
//  BaseAPImpl.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/29/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import Foundation
import Alamofire

class HttpUtil {
    
    class func get(url: String, cb: (result: JSON) -> ()) {
        Alamofire.request(.GET, url).responseString {
            (_, _, string, _) in
            if string == nil {
                cb(result: nil)
            } else {
                let decrypted = AESCrypt.decrypt(string, password: Let.KEY)
                let json = JSON(data: decrypted.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                cb(result: json)
            }
        }
    }
    
    class func post(url: String, parameters: [String: String], cb: (result: JSON) -> ()) {
        Alamofire.request(.POST, url, parameters: parameters).responseString {
            (_, _, string, _) in
            if string == nil {
                cb(result: nil)
            } else {
                let json = JSON(data: string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                cb(result: json)
            }
        }
    }
    
    class func put(url: String, parameters: [String: String], cb: (result: JSON) -> ()) {
        Alamofire.request(.PUT, url, parameters: parameters).responseString {
            (_, _, string, _) in
            if string == nil {
                cb(result: nil)
            } else {
                let json = JSON(data: string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
                cb(result: json)
            }
        }
    }
}
