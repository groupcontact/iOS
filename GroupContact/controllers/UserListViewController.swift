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
    /* 具体的成员列表 */
    var members = [String: [UserAO]]() {
        didSet {
            keys.removeAll()
            for (key, _) in members {
                keys.append(key)
            }
            keys.sort() {
                return $0 < $1
            }
            tableView.reloadData()
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
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
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
                    }
                }
            }
        }
    }
    
    // MARK: - Action函数
    @IBAction func refreshData(sender: UIRefreshControl?) {
        GroupAPI.listMember2(gid!) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("namePhone", forIndexPath: indexPath) as!UITableViewCell
        
        let user = members[keys[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.phone
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserInfo", sender: tableView)
    }
}
