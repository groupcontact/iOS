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
            if let label = tableView.tableFooterView?.subviews[0] as? UILabel {
                label.text = "总共\(totalCount)位好友"
            }
        }
    }

    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView基本配置
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if (Var.friends.count > 0) {
            friends = Var.friends
        } else {
            // 调用API加载数据
            refreshData(nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showUserInfo" {
                if let uiv = segue.destinationViewController as? UserInfoViewController {
                    if let tableView = sender as? UITableView {
                        let indexPath = tableView.indexPathForSelectedRow()!
                        uiv.user = friends[keys[indexPath.section]]![indexPath.row]
                        uiv.fromUserFriends = true
                        // 然后取消选中项
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Action函数
    @IBAction func refreshData(sender: UIRefreshControl?) {
        UserAPI.listFriend(Var.uid) {
            let result = $0
            if result.count > 0 {
                self.friends = $0
                Var.friends = $0
            }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("namePhone", forIndexPath: indexPath) as!NamePhoneTableViewCell
        cell.user = friends[keys[indexPath.section]]![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserInfo", sender: tableView)
    }
}
