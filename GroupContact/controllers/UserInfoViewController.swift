//
//  UserInfoViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/29/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class UserInfoViewController: UITableViewController, UITableViewDelegate {
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var wechatLabel: UILabel!
    
    var user: UserAO!
    
    var fromGroupMembers = false
    var fromUserFriends = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 标题为用户名
        title = user.name
        phoneLabel.text = user.phone
        let ext = JSON.parse(user.ext)
        emailLabel.text = ext["email"].asString
        wechatLabel.text = ext["wechat"].asString
        
        // tableView的基本设置
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        tableView.contentInset = UIEdgeInsetsMake(-18, 0, 0, 0);
    }    
    
}