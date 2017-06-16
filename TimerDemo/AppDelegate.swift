//
//  AppDelegate.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey:Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let currTask = TaskHandler.shared.currentTask{
            if currTask.taskStatus == .running{
//                if #available(iOS 10.0, *) {
//                    let center = UNUserNotificationCenter.current()
//                    let content = UNMutableNotificationContent()
//                    content.title = "Late wake up call"
//                    content.body = "The early bird catches the worm, but the second mouse gets the cheese."
//                    content.categoryIdentifier = "alarm"
//                    content.userInfo = ["customData": "fizzbuzz"]
//                    content.sound = UNNotificationSound.default()
//
//                    var dateComponents = DateComponents()
////                    dateComponents.hour = 15
////                    dateComponents.minute = 49
//                    dateComponents.second = Int(currTask.timeRemaining)
//                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//                    center.add(request)
//                } else {
                
                    // ios 9
                
                DispatchQueue.main.async {
                    
                    let notification = UILocalNotification()
                    notification.fireDate = NSDate(timeIntervalSinceNow: currTask.timeRemaining) as Date
                    notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
                    notification.alertAction = "be awesome!"
                    notification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.shared.scheduleLocalNotification(notification)
                    
                    let notification1 = UILocalNotification()
                    notification1.fireDate = NSDate(timeIntervalSinceNow: currTask.timeRemaining) as Date
                    notification1.alertBody = "Hey you! Yeah you! Swipe to unlock!"
                    notification1.alertAction = "be awesome!"
                    notification1.soundName = UILocalNotificationDefaultSoundName
                    
                    UIApplication.shared.scheduleLocalNotification(notification1)
                }

                //}
            }
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

