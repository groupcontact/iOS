//
//  AddUserViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 5/30/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class AddUserViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tick"), style: UIBarButtonItemStyle.Plain, target: self, action: "add:")
    }
    
    func add(sender: UIBarButtonItem) {
        let name = nameTextField.text
        let phone = phoneTextField.text
        
        UserAPI.addFriend(Var.uid, password: Var.password, name: name, phone: phone) {
            let result = $0
            if result.status == 1 {
                ToastUtils.info("添加好友", message: "成功添加\(name)")
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                ToastUtils.error("添加好友", message: result.info)
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
