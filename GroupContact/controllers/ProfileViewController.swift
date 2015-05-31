import UIKit

/*
 * 个人主页, 主要是提供一系列菜单
 */
class ProfileViewController: UITableViewController, UITableViewDelegate {

    // MARK: - IBOutlet成员列表
    @IBOutlet weak var avatarLabelView: NoClearLabel!
    
    @IBOutlet weak var nameLabelView: UILabel!
    
    @IBOutlet weak var phoneLabelView: UILabel!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        tableView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0)
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let name = Var.name
        nameLabelView.text = name
        avatarLabelView.myBackgroundColor = ColorUtils.colorOf(name)
        avatarLabelView.text = name.substringFromIndex(name.endIndex.predecessor())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Var.user {
            phoneLabelView.text = user.phone
        }
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "backLogin" {
                // 清除所有数据
                Var.clearAll()
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 0) {
            // 进入个人信息编辑页面
            performSegueWithIdentifier("editProfile", sender: tableView)
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            // 弹出修改密码页面
            changePassword()
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            // 隐藏TabBar
            self.tabBarController?.tabBar.hidden = true
            // 进入意见反馈页面
            self.navigationController?.pushViewController(UMFeedback.feedbackViewController(), animated: true)
        } else if (indexPath.section == 1 && indexPath.row == 2) {
            // 进入登录页面
            performSegueWithIdentifier("backLogin", sender: tableView)
        }
       
    }
    
    // MARK: - 其他方法
    /* 弹出修改密码的窗口 */
    func changePassword() {
        var alert = UIAlertController(title: "修改密码", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) {
            if let action = $0 {
                let keyEntered = (alert.textFields?.first as! UITextField).text
                UserAPI.resetPassword(Var.uid, password: Var.password, newPassword: keyEntered) {
                    let result = $0
                    if result.status == 1 {
                        Var.password = keyEntered
                        ToastUtils.info("修改密码", message: "成功设置新密码")
                    } else {
                        ToastUtils.error("修改密码", message: result.info)
                    }
                }
            }
            });
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) {
            if let action = $0 {
                // 不关心
            }
            });
        alert.addTextFieldWithConfigurationHandler() {
            (textField) in
            textField.placeholder = "六位数字新密码"
            textField.secureTextEntry = true
        };
        if let ppc = alert.popoverPresentationController {
            ppc.sourceView = tableView
        }
        presentViewController(alert, animated: true, completion: nil)
    }
}
