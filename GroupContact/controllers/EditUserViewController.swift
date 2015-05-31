//
//  EditUserViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 5/30/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class EditUserViewController: UITableViewController, UITableViewDelegate {

    @IBOutlet weak var phoneTextField: UITextField!
   
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var wechatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0)
        
        // 保存菜单
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "save:")
        
        if let user = Var.user {
            phoneTextField.text = user.phone
            let dict = JSON(string: user.ext)
            if let email = dict["email"].asString {
                emailTextField.text = email
            }
            if let wechat = dict["wechat"].asString {
                wechatTextField.text = wechat
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func save(sender: UIBarButtonItem) {
        let phone = phoneTextField.text
        let ext = [
            "email": emailTextField.text,
            "wechat": wechatTextField.text
        ]
        let user = UserAO(uid: Var.uid, name: Var.name, phone: phone, ext: JSON(ext).toString(pretty: false))
        UserAPI.save(user, password: Var.password) {
            let result = $0
            if result.status == 1 {
                ToastUtils.info("更改信息", message: "保存成功")
                Var.user = user
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                ToastUtils.error("更改信息", message: result.info!)
            }
        }
    }
}
