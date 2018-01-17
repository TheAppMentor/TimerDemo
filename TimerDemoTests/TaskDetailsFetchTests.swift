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
        
        
        let taskColl = self.makeTaskCollection(fromFile: self.taskCollFilePath, taskArr: [], pauses: [])
        taskColl.forEach({PersistenceHandler.shared.saveTaskCollection(taskColl: $0)})
        
        let allTasks = self.makeTasks(fromFile: self.self.tasksFilePath)
        for eachTask in allTasks{
            TaskManager.shared.currentTask = eachTask
            TaskManager.shared.archiveCurrentTask()
        }
        
        
        let expectation1 = XCTestExpectation(description: "Waiting to get back all taskes")
        
        PersistenceHandler.shared.fetchAllTasksMatchingArray(taskIDArray: allTasks.map({return $0.taskName})) { (retArr) in
            print("We Got back \(retArr)")
            
            expectation1.fulfill()
        }
        
        wait(for: [expectation1], timeout: 10.0)
        
        let allPauses = self.makePauses(fromFile: self.self.taskPauseFilePath)
        //let taskColl = self.makeTaskCollection(fromFile: self.taskCollFilePath, taskArr: allTasks, pauses: allPauses)
    }

    

    
    
    
    
    
    
    
    
    
    
    
    
    func makeDateFromString(dateString : String) -> Date?{
        let dateF = DateFormatter()
        dateF.dateFormat = "dd/mm/yy hh:mm:ss"
        return dateF.date(from: dateString) ?? nil
    }
    
    
    func makeTaskCollection(fromFile : String, taskArr : [Task], pauses : [Pause]) -> [TaskCollection]{
        
        var taskCollHeaders = [String]()
        var allTaskCollSet = Set<String>()
        var allTaskCollStrArr = [String]()
        var allTaskColl = [TaskCollection]()
        
        if let taskCollData = FileManager.default.contents(atPath: taskCollFilePath){
            if let dataString = String.init(data: taskCollData, encoding: .utf8){
                
                let dataArray = dataString.components(separatedBy: "\n")
                taskCollHeaders = dataArray[0].components(separatedBy: ",")
                allTaskCollSet = Set.init(dataArray[1..<dataArray.count])
                allTaskCollStrArr = allTaskCollSet.filter({return !($0.isEmpty)})
                
                // Make the Task Collections.
                for eachTaskCollStr in allTaskCollStrArr{
                    let eachTaskCollStrCleaned = eachTaskCollStr.replacingOccurrences(of: "\r", with: "\n")
                    let taskCollArr = eachTaskCollStrCleaned.components(separatedBy: ",")
                    var tempDict = [String:Any?]()
                    for (index,value) in taskCollArr.enumerated(){
                        tempDict[taskCollHeaders[index]] = value
                    }
                    
                    // Get list of task IDs
                    
                    let taskColl = TaskCollection(taskName: tempDict["taskName"] as! String)
                    XCTAssertNotNil(taskColl, "😈 Task Coll was not created => \(tempDict)")
                    allTaskColl.append(taskColl)


                    
//                    let taskList = tempDict["listOfAssociatedTaskID"] as! String
//                    let associatedTaskID = taskList.components(separatedBy: ";")
//                    tempDict["listOfAssociatedTaskID"] = associatedTaskID
//                    
//                    // Calc stuff related to tasks.
//                    // totalDurationTasksAllStatus
//                    
//                    let filteredTaskList = taskArr.filter({
//                        return associatedTaskID.contains($0.taskName)
//                    })
//                    
//                    var totalDurationTasksAllStatus : CFTimeInterval = 0
//                    var totalDurationCompletedTasks : CFTimeInterval = 0
//                    
//                    filteredTaskList.forEach({totalDurationTasksAllStatus += $0.taskDuration})
//                    filteredTaskList.filter({return $0.taskStatus == .completed}).forEach({totalDurationCompletedTasks += $0.taskDuration})
//                    
//                    tempDict["totalDurationTasksAllStatus"] = totalDurationTasksAllStatus
//                    tempDict["totalDurationCompletedTasks"] = totalDurationCompletedTasks
//                    tempDict["numberOfSessionsAllStatus"] = filteredTaskList.count
//                    tempDict["numberOfSessionsCompletedStatus"] = filteredTaskList.filter({return $0.taskStatus == .completed}).count
//
////                    let taskColl = TaskCollection.init(firebaseDict: tempDict)

                }
            }
        }
        
        return allTaskColl
    }
    
    
    func makeTasks(fromFile : String) -> [Task]{
        
        var taskHeaders = [String]()
        var allTasksStrArr = [String]()
        var allTasksArr = [Task]()

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
        
        return allTasksArr
    }
    
    func makePauses(fromFile : String) -> [Pause]{
        
        var pauseHeaders = [String]()
        var allPauses = Set<String>()
        var allPausesStrArr = [String]()
        var allPausesArr = [Pause]()

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
                    
                    tempDict["endTime"] = pauseEndTime
                    tempDict["startTime"] = pauseStartTime
                    tempDict["reason"] = tempDict["pauseList.Reason"]
                    
                    print("We made a pause -- 😈😈😈😈😈😈😈😈😈😈😈😈😈")
                    print(tempDict)
                    let thePause = Pause.init(firebaseDict: tempDict)
                    XCTAssertNotNil(thePause, "😈 Pause was not created => \(String(describing: tempDict["taskName"]))")
                    allPausesArr.append(thePause!)
                }
            }
        }
        
        return allPausesArr
        
    }
    
}
