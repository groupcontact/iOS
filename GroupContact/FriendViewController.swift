//
//  FriendViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/26/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit
import Alamofire

class FriendViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 好友列表
    var friends = [UserAO]() {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView基本配置
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        // 调用API加载数据
        UserAPI.friendsAddedBy(Var.uid) {
            self.friends = $0
        }
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
