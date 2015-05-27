//
//  AppDelegate.swift
//  GroupContact
//
//  Created by Haibing Zhou on 4/26/15.
//  Copyright (c) 2015 Haibing Zhou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 读取配置，用户是否已经登录
        let uid = NSUserDefaults.standardUserDefaults().integerForKey("uid")
        if uid == 0 {
            // 如果未登录, 则进入登录/注册页面
            self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Auth") as? UIViewController
        } else {
            // 如果已登录, 则进入主页面
            self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Main") as? UIViewController
        }
        return true
    }

}

