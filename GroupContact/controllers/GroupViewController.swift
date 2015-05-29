import UIKit

/*
 * 展示用户加入的群组列表
 */
class GroupViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Outlet成员
    @IBOutlet weak var searchText: UISearchBar!
    
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
                tableView.tableFooterView = TableUtils.footerView("总共\(displayedGroups.count)个群组")
            } else {
                tableView.tableFooterView = TableUtils.footerView("")
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
        
        if (Var.groups.count > 0) {
            groups = Var.groups
        } else {
            refreshData(nil)
        }
        
        // 设置UISearchBarDelegate
        searchText.delegate = self
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
        return displayedGroups.count
    }
    
    // MARK: - UITableDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameDesc", forIndexPath: indexPath) as! UITableViewCell
        
        let group = displayedGroups[indexPath.row]
        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.desc
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 如果是搜索模式, 提示输入加入密码
        if searchMode {
            
        }
        // 非搜索模式直接进入群组成员列表页面
        else {
            performSegueWithIdentifier("showUserList", sender: tableView)
        }
    }
    
    // MARK: - UISearchBarDelegate
    /* 开始编辑时 */
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.displayedGroups = [GroupAO]()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // 显示取消按钮
        searchBar.setShowsCancelButton(true, animated: true)
        for subView in searchBar.subviews[0].subviews {
            if let button = subView as? UIButton {
                button.setTitle("取消", forState: UIControlState.Normal)
            }
        }
        // 进入搜索模式
        searchMode = true
    }
    
    /* 按下了取消按钮 */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // 不显示取消按钮
        searchBar.setShowsCancelButton(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.displayedGroups = groups
        // 清空输入的内容
        searchBar.text = ""
        // 失去编辑焦点
        searchBar.resignFirstResponder()
        // 退出搜索模式
        searchMode = false
    }
    
    /* 按下了搜索按钮 */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        GroupAPI.search(searchBar.text) {
            self.displayedGroups = $0
        }
    }
}
