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
    }

    var taskCollFilePath : String {
        let theBundle = Bundle(for: type(of: self))
        return theBundle.path(forResource: "TimerDemoTestData_TaskColl", ofType: "csv")!

    }

    var taskPauseFilePath : String {
        let theBundle = Bundle(for: type(of: self))
        return theBundle.path(forResource: "TimerDemoTestData_Pause", ofType: "csv")!
        
    }


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
        var allTasksStrArr = [String]()
        var allTasksArr = [Task]()

        var pauseHeaders = [String]()
        var allPauses = Set<String>()
        var allPausesStrArr = [String]()
        
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
                let allTasksSet = Set.init(dataArray[1..<dataArray.count])
                allTasksStrArr = allTasksSet.filter({return !($0.isEmpty)})
                
                for eachTaskStr in allTasksStrArr{
                    let taskDetails = eachTaskStr.components(separatedBy: ",")
                    var tempDict = [String:Any?]()
                    for (index,value) in taskDetails.enumerated(){
                        tempDict[taskHeaders[index]] = value
                    }
                    
                    // Create a saved date
                    if let savedDate = tempDict["savedDate"] as? String{
                        tempDict["savedDate"] = makeDateFromString(dateString: savedDate)?.timeIntervalSince1970 ?? assertionFailure("Cant make the date")
                    }
                    
                    // Make the Timer
                    let timerDuration = TimeInterval((tempDict["timer.duration"] as! String))
                    let timerEndTime = makeDateFromString(dateString: (tempDict["timer.endTime"] as! String))?.timeIntervalSince1970
                    let timerStartTime = makeDateFromString(dateString: (tempDict["timer.startTime"] as! String))?.timeIntervalSince1970
                    let currTimerValue = TimeInterval((tempDict["timer.currentTimerValue"] as! String))

                    tempDict["timer"] = ["duration" : timerDuration, "startTime" : timerStartTime, "endTime" : timerEndTime, "currentTimerValue" : currTimerValue]
                    
                    let testTask = Task(firebaseDict: tempDict)
                    XCTAssertNotNil(testTask, "😈 Task was not created => \(String(describing: tempDict["taskName"]))")
                    allTasksArr.append(testTask!)
                    allTasksArr.forEach({print($0)})
                }                
            }
        }
        
        // First : Read the task Collection File. Create a Task Collection on Firebase.
        if let taskPauseData = FileManager.default.contents(atPath: taskPauseFilePath){
            if let dataString = String.init(data: taskPauseData, encoding: .utf8){
                
                let dataArray = dataString.components(separatedBy: "\n")
                pauseHeaders = dataArray[0].components(separatedBy: ",")
                allPauses = Set.init(dataArray[1..<dataArray.count])
                allPausesStrArr = allPauses.filter({return !($0.isEmpty)})
                
                for eachPause in allPausesStrArr{
                    let pauseDetails = eachPause.components(separatedBy: ",")
                    
                    var tempDict = [String:Any?]()
                    for (index,value) in pauseDetails.enumerated(){
                        tempDict[pauseHeaders[index]] = value
                    }
                    
                    let pauseEndTime = makeDateFromString(dateString: (tempDict["pauseList.endTime"] as! String))?.timeIntervalSince1970
                    let pauseStartTime = makeDateFromString(dateString: (tempDict["pauseList.startTime"] as! String))?.timeIntervalSince1970

                    //pauseList.Id,pauseList.startTime,pauseList.endTime,pauseList.Reason
                    
                    tempDict["pauseList.endTime"] = pauseEndTime
                    tempDict["pauseList.startTime"] = pauseStartTime
                    
                    print("We Made a pause -- 😈😈😈😈😈😈😈😈😈😈😈😈😈")
                    print(tempDict)
                }
                
                

            }
        }
  
        print("\n\n ==================================")
        print(taskCollHeaders)
        print(allTaskColl)
        print("\n\n")
        print(taskHeaders)
        print(allTasks)
        print("\n\n")
        print(pauseHeaders)
        print(allPauses)
        print("==================================\n\n")
    }

    
    func makeDateFromString(dateString : String) -> Date?{
        let dateF = DateFormatter()
        dateF.dateFormat = "dd/mm/yy hh:mm:ss"
        return dateF.date(from: dateString) ?? nil
    }
    
}
