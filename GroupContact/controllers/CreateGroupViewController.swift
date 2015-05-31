//
//  CreateGroupViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 5/30/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class CreateGroupViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descTextField: UITextField!
    
    @IBOutlet weak var accessTextField: UITextField!
    
    @IBOutlet weak var modifyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0)
        
        // 保存菜单
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tick"), style: UIBarButtonItemStyle.Plain, target: self, action: "create:")
    }
    
    func create(sender: UIButton) {
        let name = nameTextField.text
        let desc = descTextField.text
        let access = accessTextField.text
        let modify = modifyTextField.text
        
        GroupAPI.createGroup(Var.uid, password: Var.password, group: GroupAO(gid: nil, name: name, desc: desc), accessToken: access, modifyToken: modify) {
            let result = $0
            if result.status == 1 {
                ToastUtils.info("创建群组", message: "成功创建\(name)")
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                ToastUtils.error("创建群组", message: result.info!)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
