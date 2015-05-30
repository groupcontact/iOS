import Foundation

struct ToastUtils {
    
    static func info(title: String, message: String?) {
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: message, type: TWMessageBarMessageType.Success,
            statusBarStyle: UIStatusBarStyle.Default, callback: nil)
    }
    
    static func error(title: String, message: String?) {
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: message, type: TWMessageBarMessageType.Error)
    }
}