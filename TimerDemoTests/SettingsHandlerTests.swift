//
//  SettingsHandlerTests.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/6/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import XCTest

class SettingsHandlerTests: XCTestCase {
    
    var settingsHandler = SettingsHandler.shared
    let settingsDict = NSMutableDictionary(contentsOfFile: Bundle.main.path(forResource: "Settings", ofType: "plist")!)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testCopyBundleToDocumentsDirectory() {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Settings.plist"
        print(documentDirectory)
        settingsHandler.copySettingsFileFromBundle()

        XCTAssert(FileManager.default.fileExists(atPath: documentDirectory), "copySettingsFileFromBundle() => Failed")
    }
    
    
    func testTaskDurationFetch() {
        XCTAssert(settingsHandler.taskDurationMinutes == 25.0, "task Duration does not match ==> Fail")
    }
    
    
    func testTaskDurationUpdate() {
        
        settingsHandler.taskDurationMinutes = 30.0
        
        let result = settingsHandler.taskDurationMinutes == 30.0 ? true : false
        
        XCTAssert(result, "task Duration Updated Failed ==> Fail")
        
        if result == true{
            settingsHandler.taskDurationMinutes = 25.0
        }
    }
    
    func testShortBreakDurationRead() {
        XCTAssert(settingsHandler.shortBreakDurationMinutes == 5.0, "testShortBreakDurationRead does not match ==> Fail")
    }

    func testShortBreakDurationUpdate() {
        settingsHandler.taskDurationMinutes = 15.0
        XCTAssert(settingsHandler.taskDurationMinutes == 15.0, "testShortBreakDurationUpdate  Updated Failed ==> Fail")
        
    }
    
    
    func testlongBreakDurationMinutes() {
        XCTAssert(settingsHandler.longBreakDurationMinutes == 25.0, "testlongBreakDurationMinutes => Failed")
    }
    
    func testLongBreakDurationUpdate() {
        let result = settingsHandler.longBreakDurationMinutes == 25.0 ? true : false
        
        XCTAssert(result, "longBreakDurationMinutes Updated Failed ==> Fail")
        
        if result == true{
            settingsHandler.longBreakDurationMinutes = 25.0
        }
    }
    
    func testShortBreakInterval() {
        XCTAssert(settingsHandler.shortBreakInterval == 1, "testShortBreakInterval => Read Failed.")
    }
    
    
    func testShortBreakshortBreakIntervalUpdate() {
        settingsHandler.shortBreakInterval = 5
        let result = settingsHandler.shortBreakInterval == 5 ? true : false
        
        XCTAssert(result, "testShortBreakshortBreakIntervalUpdate Updated Failed ==> Fail")
        
        if result == true{
            settingsHandler.shortBreakInterval = 1
        }
    }
    
    func testDailyGoal() {
        XCTAssert(settingsHandler.dailyGoal == 2, "Daily Goal Test Failed")
    }
    
    
    func testDailyGoalUpdate() {
        settingsHandler.dailyGoal = 5
        let result = settingsHandler.dailyGoal == 5 ? true : false
        
        XCTAssert(result, "testDailyGoalUpdate Updated Failed ==> Fail")
        
        if result == true{
            settingsHandler.dailyGoal = 2
        }
        
    }
    
    func testVibrateON() {
        XCTAssert(settingsHandler.isVibrateOn == false, "Vibrate Check Failed")
    }
    

    func testVibrateUpdate() {
        settingsHandler.isVibrateOn = true
        
        XCTAssert(settingsHandler.isVibrateOn == true, "Vibrate Update Failed.")
    
        settingsHandler.isVibrateOn = false
    }
    
}
