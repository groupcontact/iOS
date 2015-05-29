import UIKit

/*
 * 展示用户加入的群组列表
 */
class GroupViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlet成员
    @IBOutlet weak var searchText: UISearchBar!
    
    // MARK: - 数据模型
    /* 群组列表 */
    var groups = [GroupAO]() {
        didSet {
            tableView.reloadData()
            tableView.tableFooterView = TableUtils.footerView("总共\(groups.count)个群组")
        }
    }
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView基本设置
        tableView.dataSource = self
        tableView.delegate = self
        
        if (Var.groups.count > 0) {
            groups = Var.groups
        } else {
            refreshData(nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showUserList" {
                if let ulv = segue.destinationViewController as? UserListViewController {
                    if let tableView = sender as? UITableView {
                        let group = groups[tableView.indexPathForSelectedRow()!.row]
                        ulv.title = group.name
                        ulv.gid = group.gid
                    }
                }
            }
        }
    }

    
    // MARK: - Action函数
    @IBAction func refreshData(sender: UIRefreshControl?) {
        UserAPI.listGroup(Var.uid) {
            self.groups = $0
            Var.groups = $0
            
            sender?.endRefreshing()
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    // MARK: - UITableDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameDesc", forIndexPath: indexPath) as! UITableViewCell
        
        let group = groups[indexPath.row]
        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.desc
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserList", sender: tableView)
    }
}
