//
//  SettingsHandlerTests.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/6/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import XCTest

class SettingsHandlerTests: XCTestCase {
    
//    var settingsHandler = SettingsHandler.shared
//    let settingsDict = NSMutableDictionary(contentsOfFile: Bundle.main.path(forResource: "Settings", ofType: "plist")!)
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    func testCopyBundleToDocumentsDirectory() {
//        
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Settings.plist"
//        print(documentDirectory)
//        settingsHandler.copySettingsFileFromBundle()
//
//        XCTAssert(FileManager.default.fileExists(atPath: documentDirectory), "copySettingsFileFromBundle() => Failed")
//    }
//    
//    
//    func testTaskDurationFetch() {
//        XCTAssert(Double((settingsHandler.taskDurationMinutes.currentValue))! == 25.0, "task Duration does not match ==> Fail")
//    }
//    
//    
//    func testTaskDurationUpdate() {
//        
//        let currSetting = settingsHandler.taskDurationMinutes
//        let newSetting = Setting(displayName: (currSetting.displayName), currentValue: "30.0", listOfValues: currSetting.listOfValues)
//        settingsHandler.taskDurationMinutes = newSetting
//        
//        let result = Double((settingsHandler.taskDurationMinutes.currentValue))! == 30.0 ? true : false
//        XCTAssert(result, "task Duration Updated Failed \((settingsHandler.taskDurationMinutes.currentValue))!)  ==> Fail")
//        
//        if result == true {settingsHandler.taskDurationMinutes = currSetting}
//    }
//    
//    func testShortBreakDurationRead() {
//        XCTAssert(Double((settingsHandler.shortBreakDurationMinutes.currentValue))! == 5.0, "task Duration does not match ==> Fail")
//    }
//    
//    func testShortBreakDurationUpdate() {
//        
//        let currSetting = settingsHandler.shortBreakDurationMinutes
//        let newSetting = Setting(displayName: (currSetting.displayName), currentValue: "15.0", listOfValues: currSetting.listOfValues)
//        settingsHandler.shortBreakDurationMinutes = newSetting
//        
//        let result = Double((settingsHandler.shortBreakDurationMinutes.currentValue))! == 15.0 ? true : false
//        XCTAssert(result, "task Duration Updated Failed \((settingsHandler.shortBreakDurationMinutes.currentValue))!)  ==> Fail")
//        
//        if result == true {settingsHandler.shortBreakDurationMinutes = currSetting}
//        
//    }
//    
//    func testLongBreakDurationRead() {
//        XCTAssert(Double((settingsHandler.longBreakDurationMinutes.currentValue))! == 5.0, "task Duration does not match ==> Fail")
//    }
//    
//    func testLongBreakDurationUpdate() {
//        
//        let currSetting = settingsHandler.longBreakDurationMinutes
//        let newSetting = Setting(displayName: (currSetting.displayName), currentValue: "15.0", listOfValues: currSetting.listOfValues)
//        settingsHandler.longBreakDurationMinutes = newSetting
//        
//        let result = Double((settingsHandler.longBreakDurationMinutes.currentValue))! == 15.0 ? true : false
//        XCTAssert(result, "task Duration Updated Failed \((settingsHandler.longBreakDurationMinutes.currentValue))!)  ==> Fail")
//        
//        if result == true {settingsHandler.longBreakDurationMinutes = currSetting}
//        
//    }
//    
//    func testLongBreakIntervalRead() {
//        XCTAssert(Double((settingsHandler.longBreakInterval.currentValue))! == 5.0, "task Duration does not match ==> Fail")
//    }
//    
//    func testLongBreakIntervalUpdate() {
//        
//        let currSetting = settingsHandler.longBreakInterval
//        let newSetting = Setting(displayName: (currSetting.displayName), currentValue: "33.0", listOfValues: currSetting.listOfValues)
//        settingsHandler.longBreakInterval = newSetting
//        
//        let result = Double((settingsHandler.longBreakInterval.currentValue))! == 33.0 ? true : false
//        XCTAssert(result, "task Duration Updated Failed \((settingsHandler.longBreakInterval.currentValue))!)  ==> Fail")
//        
//        if result == true {settingsHandler.longBreakInterval = currSetting}
//    }
//    
//    func testShortBreakIntervalRead() {
//        XCTAssert(Double((settingsHandler.shortBreakInterval.currentValue))! == 5.0, "task Duration does not match ==> Fail")
//    }
//    
//    func testShortBreakIntervalUpdate() {
//        
//        let currSetting = settingsHandler.shortBreakInterval
//        let newSetting = Setting(displayName: (currSetting.displayName), currentValue: "43.0", listOfValues: currSetting.listOfValues)
//        settingsHandler.shortBreakInterval = newSetting
//        
//        let result = Double((settingsHandler.shortBreakInterval.currentValue))! == 43.0 ? true : false
//        XCTAssert(result, "task Duration Updated Failed \((settingsHandler.shortBreakInterval.currentValue))!)  ==> Fail")
//        
//        if result == true {settingsHandler.shortBreakInterval = currSetting}
//    }
//    
//    
//    func testDailyGoal() {
//        XCTAssert(Double((settingsHandler.dailyGoal.currentValue))! == 5.0, "task Duration does not match ==> Fail")
//    }
//    
//    
//    func testDailyGoalUpdate() {
//        let currSetting = settingsHandler.dailyGoal
//        let newSetting = Setting(displayName: (currSetting.displayName), currentValue: "43.0", listOfValues: currSetting.listOfValues)
//        settingsHandler.dailyGoal = newSetting
//        
//        let result = Double((settingsHandler.dailyGoal.currentValue))! == 43.0 ? true : false
//        XCTAssert(result, "task Duration Updated Failed \((settingsHandler.dailyGoal.currentValue))!)  ==> Fail")
//        
//        if result == true {settingsHandler.dailyGoal = currSetting}
//    }
//    
//    func testVibrateON() {
//        XCTAssert(Double((settingsHandler.isVibrateOn.currentValue))! == 0.0, "Vibrate Check Failed")
//    }
//    
//    
//    func testVibrateUpdate() {
//        let currSetting = settingsHandler.isVibrateOn
//        let newSetting = Setting(displayName: (currSetting.displayName), currentValue: "1.0", listOfValues: currSetting.listOfValues)
//        settingsHandler.isVibrateOn = newSetting
//        
//        let result = Double((settingsHandler.isVibrateOn.currentValue))! == 1.0 ? true : false
//        XCTAssert(result, "task Duration Updated Failed \((settingsHandler.isVibrateOn.currentValue))!)  ==> Fail")
//        
//        if result == true {settingsHandler.isVibrateOn = currSetting}
//        
//    }
    
}
