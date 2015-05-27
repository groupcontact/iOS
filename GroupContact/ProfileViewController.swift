//
//  ProfileViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/26/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UITableViewDelegate {

    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        // 头像截成圆形
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 60
        
        nameLabelView.text = Var.name
    }
    
    // 菜单点击跳转
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            performSegueWithIdentifier("editProfile", sender: tableView)
        } else if (indexPath.row == 1) {
            performSegueWithIdentifier("showQRCode", sender: tableView)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
        }
    }
}
