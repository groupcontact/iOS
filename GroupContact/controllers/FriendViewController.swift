import UIKit

/*
 * 显示好友列表
 */
@objc class FriendViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var houseRefreshControl: CBStoreHouseRefreshControl?
    
    // 好友列表
    var friends = [UserAO]() {
        didSet {
            updateUI()
        }
    }
    
    // 重新加载数据
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
        
        // tableView基本配置
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        if (Var.friends.count > 0) {
            friends = Var.friends
        } else {
            // 调用API加载数据
            UserAPI.listFriend(Var.uid) {
                self.friends = $0
                Var.friends = $0
            }
        }
    }
    
    func refreshData() {
        UserAPI.listFriend(Var.uid) {
            self.friends = $0
            Var.friends = $0
            self.houseRefreshControl?.finishingLoading()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.houseRefreshControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.houseRefreshControl?.scrollViewDidEndDragging()
    }
    
    // 需要根据拼音使用多个section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    // 行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    // 具体行的展示
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("namePhone", forIndexPath: indexPath) as!UITableViewCell
        
        let user = friends[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.phone
        
        return cell
    }
    
    // 点击进入用户详情页
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserInfo", sender: tableView)
    }
    
    // 进入详情页前设置数据
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showUserInfo" {
                if let uiv = segue.destinationViewController as? UserInfoViewController {
                    if let tableView = sender as? UITableView {
                        uiv.user = friends[tableView.indexPathForSelectedRow()!.row]
                        uiv.fromUserFriends = true
                    }
                }
            }
        }
    }
}
