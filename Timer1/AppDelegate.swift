//
//  AppDelegate.swift
//  Timer1
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        settingHolder.suspendTime = Date.init()
        
     //   settingHolder.queueBellInBackground()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       // let vc = window?.rootViewController   as? ViewController
        settingHolder.suspendTime = Date.init()
        
     //   settingHolder.queueBellInBackground()
        
      //  vc?.queueBellInBackground()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
      //  let vc = window?.rootViewController   as? ViewController
        
      //  vc?.dequeueBellInBackground()
    //    settingHolder.dequeueBellInBackground()
        if (!settingHolder.paused){
            let timeInBackground = Date.init().timeIntervalSince(settingHolder.suspendTime)
            settingHolder.timeRemaining -= Int(timeInBackground)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  //      settingHolder.dequeueBellInBackground()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

