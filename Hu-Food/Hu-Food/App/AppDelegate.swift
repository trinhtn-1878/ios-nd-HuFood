//
//  AppDelegate.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase
@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController()
        if UserRepository.shared.getCurrentUser() != nil {
            let mainVC = MainViewController.instantiate()
            nav.viewControllers = [mainVC]
        } else {
            let loginVC = LoginViewController.instantiate()
            nav.viewControllers = [loginVC]
        }
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

