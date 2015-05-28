import UIKit

/*
 * 展示用户加入的群组列表
 */
class GroupViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchText: UISearchBar!
    
    // 群组列表
    var groups = [GroupAO]() {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView基本设置
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        if (Var.groups.count > 0) {
            groups = Var.groups
        } else {
            // 调用API加载数据
            UserAPI.listGroup(Var.uid) {
                self.groups = $0
                Var.groups = $0
            }
        }
    }
    
    // 目前只有一行
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    // 行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    // 具体行的展示
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameDesc", forIndexPath: indexPath) as! GroupTableViewCell
        
        let group = groups[indexPath.row]
        cell.group = group
        
        return cell
    }
    
    // 点击进入群组的成员列表
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserList", sender: tableView)
    }
    
    // 设置参数
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showUserList" {
                if let ulv = segue.destinationViewController as? UserListViewController {
                    if let tableView = sender as? UITableView {
                        ulv.title = groups[tableView.indexPathForSelectedRow()!.row].name
                        ulv.gid = groups[tableView.indexPathForSelectedRow()!.row].gid
                    }
                }
            }
        }
    }

}
