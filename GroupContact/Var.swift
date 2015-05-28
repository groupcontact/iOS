import Foundation

/*
 * 1. 存储程序运行时的变量, 避免经常去读NSUserDefaults.
 * 2. 存储程序运行时的数据, 避免经常去读文件
 *
 * 此处存储的变量的值必须时刻保持与NSUserDefaults中的值一致
 * 此处存储的数据的值必须时刻保持与文件中的值一致
 */
struct Var {
    
    // 程式的Key/Value存储区域
    private static let userDefaults = NSUserDefaults.standardUserDefaults()
    // 文件管理器
    private static let fileManager = NSFileManager.defaultManager()
    
    // 用户的id
    static var uid = UInt64(0) {
        didSet {
            // 写入NSUserDefaults
            if oldValue != uid {
                userDefaults.setValue(NSNumber(unsignedLongLong: uid), forKey: "uid")
                userDefaults.synchronize()
            }
        }
    }
    
    // 用户的姓名
    static var name: String = "" {
        didSet {
            // 写入NSUserDefaults
            if oldValue != name {
                userDefaults.setValue(name, forKey: "name")
                userDefaults.synchronize()
            }
        }
    }
    
    // 用户的密码
    static var password: String = "" {
        didSet {
            // 写入NSUserDefaults
            if oldValue != password {
                userDefaults.setValue(password, forKey: "password")
                userDefaults.synchronize()
            }
        }
    }
    
    // 用户的完整信息
    static var user: UserAO? {
        didSet {
            // 第一次从文件初始化
            if oldValue == nil {
                return
            }
            // 写入缓存文件
            let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
                inDomains: NSSearchPathDomainMask.UserDomainMask)
            if urls.count > 0 {
                let cachePath = (urls[0] as! NSURL).URLString
                let path = cachePath + "profile.s"
                var error: NSError?
                // 将user转换成JSON字符串
                let userJSON = "HelloWorld"
                let succeeded = userJSON.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
                if !succeeded {
                    if let theError = error {
                        println("Could not save user to file. Error = \(theError)")
                    }
                }
                
            }
        }
    }
    
    // 好友列表信息
    static var friends: [UserAO]? {
        didSet {
            // 第一次从文件初始化
            if oldValue == nil {
                return
            }
            // 写入缓存文件
            let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
                inDomains: NSSearchPathDomainMask.UserDomainMask)
            if urls.count > 0 {
                let cachePath = (urls[0] as! NSURL).URLString
                let path = cachePath + "friends.s"
                var error: NSError?
                // 将friends转换成JSON字符串
                let friendsJSON = "HelloWorld"
                let succeeded = friendsJSON.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
                if !succeeded {
                    if let theError = error {
                        println("Could not save friends to file. Error = \(theError)")
                    }
                }
            }

        }
    }
    
    // 群组列表信息
    static var groups: [GroupAO]? {
        didSet {
            // 第一次从文件初始化
            if oldValue == nil {
                return
            }
            // 写入缓存文件
            let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
                inDomains: NSSearchPathDomainMask.UserDomainMask)
            if urls.count > 0 {
                let cachePath = (urls[0] as! NSURL).URLString
                let path = cachePath + "groups.s"
                var error: NSError?
                // 将groups转换成JSON字符串
                let groupsJSON = "HelloWorld"
                let succeeded = groupsJSON.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
                if !succeeded {
                    if let theError = error {
                        println("Could not save groups to file. Error = \(theError)")
                    }
                }
                
            }
        }
    }
    
    // 初始化数据, 包括user, friends和groups
    static func initVar() {
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        if urls.count > 0 {
            let cachePath = (urls[0] as! NSURL).URLString
            // 读取user信息
            let userPath = cachePath + "profile.s"
            if let userJSON = NSString(contentsOfFile: userPath, encoding: NSUTF8StringEncoding
                , error: nil) as? String {
                // 将其转换成UserAO对象
            } else {
                // 默认是一个无手机号, 无扩展信息的用户
                user = UserAO(uid: Var.uid, name: Var.name, phone: "", ext: "{}")
            }
            // 读取friends信息
            let friendsPath = cachePath + "friends.s"
            if let friendsJSON = NSString(contentsOfFile: friendsPath, encoding: NSUTF8StringEncoding
                , error: nil) as? String {
                // 将其转换成[UserAO]对象
            } else {
                // 默认是空的好友列表
                friends = [UserAO]()
            }
            // 读取groups信息
            let groupsPath = cachePath + "groups.s"
            if let groupsJSON = NSString(contentsOfFile: groupsPath, encoding: NSUTF8StringEncoding
                , error: nil) as? String {
                // 将其转换成[GroupAO]对象
            } else {
                // 默认是空的群组列表
                groups = [GroupAO]()
            }
        }
    }
}
