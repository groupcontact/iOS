//
//  UserInfoViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/29/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class UserInfoViewController: UITableViewController, UITableViewDelegate {
    
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
            emailLabel.text = email
            emailLabel.textColor = UIColor.darkGrayColor()
        }
        if let wechat = ext["wechat"].asString {
            wechatLabel.text = wechat
            wechatLabel.textColor = UIColor.darkGrayColor()
        }
        
        // tableView的基本设置
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
        var alert = UIAlertController(title: phone, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "呼叫", style: UIAlertActionStyle.Default) {
            let action = $0
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(phone)")!)
            });
        alert.addAction(UIAlertAction(title: "发送短信", style: UIAlertActionStyle.Default) {
            let action = $0
            UIApplication.sharedApplication().openURL(NSURL(string: "sms:\(phone)")!)
            });
        alert.addAction(UIAlertAction(title: "复制", style: UIAlertActionStyle.Default) {
            let action = $0
            UIPasteboard.generalPasteboard().string = phone
            ToastUtils.info(phone, message: "复制成功")
            });
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel) {
            let action = $0
            });
        alert.modalPresentationStyle = .Popover
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /* 弹出关于邮箱号的Actions */
    func showActionsOnEmail(email: String) {
        var alert = UIAlertController(title: email, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "发送邮件", style: UIAlertActionStyle.Default) {
            let action = $0
            
        })
        alert.addAction(UIAlertAction(title: "复制", style: UIAlertActionStyle.Default) {
            let action = $0
            UIPasteboard.generalPasteboard().string = email
            ToastUtils.info(email, message: "复制成功")
            })
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel) {
            let action = $0
            })
        
        alert.modalPresentationStyle = .Popover
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showMenu(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: self.title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        if fromUserFriends {
            alert.addAction(UIAlertAction(title: "删除好友", style: UIAlertActionStyle.Destructive) {
                let action = $0
                UserAPI.deleteFriend(Var.uid, password: Var.password, fid: self.user.uid!) {
                    let result = $0
                    if result.status == 1 {
                        ToastUtils.info("删除好友", message: "成功删除\(self.user.name)")
                    } else {
                        ToastUtils.error("删除好友", message: result.info)
                    }
                }
            })
        }
        if fromGroupMembers {
            alert.addAction(UIAlertAction(title: "加为好友", style: UIAlertActionStyle.Default) {
                let action = $0
                UserAPI.addFriend(Var.uid, password: Var.password, name: self.user.name, phone: self.user.phone) {
                    let result = $0
                    if result.status == 1 {
                        ToastUtils.info("添加好友", message: "成功添加\(self.user.name)")
                    } else {
                        ToastUtils.error("添加好友", message: result.info)
                    }
                }
            })
        }
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) {
            let action = $0
            // 不关心
        })
        alert.modalPresentationStyle = .Popover
        let ppc = alert.popoverPresentationController
        ppc?.barButtonItem = sender
        
        presentViewController(alert, animated: true, completion: nil)
    }
}