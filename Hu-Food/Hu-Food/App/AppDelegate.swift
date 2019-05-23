//
//  AppDelegate.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navi = UINavigationController()
        let vc = MainViewController.instantiate()
        navi.viewControllers.append(vc)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        return true
    }
}

