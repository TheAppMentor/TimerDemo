//
//  AnalyticsHanlderTests.swift
//  TimerDemoTests
//
//  Created by Moorthy, Prashanth on 3/1/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import XCTest

class AnalyticsHanlderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("Setup was called")
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Login to Fire base")
        
        if AuthHandler.shared.isLoggedIn{
            print("THe GUy is already logged in.")
            expectation.fulfill()
        }else{
            AuthHandler.shared.authenticateUser { (success, userInfo) in
                print("We have logged on :  \(success)")
                print("User info is : \(userInfo)")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        print("Login Was Successful!")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetTaskDetailsWithMaxTimeForToday(){
        
    }

    func testGetTaskDetailsWithMaxTimeForYesterday(){
        
    }

    func testGetTaskDetailsWithMaxTimeForThisWeek(){
        
    }

    func testGetTaskDetailsWithMaxTimeForThisMonth(){
        
        let expectation1 = XCTestExpectation(description: "Wait for Fetch all user info")
        
        AnalyticsHandler().getTaskDetailsWithMaxTime(timePeriod: .month) { (taskName, taskTotalDuration, taskTotalTime) in
            expectation1.fulfill()
        }

        wait(for: [expectation1], timeout: 20)
        
//        XCTAssertEqual(taskName, "TaskName", "Mismatch    ->   Task Name")
//        XCTAssertEqual(taskTotalDuration, "TaskName", "Mismatch    Does not Match")
        XCTAssertEqual("taskTotalTime", "TaskName", "Mismatch      Does not Match")

    }
}
