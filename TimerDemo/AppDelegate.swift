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
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var dateCurrentRunningTaskEnds : Date?
    
    override init() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey:Any]?) -> Bool {

        
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5666511173297473~7405055349")
        Database.setLoggingEnabled(true)
        
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
        
        if let currTask = TaskManager.shared.currentTask{
            if currTask.taskStatus == .running{
                currTask.freeze()
                dateCurrentRunningTaskEnds = Date(timeInterval: currTask.timeRemaining, since: Date())
                currTask.taskStatus = .pausedBecauseAppResignedActive
                
                // Schedule a local Notification.
                if #available(iOS 10.0, *) {
                    let center = UNUserNotificationCenter.current()
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Timer Finished"
                    content.body = "\(currTask.taskName) Finished."
                    content.categoryIdentifier = "alarm"
                    content.sound = UNNotificationSound.default()
                    
                    // Swift
                    let date = Date(timeIntervalSinceNow: currTask.timeRemaining)
                    let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)

                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    center.add(request)
                    center.getPendingNotificationRequests(completionHandler: { (theNoteReq) in
                    })
                }
            }
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let currTask = TaskManager.shared.currentTask{
            if currTask.taskStatus == .pausedBecauseAppResignedActive{
                if let dateTaskEnds = dateCurrentRunningTaskEnds{
                    if dateTaskEnds.timeIntervalSince(Date()) > 0{
                        //We came back from background & App still had an active running timer.
                        currTask.timeRemaining = dateTaskEnds.timeIntervalSince(Date())
                        currTask.Unfreeze(estimatedEndTime : dateCurrentRunningTaskEnds!)
                    }else{
                        //Timer has expired when were in the background
                        currTask.timerDidComplete()
                    }
                }
            }
        }
    }
}


