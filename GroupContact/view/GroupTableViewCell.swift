//
//  GroupTableViewCell.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/27/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var group: GroupAO? {
        didSet {
            if let newGroup = group  {
                nameLabel.text = newGroup.name
                descLabel.text = newGroup.desc
            }
        }
    }
}
