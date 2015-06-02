//
//  UserInfoViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/29/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class UserInfoViewController: UITableViewController, UITableViewDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var avatarLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var wechatLabel: UILabel!
    
    var user: UserAO!
    
    var fromGroupMembers = false
    var fromUserFriends = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 标题为用户名
        let name = user.name
        title = name
        avatarLabel.backgroundColor = ColorUtils.colorOf(name)
        avatarLabel.text = name.substringFromIndex(name.endIndex.predecessor())
        
        phoneLabel.text = user.phone
        let ext = JSON(string: user.ext)
        if let email = ext["email"].asString {
            if email != "" {
                emailLabel.text = email
                emailLabel.textColor = UIColor.darkGrayColor()
            }
        }
        if let wechat = ext["wechat"].asString {
            if wechat != "" {
                wechatLabel.text = wechat
                wechatLabel.textColor = UIColor.darkGrayColor()
            }
        }
        
        // tableView的基本设置
        tableView.delegate = self
        
        // 加为好友或取消好友的菜单
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showMenu:")
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if (row == 0) {
            showActionsOnPhone(user.phone)
        }
        if (row == 1) {
            if let email = emailLabel.text {
                if email != "暂未填写" {
                    showActionsOnEmail(email)
                }
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - 其他方法
    /* 弹出关于手机号的Actions */
    func showActionsOnPhone(phone: String) {
        let alert = UIActionSheet(title: phone, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "呼叫", "发送短信", "复制")
        
        alert.showInView(self.view)
    }
    
    /* 弹出关于邮箱号的Actions */
    func showActionsOnEmail(email: String) {
        let alert = UIActionSheet(title: email, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "发送邮件", "复制")
        alert.showInView(self.view)
    }
    
    func showMenu(sender: UIBarButtonItem) {
        if fromUserFriends {
            let alert = UIActionSheet(title: "操作", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "删除好友")
            alert.showInView(self.view)
        }
        if fromGroupMembers {
            let alert = UIActionSheet(title: "操作", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "添加好友")
            alert.showInView(self.view)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.title == user.phone {
            let phone = user.phone
            if buttonIndex == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(phone)")!)
            } else if buttonIndex == 2 {
                UIApplication.sharedApplication().openURL(NSURL(string: "sms:\(phone)")!)
            } else if buttonIndex == 3 {
                UIPasteboard.generalPasteboard().string = phone
                ToastUtils.info(phone, message: "复制成功")
            }
            return
        }
        if actionSheet.title == emailLabel.text! {
            let email = emailLabel.text!
            if buttonIndex == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: "mailto:\(email)")!)
            } else if buttonIndex == 2 {
                UIPasteboard.generalPasteboard().string = email
                ToastUtils.info(email, message: "复制成功")
            }
            return
        }
        if buttonIndex == 0 {
            return
        }
        if fromGroupMembers {
            UserAPI.addFriend(Var.uid, password: Var.password, name: self.user.name, phone: self.user.phone) {
                let result = $0
                if result.status == 1 {
                    ToastUtils.info("添加好友", message: "成功添加\(self.user.name)")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    ToastUtils.error("添加好友", message: result.info)
                }
            }
            return
        } else {
            UserAPI.deleteFriend(Var.uid, password: Var.password, fid: self.user.uid!) {
                let result = $0
                if result.status == 1 {
                    ToastUtils.info("删除好友", message: "成功删除\(self.user.name)")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    ToastUtils.error("删除好友", message: result.info)
                }
            }
        }
    }
}