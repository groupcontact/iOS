import UIKit

/*
 * 登录和注册页面, 此处需要创建一个用户实例
 */
class AuthViewController: UIViewController {
    
    // MARK: - Outlet列表
    @IBOutlet weak var loginPhoneView: UITextField!
    
    @IBOutlet weak var loginPasswordView: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerPhoneView: UITextField!
    
    @IBOutlet weak var registerPasswordView: UITextField!
    
    @IBOutlet weak var registerNameView: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var registerView: UIView!
    
    // MARK: - Hud进度显示
    var hud: MBProgressHUD?
    
    // MARK: - 其他成员
    var login = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 第一屏为登录屏
        registerView.hidden = true
        
        // 初始化hud
        hud = MBProgressHUD(view: self.view)
    }
    
    // MARK: - Action方法
    /* 切换Segment */
    @IBAction func changeScene(sender: UISegmentedControl) {
        // 选择了登录
        if sender.selectedSegmentIndex == 0 {
            login = true
            registerView.hidden = true
        }
        // 选择了注册
        else if sender.selectedSegmentIndex == 1 {
            login = false
            registerView.hidden = false
        }
    }
    
    /* 登录 */
    @IBAction func login(sender: UIButton) {
        // 输入的值
        let phone = loginPhoneView.text
        let password = loginPasswordView.text
        progress("登录中")
        UserAPI.register(phone, password: password) {
            result in
            // 登录成功
            if result.status == 2 {
                self.success(result.id!, password: password)
            }
            // 该账号已存在, 但是未设置姓名
            else if result.status == 1 {
                self.loginError("登录失败")
            } else {
                self.loginError(result.info)
            }
        }
    }
    
    /* 注册 */
    @IBAction func register(sender: UIButton) {
        let phone = registerPhoneView.text
        let password = registerPasswordView.text
        let name = registerNameView.text
        
        progress("注册中")
        UserAPI.register(phone, password: password) {
            result in
            // 该用户已经存在
            if result.status == 2 {
                self.success(result.id!, password: password)
            }
            // 注册成功并保存名字
            else if result.status == 1 {
                var user = UserAO(uid: result.id, name: name, phone: phone, ext: "{}")
                UserAPI.save(user, password: password) {
                    result in
                    if (result.status == 1) {
                        self.success(user.uid!, password: password)
                    } else {
                        self.registerError(result.info)
                    }
                }
            }
            // 注册失败
            else {
                self.registerError(result.info)
            }
        }

    }
    
    // MARK: - 操作状态处理方法
    /* 操作成功 */
    func success(uid: Int64, password: String) {
        if let h = hud {
            if !h.hidden {
                h.hide(true)
                hud = nil
            }
        }
        // 初始化用户信息
        UserAPI.find(uid) {
            if let user = $0 {
                Var.uid = uid
                Var.password = password
                Var.name = user.name
                Var.user = user
                let label = self.login ? "登录" : "注册"
                ToastUtils.info(label, message: "\(label)成功")
                self.performSegueWithIdentifier("showMain", sender: self)
            } else {
                ToastUtils.error("内部错误", message: "请稍后重试")
            }
        }
    }

    /* 登录失败 */
    func loginError(message: String?) {
        // 启用所有输入
        enableAll4Login()
        enableAll4Register()
        // 关闭进度显示
        if let h = hud {
            if !h.hidden {
                h.hide(true)
            }
        }
        ToastUtils.error("登录", message: message)
    }
    
    /* 注册失败 */
    func registerError(message: String?) {
        // 启用所有输入
        enableAll4Login()
        enableAll4Register()
        // 关闭进度显示
        if let h = hud {
            if !h.hidden {
                h.hide(true)
            }
        }
        ToastUtils.error("注册", message: message)
    }
    
    /* 正在处理中 */
    func progress(title: String) {
        // 禁止所有输入
        disableAll4Login()
        disableAll4Register()
        // 显示进度条
        if let h = hud {
            h.labelText = title
            h.show(true)
        }
    }
    
    // MARK: - 页面输入的启用与禁用
    func enableAll4Login() {
        loginPhoneView.enabled = true
        loginPasswordView.enabled = true
        loginButton.enabled = true
    }
    
    func disableAll4Login() {
        loginPhoneView.enabled = false
        loginPasswordView.enabled = false
        loginButton.enabled = false
    }
    
    func enableAll4Register() {
        registerPhoneView.enabled = true
        registerPasswordView.enabled = true
        registerNameView.enabled = true
        registerButton.enabled = true
    }
    
    func disableAll4Register() {
        registerPhoneView.enabled = false
        registerPasswordView.enabled = false
        registerNameView.enabled = false
        registerButton.enabled = false
    }
}
