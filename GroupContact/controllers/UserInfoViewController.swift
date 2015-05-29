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
        tableView.contentInset = UIEdgeInsetsMake(-18, 0, 0, 0);
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if (row == 0) {
            showActionsOnPhone(user.phone)
        }
        if (row == 1) {
            showActionsOnEmail(emailLabel.text)
        }
    }
    
    // MARK: - 其他方法
    /* 弹出关于手机号的Actions */
    func showActionsOnPhone(phone: String) {
        var alert = UIAlertController(title: phone, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "呼叫", style: UIAlertActionStyle.Default) {
            let action = $0
            
            });
        alert.addAction(UIAlertAction(title: "发送短信", style: UIAlertActionStyle.Default) {
            let action = $0
            
            });
        alert.addAction(UIAlertAction(title: "发送名片", style: UIAlertActionStyle.Default) {
            let action = $0
            
            });
        alert.addAction(UIAlertAction(title: "复制", style: UIAlertActionStyle.Default) {
            let action = $0
            
            });
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel) {
            let action = $0
            });
        
        alert.modalPresentationStyle = .Popover
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /* 弹出关于邮箱号的Actions */
    func showActionsOnEmail(email: String?) {
        if email == nil {
            return
        }
        var alert = UIAlertController(title: email!, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "发送邮件", style: UIAlertActionStyle.Default) {
            let action = $0
            
            });
        alert.addAction(UIAlertAction(title: "复制", style: UIAlertActionStyle.Default) {
            let action = $0
            
            });
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel) {
            let action = $0
            });
        
        alert.modalPresentationStyle = .Popover
        
        presentViewController(alert, animated: true, completion: nil)
    }
}