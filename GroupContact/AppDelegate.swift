import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 获取UIStoryboard实例
        let uiStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        // 获取NSUserDefaults实例
        let defaults = NSUserDefaults.standardUserDefaults()
        // 读取配置，用户是否已经登录
        let uid = defaults.valueForKey("uid") as? NSNumber
        if uid == nil {
            // 如果未登录, 则进入登录/注册页面
            window?.rootViewController = uiStoryboard.instantiateViewControllerWithIdentifier("Auth") as? UIViewController
        } else {
            // 初始化数据
            Var.initVar()
            // 如果已登录, 则进入主页面
            window?.rootViewController = uiStoryboard.instantiateViewControllerWithIdentifier("Main") as? UIViewController
            // 并初始化数据
            Var.uid = uid!.unsignedLongLongValue
        }
        return true
    }

}

