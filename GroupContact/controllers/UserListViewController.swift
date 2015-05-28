//
//  UserListViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/29/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var houseRefreshControl: CBStoreHouseRefreshControl?
    
    var hud: MBProgressHUD?
    
    // 数据模型, 群组成员
    var keys = [String]()
    var members = [String: [UserAO]]() {
        didSet {
            updateUI()
        }
    }
    
    // 群组ID, 必须设置
    var gid: Int64?
    
    func updateUI() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下拉刷新的相关配置
//        houseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(tableView, target: self,
//            refreshAction: "refreshData", plist: "storehouse", color: UIColor.blackColor(), lineWidth: CGFloat(2),
//            dropHeight: CGFloat(80), scale: CGFloat(1), horizontalRandomness: CGFloat(150), reverseLoadingAnimation: false,
//            internalAnimationFactor: CGFloat(0.7))
        
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
    
    @IBAction func refreshData(sender: UIRefreshControl?) {
        GroupAPI.listMember2(gid!) {
            self.keys = $0
            self.members = $1
            
            sender?.endRefreshing()
            
            if let hidden = self.hud?.hidden {
                if !hidden {
                    self.hud?.hidden = true
                }
            }
        }
    }

    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        self.houseRefreshControl?.scrollViewDidScroll()
//    }
//    
//    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.houseRefreshControl?.scrollViewDidEndDragging()
//    }
    
    // section的数量
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keys.count
    }
    
    // 每一个Section的header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    
    // 行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members[keys[section]]!.count
    }
    
    // 每一行的样式
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("namePhone", forIndexPath: indexPath) as!UITableViewCell
        
        let user = members[keys[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.phone
        
        return cell
    }
    
    // 点击某行则进入该用户的详细信息界面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showUserInfo", sender: tableView)
    }
    
    // 具体的Segue跳转, 设置目的Controller的数据
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

}
