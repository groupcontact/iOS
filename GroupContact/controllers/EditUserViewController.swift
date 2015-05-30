//
//  EditUserViewController.swift
//  GroupContact
//
//  Created by Haibing Zhou on 5/30/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
   
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var wechatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func save(sender: UIButton) {
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
