import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - 应用初始化
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 初始化数据
        Var.initVar()
        // 获取UIStoryboard实例
        let uiStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        // 检查应用程序状态
        if Var.uid == 0 {
            // 如果未登录, 则进入登录/注册页面
            window?.rootViewController = uiStoryboard.instantiateViewControllerWithIdentifier("Auth") as? UIViewController
        } else {
            // 如果已登录, 则进入主页面
            window?.rootViewController = uiStoryboard.instantiateViewControllerWithIdentifier("Main") as? UIViewController
        }
        return true
    }
}

