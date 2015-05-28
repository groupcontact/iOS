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
    private static let defaults = NSUserDefaults.standardUserDefaults()
    // 文件管理器
    private static let fileManager = NSFileManager.defaultManager()
    // 是否已经初始化好了
    private static var initialized = false
    
    // 用户的id
    static var uid = Int64(0) {
        didSet {
            if uid == 0 {
                return
            }
            // 还没初始化好
            if !initialized {
                return
            }
            // 写入NSUserDefaults
            if oldValue != uid {
                defaults.setValue(NSNumber(longLong: uid), forKey: "uid")
                defaults.synchronize()
            }
        }
    }
    
    // 用户的姓名
    static var name: String = "" {
        didSet {
            if name == "" {
                return
            }
            // 还没初始化好
            if !initialized {
                return
            }
            // 写入NSUserDefaults
            if oldValue != name {
                defaults.setValue(name, forKey: "name")
                defaults.synchronize()
            }
        }
    }
    
    // 用户的密码
    static var password: String = "" {
        didSet {
            if password == "" {
                return
            }
            // 还没初始化好
            if !initialized {
                return
            }
            // 写入NSUserDefaults
            if oldValue != password {
                defaults.setValue(password, forKey: "password")
                defaults.synchronize()
            }
        }
    }
    
    // 用户的完整信息
    static var user: UserAO? {
        didSet {
            // 没有用户就不写文件了
            if user == nil {
               return
            }
            // 还没初始化好
            if !initialized {
                return
            }
            // 写入缓存文件
            let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
                inDomains: NSSearchPathDomainMask.UserDomainMask)
            if urls.count > 0 {
                let cachePath = (urls[0] as! NSURL).path!
                fileManager.createDirectoryAtPath(cachePath, withIntermediateDirectories: true, attributes: nil, error: nil)
                let path = cachePath + "profile.s"
                var error: NSError?
                if !fileManager.fileExistsAtPath(path) {
                    fileManager.createFileAtPath(path, contents: nil, attributes: nil)
                }
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
    static var friends = [UserAO]() {
        didSet {
            // 没有数据就没必要写文件了
            if friends.count == 0 {
                return
            }
            // 还没初始化好
            if !initialized {
                return
            }
            // 写入缓存文件
            let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
                inDomains: NSSearchPathDomainMask.UserDomainMask)
            if urls.count > 0 {
                let cachePath = (urls[0] as! NSURL).path!
                let path = cachePath + "friends.s"
                var error: NSError?
                // 将friends转换成JSON字符串
                var targets = [JSONConvertable]()
                for user in friends {
                    targets.append(user)
                }
                let friendsJSON = JSONUtils.toJSONArray(targets)
                // 为什么不可以直接
                // let friendsJSON = JSONUtils.toJSONArray(friends)
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
    static var groups = [GroupAO]() {
        didSet {
            // 没有数据就没必要写文件了
            if groups.count == 0 {
                return
            }
            // 还没初始化好
            if !initialized {
                return
            }
            // 写入缓存文件
            let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
                inDomains: NSSearchPathDomainMask.UserDomainMask)
            if urls.count > 0 {
                let cachePath = (urls[0] as! NSURL).path!
                fileManager.createDirectoryAtPath(cachePath, withIntermediateDirectories: true, attributes: nil, error: nil)
                let path = cachePath + "groups.s"
                var error: NSError?
                if !fileManager.fileExistsAtPath(path) {
                    fileManager.createFileAtPath(path, contents: nil, attributes: nil)
                }
                // 将groups转换成JSON字符串
                var targets = [JSONConvertable]()
                for group in groups {
                    targets.append(group)
                }
                let groupsJSON = JSONUtils.toJSONArray(targets)
                let succeeded = groupsJSON.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
                if !succeeded {
                    if let theError = error {
                        println("Could not save groups to file. Error = \(theError)")
                    }
                }
            }
        }
    }
    
    // 初始化数据
    static func initVar() {
        // 从NSUserDefaults中初始化数据
        if let localUid = defaults.valueForKey("uid") as? NSNumber {
            uid = localUid.longLongValue
        }
        if let localName = defaults.valueForKey("name") as? String {
            name = localName
        }
        if let localPassword = defaults.valueForKey("password") as? String {
            password = localPassword
        }
        // 从文件中初始化数据
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.CachesDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        if urls.count > 0 {
            let cachePath = (urls[0] as! NSURL).path!
            // 读取user信息
            let userPath = cachePath + "profile.s"
            if let userJSON = NSString(contentsOfFile: userPath, encoding: NSUTF8StringEncoding
                , error: nil) as? String {
                // 将其转换成UserAO对象
                user = UserAO.fromJSON(userJSON) as? UserAO
            }
            // 读取friends信息
            let friendsPath = cachePath + "friends.s"
            if let friendsJSON = NSString(contentsOfFile: friendsPath, encoding: NSUTF8StringEncoding
                , error: nil) as? String {
                // 将其转换成[UserAO]对象
                let targets = JSONUtils.fromJSONArray(friendsJSON)
                var localFriends = [UserAO]()
                for target in targets {
                    localFriends.append(target as! UserAO)
                }
                friends = localFriends
            }
            // 读取groups信息
            let groupsPath = cachePath + "groups.s"
            if let groupsJSON = NSString(contentsOfFile: groupsPath, encoding: NSUTF8StringEncoding
                , error: nil) as? String {
                // 将其转换成[GroupAO]对象
                let targets = JSONUtils.fromJSONArray(groupsJSON)
                var localGroups = [GroupAO]()
                for target in targets {
                    localGroups.append(target as! GroupAO)
                }
                groups = localGroups
            }
        }
        initialized = true
    }
}
