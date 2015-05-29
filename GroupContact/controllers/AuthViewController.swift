import UIKit

/*
 * 登录和注册页面, 此处需要创建一个用户实例
 */
class AuthViewController: UIViewController {

    @IBOutlet weak var loginPhoneView: UITextField!
    
    @IBOutlet weak var loginPasswordView: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerPhoneView: UITextField!
    
    @IBOutlet weak var registerPasswordView: UITextField!
    
    @IBOutlet weak var registerNameView: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var registerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 第一屏为登录屏
        registerView.hidden = true
    }
    
    
    // 当选择了不同的Segment
    @IBAction func changeScene(sender: UISegmentedControl) {
        // 选择了登录
        if sender.selectedSegmentIndex == 0 {
            registerView.hidden = true
        }
        // 选择了注册
        else if sender.selectedSegmentIndex == 1 {
            registerView.hidden = false
        }
    }
    
    // 登录动作
    @IBAction func login(sender: UIButton) {
        // 输入的值
        var phone = loginPhoneView.text
        var password = loginPasswordView.text
        // 禁止输入
        disableAll4Login()
        // 显示进度条
        var hud = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
        hud.labelText = "登录中"
        UserAPI.register(phone, password: password) {
            result in
            // 登录成功
            if result.status == 2 {
                hud.hidden = true
                hud = nil
                
                self.success(result.id!, password: password)
            }
            // 该账号已存在, 但是未设置姓名
            else  {
                hud.labelText = "登录失败"
                hud.hide(true, afterDelay: 1.5)
                hud = nil
                
                self.enableAll4Login()
            }
        }
    }
    
    // 注册动作
    @IBAction func register(sender: UIButton) {
        var phone = registerPhoneView.text
        var password = registerPasswordView.text
        var name = registerNameView.text
        
        disableAll4Register()
        
        var hud = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
        hud.labelText = "注册中"
        UserAPI.register(phone, password: password) {
            result in
            // 注册成功
            if result.status == 2 {
                hud.hidden = true
                hud = nil
            
                self.success(result.id!, password: password)
            }
            // 需要保存名字
            else if result.status == 1 {
                var user = UserAO(uid: result.id, name: name, phone: phone, ext: "{}")
                UserAPI.save(user, password: password) {
                    result in
                    if (result.status == 1) {
                        self.success(user.uid!, password: password)
                    } else {
                        hud.labelText = "注册失败"
                        hud.hide(true, afterDelay: 1.5)
                        hud = nil
                        
                        self.enableAll4Register()
                    }
                }
            }
            // 注册失败
            else {
                hud.labelText = "注册失败"
                hud.hide(true, afterDelay: 1.5)
                hud = nil
                
                self.enableAll4Register()
            }
        }

    }
    
    func success(uid: Int64, password: String) {
        UserAPI.find(uid) {
            if let user = $0 {
                Var.uid = uid
                Var.password = password
                Var.name = user.name
                Var.user = user
            }
        }
    }
    
    // enable登录界面的所有输入控件
    func enableAll4Login() {
        loginPhoneView.enabled = true
        loginPasswordView.enabled = true
        loginButton.enabled = true
    }
    
    // disable登录界面的所有输入控件
    func disableAll4Login() {
        loginPhoneView.enabled = false
        loginPasswordView.enabled = false
        loginButton.enabled = false
    }
    
    // enable登录界面的所有输入控件
    func enableAll4Register() {
        registerPhoneView.enabled = true
        registerPasswordView.enabled = true
        registerNameView.enabled = true
        registerButton.enabled = true
    }
    
    // disable注册页面的所有输入控件
    func disableAll4Register() {
        registerPhoneView.enabled = false
        registerPasswordView.enabled = false
        registerNameView.enabled = false
        registerButton.enabled = false
    }
}
