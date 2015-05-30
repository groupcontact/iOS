import UIKit

/*
 * 用来显示群组中的成员列表
 */
class UserListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - 辅助控件
    /* 用来显示加载中的控件 */
    var hud: MBProgressHUD?
    
    // MARK: - 数据模型
    /* 姓氏首字母集合 */
    var keys = [String]()
    var totalCount = 0
    /* 具体的成员列表 */
    var members = [String: [UserAO]]() {
        didSet {
            totalCount = 0
            keys.removeAll()
            for (key, value) in members {
                keys.append(key)
                totalCount += value.count
            }
            keys.sort() {
                return $0 < $1
            }
            tableView.reloadData()
            if let label = tableView.tableFooterView?.subviews[0] as? UILabel {
                label.text = "总共\(totalCount)位成员"
            }
        }
    }
    
    // MARK: - 成员变量
    /* 在进入此ViewController时, 务必设置此变量, 该ID用来从网络获取数据 */
    var gid: Int64?
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 基本设置
        tableView.dataSource = self
        tableView.delegate = self
        
        // 退出群组的菜单
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showMenu:")
        
        
        // 显示正在加载中
        hud = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
        hud?.labelText = "加载中"
        
        // 调用API加载数据
        refreshData(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showUserInfo" {
                if let uiv = segue.destinationViewController as? UserInfoViewController {
                    if let tableView = sender as? UITableView {
                        let indexPath = tableView.indexPathForSelectedRow()!
                        uiv.user = members[keys[indexPath.section]]![indexPath.row]
                        uiv.fromGroupMembers = true
                        // 然后取消选中项
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Action函数
    @IBAction func refreshData(sender: UIRefreshControl?) {
        GroupAPI.listMember(gid!) {
            self.members = $0
            
            sender?.endRefreshing()
            
            if let hidden = self.hud?.hidden {
                if !hidden {
                    self.hud?.hidden = true
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keys.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members[keys[section]]!.count
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("namePhone", forIndexPath: indexPath) as!NamePhoneTableViewCell
        cell.user = members[keys[indexPath.section]]![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserInfo", sender: tableView)
    }
    
    // MARK: - 其他方法
    func showMenu(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: self.title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "退出群组", style: UIAlertActionStyle.Destructive) {
            let action = $0
            UserAPI.leave(Var.uid, password: Var.password, gid: self.gid!) {
                let result = $0
                if result.status == 1 {
                    ToastUtils.info("退出群组", message: "成功退出\(self.title!)")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    ToastUtils.error("退出群组", message: result.info)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel) {
            let action = $0
        })
        alert.modalPresentationStyle = .Popover
        let ppc = alert.popoverPresentationController
        ppc?.barButtonItem = sender
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
