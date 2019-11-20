//
//  AppDelegate.swift
//  ZZDataTest
//
//  Created by zry on 2019/9/24.
//  Copyright © 2019 ZRY. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let nav = UINavigationController(rootViewController: TestItemsViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }



}

