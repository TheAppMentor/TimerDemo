//
//  TaskDetailsFetchTests.swift
//  TimerDemoTests
//
//  Created by Moorthy, Prashanth on 1/15/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import XCTest

class TaskDetailsFetchTests: XCTestCase {
    
    var tasksFilePath : String{
        
        let theBundle = Bundle(for: type(of: self))
        return theBundle.path(forResource: "TimerDemoTestData_Tasks", ofType: "csv")!
      
        //"/Users/i328244/Desktop/XCode Projects/TimerDemo/TimerDemo/TimerDemoTestData_Tasks.csv"
    }

    var taskCollFilePath : String {
        let theBundle = Bundle(for: type(of: self))
        return theBundle.path(forResource: "TimerDemoTestData_TaskColl", ofType: "csv")!

    } //= "/Users/i328244/Desktop/XCode Projects/TimerDemo/TimerDemo/TimerDemoTestData_TaskColl.csv"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        setupTestTasks()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Setup Test Tasks
    func setupTestTasks(){
        createCreateTaskCollections()

    }

    func createCreateTasks(Collection : TaskCollection){
        
    }

    
    func createCreateTaskCollections(){
        
        var taskCollHeaders = [String]()
        var allTaskColl = Set<String>()
        
        var taskHeaders = [String]()
        var allTasks = Set<String>()

        var pauseHeaders = [String]()
        var allPauses = Set<String>()
        
        // First : Read the task Collection File. Create a Task Collection on Firebase.
        if let taskCollData = FileManager.default.contents(atPath: taskCollFilePath){
            if let dataString = String.init(data: taskCollData, encoding: .utf8){
                
                let dataArray = dataString.components(separatedBy: "\n")
                taskCollHeaders = dataArray[0].components(separatedBy: ",")
                allTaskColl = Set.init(dataArray[1..<dataArray.count])
            }
        }
        
        
        // Second : Create tasks and add them to it.
        
        
        if let taskData = FileManager.default.contents(atPath: tasksFilePath){
            if let dataString = String.init(data: taskData, encoding: .utf8){
                let dataArray = dataString.components(separatedBy: "\n")
                
                taskHeaders = dataArray[0].components(separatedBy: ",")
                allTasks = Set.init(dataArray[1..<dataArray.count])
//                guard let validTaskName = firebaseDict["taskName"] as? String else {return nil}
//                guard let validTaskType = firebaseDict["taskType"] as? String else {return nil}
//                guard let validSavedDate = firebaseDict["savedDate"] as? TimeInterval else {return nil}
//                //        guard let validPerfectTask = firebaseDict["isPerfectTask"] as? Bool else {return nil}
//                guard let validTimer = firebaseDict["timer"] as? [String : Any?] else {return nil}
//                guard let tempTaskStatus = firebaseDict["taskStatus"] as? String else {return nil}
//                guard let validTaskStatus = TaskStatus(rawValue: tempTaskStatus) else {return nil}
//
//                var validPauseList = [["":""]]
//
            }
        }
  
        print("\n\n ==================================")
        print(taskCollHeaders)
        print(allTaskColl)
        print("\n\n")
        print(taskHeaders)
        print(allTasks)
        print("==================================\n\n")
    }
    
    
}
