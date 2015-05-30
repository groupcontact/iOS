import UIKit

/*
 * 展示用户加入的群组列表
 */
class GroupViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Outlet成员
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - 数据模型
    /* 群组列表 */
    var groups = [GroupAO]() {
        didSet {
            displayedGroups = groups
        }
    }
    /* 搜索的结果列表 */
    var displayedGroups = [GroupAO]() {
        didSet {
            tableView.reloadData()
            // 只有当模型数据数量大于0时才显示
            if displayedGroups.count > 0 {
                if let label = tableView.tableFooterView?.subviews[0] as? UILabel {
                    label.text = "总共\(displayedGroups.count)个群组"
                }
            } else {
                if let label = tableView.tableFooterView?.subviews[0] as? UILabel {
                    label.text = ""
                }
            }
        }
    }
    /* 是否处在搜索模式 */
    var searchMode = false
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView基本设置
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if (Var.groups.count > 0) {
            groups = Var.groups
        } else {
            refreshData(nil)
        }
        
        // 设置UISearchBarDelegate
        searchBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if let hidden = navigationController?.navigationBarHidden {
            if hidden {
                leaveSearchMode()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showUserList" {
                if let ulv = segue.destinationViewController as? UserListViewController {
                    if let tableView = sender as? UITableView {
                        let indexPath = tableView.indexPathForSelectedRow()!
                        let group = groups[indexPath.row]
                        ulv.title = group.name
                        ulv.gid = group.gid
                        // 然后取消选中项
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }
                }
            }
        }
    }

    
    // MARK: - Action函数
    @IBAction func refreshData(sender: UIRefreshControl?) {
        if searchMode {
            sender?.endRefreshing()
            return
        }
        UserAPI.listGroup(Var.uid) {
            self.groups = $0
            Var.groups = $0
            
            sender?.endRefreshing()
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }
    
    // MARK: - UITableDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameDesc", forIndexPath: indexPath) as! NameDescTableViewCell
        cell.group = displayedGroups[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 如果是搜索模式, 提示输入加入密码
        if searchMode {
            showJoinGroupAlert(displayedGroups[indexPath.row])
        }
        // 非搜索模式直接进入群组成员列表页面
        else {
            performSegueWithIdentifier("showUserList", sender: tableView)
        }
    }
    
    // MARK: - UISearchBarDelegate
    /* 开始编辑时 */
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        enterSearchMode()
    }
    
    /* 按下了取消按钮 */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        leaveSearchMode()
    }
    
    /* 按下了搜索按钮 */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        GroupAPI.search(searchBar.text) {
            self.displayedGroups = $0
        }
    }
    
    // MARK: - 其他成员方法
    func showJoinGroupAlert(group: GroupAO) {
        var alert = UIAlertController(title: "\(group.name)", message: "输入访问密码", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "加入", style: UIAlertActionStyle.Default) {
            if let action = $0 {
                let keyEntered = (alert.textFields?.first as! UITextField).text
                UserAPI.join(Var.uid, password: Var.password, gid: group.gid!, accessToken: keyEntered) {
                    let result = $0
                    // 成功加入群组
                    if result.status == 1 {
                        TWMessageBarManager.sharedInstance().showMessageWithTitle(group.name, description: "成功加入", type: TWMessageBarMessageType.Success,
                            statusBarStyle: UIStatusBarStyle.Default, callback: nil)
                    } else {
                        TWMessageBarManager.sharedInstance().showMessageWithTitle(group.name, description: result.info, type: TWMessageBarMessageType.Error)
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
            (textField) in textField.placeholder = "访问密码"
        };
        if let ppc = alert.popoverPresentationController {
            ppc.sourceView = tableView
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func leaveSearchMode() {
        // 不显示取消按钮
        searchBar.setShowsCancelButton(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.displayedGroups = groups
        // 清空输入的内容
        searchBar.text = ""
        // 失去编辑焦点
        searchBar.resignFirstResponder()
        // 显示TabBar
        self.tabBarController?.tabBar.hidden = false
        // tableView的设置
        self.tableView.bounces = true
        // 退出搜索模式
        searchMode = false
    }
    
    func enterSearchMode() {
        self.displayedGroups = [GroupAO]()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // 显示取消按钮
        searchBar.setShowsCancelButton(true, animated: true)
        for subView in searchBar.subviews[0].subviews {
            if let button = subView as? UIButton {
                button.setTitle("取消", forState: UIControlState.Normal)
            }
        }
        // 隐藏TabBar
        self.tabBarController?.tabBar.hidden = true
        // tableView的设置
        self.tableView.bounces = false
        // 进入搜索模式
        searchMode = true
    }
}
