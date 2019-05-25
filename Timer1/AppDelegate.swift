//
//  AppDelegate.swift
//  JHTimer
//
//  Created by John Holland on 3/31/19.
//  Copyright © 2019 John Holland. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var settingHolder  = SettingHolder.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        // Override point for customization after application launch.
        application.isIdleTimerDisabled = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        settingHolder.suspendTime = Date.init()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        settingHolder.suspendTime = Date.init()
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if (!settingHolder.paused){
            let timeInBackground = Date.init().timeIntervalSince(settingHolder.suspendTime)
            settingHolder.timeRemaining -= Int(timeInBackground)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    
}

