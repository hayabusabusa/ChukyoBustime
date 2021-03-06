//
//  AppDelegate.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Init Firebase
        FirebaseApp.configure()
        // UserNotification
        UNUserNotificationCenter.current().delegate = self
        // Setup root ViewController
        setupRootViewController()
        return true
    }
}

// MARK: - Root VC

extension AppDelegate {
    
    private func setupRootViewController() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RootViewController.instantiate()
        window.makeKeyAndVisible()
        self.window = window
    }
}

// MARK: -  UNUserNotificationCenter delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
