import UIKit

/*
 * 展示用户加入的群组列表
 */
class GroupViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var searchText: UISearchBar!
    
    var houseRefreshControl: CBStoreHouseRefreshControl?
    
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
        
        // 下拉刷新的相关配置
        houseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(tableView, target: self,
            refreshAction: "refreshData", plist: "storehouse", color: UIColor.blackColor(), lineWidth: CGFloat(2),
            dropHeight: CGFloat(80), scale: CGFloat(1), horizontalRandomness: CGFloat(150), reverseLoadingAnimation: false,
            internalAnimationFactor: CGFloat(0.7))
        
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
    
    func refreshData() {
        UserAPI.listGroup(Var.uid) {
            self.groups = $0
            Var.groups = $0
            self.houseRefreshControl?.finishingLoading()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.houseRefreshControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.houseRefreshControl?.scrollViewDidEndDragging()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("nameDesc", forIndexPath: indexPath) as! UITableViewCell
        
        let group = groups[indexPath.row]
        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.desc
        
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
                        let group = groups[tableView.indexPathForSelectedRow()!.row]
                        ulv.title = group.name
                        ulv.gid = group.gid
                    }
                }
            }
        }
    }

}
