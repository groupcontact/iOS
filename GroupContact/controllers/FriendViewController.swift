import UIKit

/*
 * 显示用户的好友列表
 */
class FriendViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - 数据模型
    /* 姓氏首字母集合 */
    var keys = [String]()
    var totalCount = 0
    /* 具体的成员列表 */
    var friends = [String: [UserAO]]() {
        didSet {
            totalCount = 0
            keys.removeAll()
            for (key, value) in friends {
                keys.append(key)
                totalCount += value.count
            }
            keys.sort() {
                return $0 < $1
            }
            tableView.reloadData()
            tableView.tableFooterView = TableUtils.footerView("总共\(totalCount)位好友")
            tableView.tableFooterView = tableView.tableFooterView
        }
    }

    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView基本配置
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        if (Var.friends.count > 0) {
            friends = Var.friends
        } else {
            // 调用API加载数据
            refreshData(nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showUserInfo" {
                if let uiv = segue.destinationViewController as? UserInfoViewController {
                    if let tableView = sender as? UITableView {
                        let indexPath = tableView.indexPathForSelectedRow()!
                        uiv.user = friends[keys[indexPath.section]]![indexPath.row]
                    }
                }
            }
        }
    }
    
    // MARK: - Action函数
    @IBAction func refreshData(sender: UIRefreshControl?) {
        UserAPI.listFriend(Var.uid) {
            self.friends = $0
            Var.friends = $0
            
            sender?.endRefreshing()
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
        return friends[keys[section]]!.count
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("namePhone", forIndexPath: indexPath) as!UITableViewCell
        
        let user = friends[keys[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.phone
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserInfo", sender: tableView)
    }
}
