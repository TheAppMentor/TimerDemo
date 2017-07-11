//
//  AppDelegate.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var dateCurrentRunningTaskEnds : Date?
    
    override init() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey:Any]?) -> Bool {
        
        // Override point for customization.. after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Ok... We have authorization man...")
            }
            // Enable or disable features based on authorization.
        }
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = Utilities.shared.lightGrayColor
        pageControl.currentPageIndicatorTintColor = Utilities.shared.lightRedColor
        pageControl.backgroundColor = UIColor.clear
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // Figure out How much time is remaining. in Seconds.
        // Pause the timer.
        // Create an Date , when the timer should fire.
        // Schedule a local notification.
        
        if let currTask = TaskHandler.shared.currentTask{
            if currTask.taskStatus == .running{
                currTask.freeze()
                dateCurrentRunningTaskEnds = Date(timeInterval: currTask.timeRemaining, since: Date())
                print("Now : \(Date())   timeCurrentRunningTaskEnds : \(dateCurrentRunningTaskEnds!)  => Notify me after \(Int((dateCurrentRunningTaskEnds?.timeIntervalSinceNow)!))")
                currTask.taskStatus = .pausedBecauseAppResignedActive
                
                // Schedule a local Notification.
                if #available(iOS 10.0, *) {
                    let center = UNUserNotificationCenter.current()
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Timer Finished"
                    content.body = "\(currTask.taskName) Finished."
                    content.categoryIdentifier = "alarm"
                    //content.userInfo = ["customData": "fizzbuzz"]
                    content.sound = UNNotificationSound.default()
                    
                    // Swift
                    let date = Date(timeIntervalSinceNow: currTask.timeRemaining)
                    let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
                    print(" !!!!!!!!!!!!!! Will Notify After => \(currTask.timeRemaining) : \(triggerDate.second) Seconds !!!!!!!!!!!!!! ")
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    center.add(request)
                    center.getPendingNotificationRequests(completionHandler: { (theNoteReq) in
                        print("Pending Notification : \(theNoteReq)")
                    })
                }
            }
        }
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let currTask = TaskHandler.shared.currentTask{
            if currTask.taskStatus == .pausedBecauseAppResignedActive{
                if let dateTaskEnds = dateCurrentRunningTaskEnds{
                    if dateTaskEnds.timeIntervalSince(Date()) > 0{
                        print("Timer Active Again : Remaining Time  : \(dateTaskEnds.timeIntervalSince(Date()))")
                        currTask.timeRemaining = dateTaskEnds.timeIntervalSince(Date())
                        currTask.Unfreeze(estimatedEndTime : dateCurrentRunningTaskEnds!)
                        print("We are Restarting the timer : With Time Remanining : \(currTask.timeRemaining)")
                    }else{
                        print("Timer has expired when we were paused")
                        TaskHandler.shared.abandonCurrentTask()
                    }
                }
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

