//
//  TaskGeneratorSetup.swift
//  TimerDemoTests
//
//  Created by Moorthy, Prashanth on 2/16/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import XCTest

class TaskGeneratorSetup: XCTestCase {
    
    func readTaskExpectedResultsFile() -> [Task]{
        let expecteDResultArr = NSArray.init(contentsOf: self.expectedResultsFilePath)! as! [[String:Any?]]
        let expectedResTasks = expecteDResultArr.map({return Task.init(firebaseDict: $0)})
        return expectedResTasks as! [Task]
    }
    
    var timer : Timer!
    var taskList = [Task]()
    
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
    
    var expectedResultsFilePath : URL {
        let libDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return libDir.appendingPathComponent("expectedResult.plist")
    }
    
    func testTempTestGenTaskForToday(){
        createTaskForToday()
        sleep(3)
        createTaskForLastWeek()
        sleep(3)
        createTaskForThisMonth()
        sleep(3)
    }
    
    func createTaskForToday(){
        
        let taskColl1 = createTaskColl(taskName: "Task Today 1")
        let taskColl2 = createTaskColl(taskName: "Task Today 2")

        var tempTaskList = [Task]()
        
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl1.taskName, timePeriod: .today, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl2.taskName, timePeriod: .today, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 8))

        self.saveTaskList(taskList: tempTaskList)
    }

    
    func createTaskForLastWeek(){
        
        let taskColl1 = createTaskColl(taskName: "Last Week 1")
        let taskColl2 = createTaskColl(taskName: "Last Week 2")
        let taskColl3 = createTaskColl(taskName: "Last Week 3")
        let taskColl4 = createTaskColl(taskName: "Last Week 4")

        var tempTaskList = [Task]()
        
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl1.taskName, timePeriod: .lastWeek, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 1))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl2.taskName, timePeriod: .lastWeek, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 2))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl3.taskName, timePeriod: .lastWeek, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl4.taskName, timePeriod: .lastWeek, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 4))

        self.saveTaskList(taskList: tempTaskList)
    }

    
    func createTaskForYesterday(){
        sleep(2)
        let taskColl1 = createTaskColl(taskName: "Yesterday 1")
        let timePeriod = TimePeriod.yesterday
        
        var tempTaskList = [Task]()
        
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl1.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 5))
        
        self.saveTaskList(taskList: tempTaskList)
    }
    
    
    func createTaskForThisWeek(){
        
        let taskColl1 = createTaskColl(taskName: "ThisWeek 1")
        let taskColl2 = createTaskColl(taskName: "ThisWeek 2")
        
        let timePeriod = TimePeriod.week
        
        var tempTaskList = [Task]()
        
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl1.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl2.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 8))
        
        self.saveTaskList(taskList: tempTaskList)
    }

    func createTaskForThisMonth(){
        let taskColl1 = createTaskColl(taskName: "This Month 1")
        let taskColl2 = createTaskColl(taskName: "This Month 2")
        let taskColl3 = createTaskColl(taskName: "This Month 3")
        let taskColl4 = createTaskColl(taskName: "This Month 4")
        let taskColl5 = createTaskColl(taskName: "This Month 5")
        let taskColl6 = createTaskColl(taskName: "This Month 6")
        let taskColl7 = createTaskColl(taskName: "This Month 7")
        let taskColl8 = createTaskColl(taskName: "This Month 8")
        let taskColl9 = createTaskColl(taskName: "This Month 9")
        let taskColl10 = createTaskColl(taskName: "This Month 10")
        let taskColl11 = createTaskColl(taskName: "This Month 11")
        let taskColl12 = createTaskColl(taskName: "This Month 12")
        let taskColl13 = createTaskColl(taskName: "This Month 13")
        let taskColl14 = createTaskColl(taskName: "This Month 14")

        let timePeriod = TimePeriod.month
        
        var tempTaskList = [Task]()
        
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl1.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl2.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl3.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl4.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl5.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl6.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl7.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl8.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl9.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl10.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl11.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl12.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl13.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))
        tempTaskList.append(contentsOf: createTasks(taskName: taskColl14.taskName, timePeriod: timePeriod, taskType: .deepFocus, taskStatus: .completed, duration: 500, numberOfTasks: 3))

        self.saveTaskList(taskList: tempTaskList)
    }

    
    func createTasksData()  {
        
        var taskName = "Task Today"
        
        let taskColl = createTaskColl(taskName: taskName)
        
        let expectationSaveColl = XCTestExpectation(description: "Login to Fire base")
        
        PersistenceHandler.shared.fetchTaskCollectionWithName(taskName: taskName) { (theTaskColl) in
            if theTaskColl == nil {
                PersistenceHandler.shared.saveTaskCollection(taskColl: taskColl, completionHandler: { (theTaskCollKey) in
                    print("We Save the TaskColl with Key : \(theTaskCollKey)")
                    expectationSaveColl.fulfill()
                })
            }else{
                expectationSaveColl.fulfill()
            }
        }
        
        wait(for: [expectationSaveColl], timeout: 10.0)
        
        var tempTaskList = [Task]()
        
        // Crate tasks for Today.
//        taskList.append(contentsOf: createTasks(taskName: "Task Today X", timePeriod: .today, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 3))
//        taskList.append(contentsOf: createTasks(taskName: "Task Today Z", timePeriod: .today, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 8))
//        taskList.append(contentsOf: createTasks(taskName: "Task Yesterday", timePeriod: .yesterday, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 5))
        //taskList.append(contentsOf: createTasks(taskName: "Task This Week", timePeriod: .week, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 5))
//        taskList.append(contentsOf: createTasks(taskName: "Task Last Week", timePeriod: .lastWeek, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 5))
        tempTaskList.append(contentsOf: createTasks(taskName: "Task This Month", timePeriod: .month, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 5))
//        taskList.append(contentsOf: createTasks(taskName: "Task Last Month", timePeriod: .lastMonth, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 5))
//        taskList.append(contentsOf: createTasks(taskName: "Task This Year", timePeriod: .thisYear, taskType: .deepFocus, taskStatus: .completed, duration: 600, numberOfTasks: 5))
        
        saveTaskList(taskList: tempTaskList)
    }
    
    
    func saveTaskList(taskList : [Task]){
        var allExpecations = [XCTestExpectation]()
        
        var taskListDict = [[String:Any?]]()
        
        for eachtask in taskList{
            var dict = eachtask.dictFormat
            dict["savedDate"] = (eachtask.timer.endTime?.timeIntervalSince1970)! * 1000
            taskListDict.append(dict)
        }
        
        NSArray.init(array: taskListDict).write(to: expectedResultsFilePath, atomically: true)
        
        print(NSKeyedArchiver.archiveRootObject(taskListDict, toFile: "/Users/i328244/Library/Developer/CoreSimulator/Devices/D082DAD9-7F38-452D-A46B-2768A0B9A11C/data/Containers/Data/Application/855E9472-BE3A-409C-AF64-7E7DC51919F2/Documents/expectedResult.plist"))
        print(expectedResultsFilePath)
        
        for eachTask in taskList{
            let expectationSaveTask = XCTestExpectation(description: "Expectation Save Task")
            allExpecations.append(expectationSaveTask)
            PersistenceHandler.shared.saveTaskWithSavedDateTO_BE_USED_ONLY_FOR_TESTING(task: eachTask, completionHandler: { (savedTaskID) in
                expectationSaveTask.fulfill()
            })
            wait(for: [expectationSaveTask], timeout: 10.0)
        }
        wait(for: allExpecations, timeout: 10.0)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    func testTaskCreation() {
    //        createTasksData()
    //    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //
    //    func testExample() {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //        setupTestTasks()
    //    }
    
    // Setup Test Tasks
    func setupTestTasks(){
        createCreateTaskCollections()
    }
    
    func testA2FetchAllTasksCreatedYesterday(){
        
        let expecation = XCTestExpectation(description: "Wait for Fetch all todays tasks")
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: .yesterday) { (taskList) in
            XCTAssertNotNil(taskList, "🐞🐞  Task list is nil")
            XCTAssertTrue(!taskList.isEmpty, "🐞🐞 Task List is Empty !!")
            print("✅ taskList is \(taskList)")
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 10.0)
    }
    
    func testA3FetchAllTasksCreatedThisWeek(){
        
        let expecation = XCTestExpectation(description: "Wait for Fetch all todays tasks")
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: .week) { (fetchedTaskList) in
            XCTAssertNotNil(fetchedTaskList, "🐞🐞  Task list is nil")
            XCTAssertTrue(!fetchedTaskList.isEmpty, "🐞🐞 Task List is Empty !!")
            print("✅ taskList is \(fetchedTaskList)")
            
            let expecteDResultArr = NSArray.init(contentsOf: self.expectedResultsFilePath)! as! [[String:Any?]]
            let expectedResTasks = expecteDResultArr.map({return Task.init(firebaseDict: $0)})
            
            let expecteDResult = expectedResTasks.filter(
            {
                return ((($0?.savedDate!)!  > Date().startWeek.timeIntervalSince1970 * 1000) && ($0?.timer.endTime?.timeIntervalSince1970)! * 1000 < Date().endWeek.timeIntervalSince1970 * 1000)
            })
            
            XCTAssertTrue(expecteDResult.count == fetchedTaskList.count, "🐞🐞  This Week : Count of Items Fetched does not match count of Items Loaded \(expecteDResult.count) vs \(fetchedTaskList.count)")
            
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 10.0)
    }
    
    
    func testA4FetchAllTasksCreatedLastWeek(){
        
        let expecation = XCTestExpectation(description: "Wait for Fetch all todays tasks")
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: "Task Last Week", timePeriod: .lastWeek) { (taskList) in
            XCTAssertNotNil(taskList, "🐞🐞  Task list is nil")
            print("✅ taskList is \(taskList)")
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 10.0)
    }
    
    func testA5FetchAllTasksCreatedThisMonth(){
        
        let expecation = XCTestExpectation(description: "Wait for Fetch all todays tasks")
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: .month) { (taskList) in
            XCTAssertNotNil(taskList, "🐞🐞  Task list is nil")
            print("✅ taskList is \(taskList)")
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 10.0)
    }
    
    
    func testA1FetchAllTasksCreatedToday(){
        
        let expecation = XCTestExpectation(description: "Wait for Fetch all todays tasks")
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: .today) { (taskList) in
            XCTAssertNotNil(taskList, "🐞🐞  Task list is nil")
            XCTAssertTrue(!taskList.isEmpty, "🐞🐞 Task List is Empty !!")
            print("✅ taskList is \(taskList)")
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 10.0)
    }
    
    
    func createCreateTasks(Collection : TaskCollection){
        
    }
    
    func createCreateTaskCollections(){
        
        var taskCreateExpArr = [XCTestExpectation]()
        
        let taskColl = self.makeTaskCollection(fromFile: self.taskCollFilePath, taskArr: [], pauses: [])
        
        taskColl.forEach({
            let expectationSaveColl = XCTestExpectation(description: "Login to Fire base")
            taskCreateExpArr.append(expectationSaveColl)
            PersistenceHandler.shared.saveTaskCollection(taskColl: $0, completionHandler: { (theTaskCollKey) in
                print("We Save the TaskColl with Key : \(theTaskCollKey)")
                expectationSaveColl.fulfill()
            })
            
        })
        
        wait(for: taskCreateExpArr, timeout: 10.0)
        
        let allPauses = self.makePauses(fromFile: self.self.taskPauseFilePath)
        let allTasks = self.makeTasks(fromFile: self.self.tasksFilePath, pauses: allPauses)
        
        //        let expectation1 = XCTestExpectation(description: "Expectation 1 : Waiting to get back all taskes")
        
        var allExpecations = [XCTestExpectation]()
        //allExpecations.append(expectation1)
        
        for eachTask in allTasks{
            let expectationSaveTask = XCTestExpectation(description: "Expectation Save Task")
            allExpecations.append(expectationSaveTask)
            PersistenceHandler.shared.saveTask(task: eachTask, completionHandler: { (savedTaskID) in
                expectationSaveTask.fulfill()
            })
            wait(for: [expectationSaveTask], timeout: 10.0)
        }
        
        
        wait(for: allExpecations, timeout: 10.0)
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
    
    
    func makeTasks(fromFile : String, pauses : [Pause]) -> [Task]{
        
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
                    
                    // Process the Pauses.
                    let pauseArr = (tempDict["pauseList"] as! String).components(separatedBy: ";")
                    var tempPauseArr : [[String:Any?]] = []
                    
                    for eachPause in pauseArr{
                        let thePause = pauses.filter({return $0.reason == eachPause})
                        
                        // We are reversing what we did earlier..but what the heck.
                        //i.e we created a Pause frmo a dict and noww we are recreateing the dict.. but yeah.. its just a test for now.
                        
                        for eachFetchedPause in thePause{
                            var tempPauseDict = [String:Any?]()
                            tempPauseDict["endTime"] = eachFetchedPause.endTime?.timeIntervalSince1970
                            tempPauseDict["startTime"] = eachFetchedPause.startTime.timeIntervalSince1970
                            tempPauseDict["reason"] = eachFetchedPause.reason
                            tempPauseArr.append(tempPauseDict)
                        }
                    }
                    
                    tempDict["pauseList"] = tempPauseArr
                    
                    let testTask = Task(firebaseDict: tempDict)
                    XCTAssertNotNil(testTask, "😈 Task was not created => \(String(describing: tempDict["taskName"]))")
                    allTasksArr.append(testTask!)
                    allTasksArr.forEach({print($0)})
                }
            }
        }
        
        return allTasksArr
    }
    
    func saveTaskSlowly(taskArr : [Task], indexToSave : Int){
        PersistenceHandler.shared.saveTask(task: taskArr[indexToSave], completionHandler: { (savedTaskID) in
            print("Have Saved task ID : \(savedTaskID)")
        })
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
                    tempDict["reason"] = (tempDict["pauseList.Reason"] as! String).replacingOccurrences(of: "\r", with: "")
                    
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
    
    
    
    
    func createTaskColl(taskName : String) -> TaskCollection {
        let taskColl = TaskCollection.init(taskName: taskName)
        return taskColl
    }
    
    func createTasksForTimePeriod(taskName : String, timePeriod : TimePeriod, taskType : TaskType, duration : CFTimeInterval, numberOfTasks : Int) -> [Task] {
        
        var retTaskArr = [Task]()
        
        for _ in 0..<numberOfTasks{
            let tempTask = Task(name: taskName, type: taskType)
            tempTask.taskDuration = duration
            retTaskArr.append(tempTask)
        }
        
        return retTaskArr
    }
    
    func createTasks(taskName : String, timePeriod : TimePeriod, taskType : TaskType, taskStatus : TaskStatus, duration : CFTimeInterval,numberOfTasks : Int = 1) -> [Task] {
        
        var retTasksArr = [Task]()
        
        for _ in 0..<numberOfTasks{
            
            let rangeOfSeconds = UInt32(randomNumber(MIN: timePeriod.startDate.timeIntervalSince1970, MAX: timePeriod.endDate.timeIntervalSince1970))
            
            var totalPauseTime : TimeInterval = 0
            
            var pauses = [Pause]()
            let maxPauses = arc4random_uniform(3)
            
            let taskStartDate = timePeriod.startDate.timeIntervalSince1970 + TimeInterval(arc4random_uniform(rangeOfSeconds))
            
            if maxPauses > 0{
                for _ in 0..<maxPauses{
                    
                    var tempPauseDict = [String:Any?]()
                    tempPauseDict["endTime"] = timePeriod.startDate.timeIntervalSince1970 + randomNumber(MIN: 50, MAX: 500)
                    tempPauseDict["startTime"] = taskStartDate
                    tempPauseDict["reason"] = "Automate Reason"
                    
                    let tempPause = Pause.init(firebaseDict: tempPauseDict)
                    pauses.append(tempPause!)
                }
            }
            
            pauses.forEach({totalPauseTime += $0.duration!})
            
            let taskEndDate = timePeriod.startDate.timeIntervalSince1970 + duration // + totalPauseTime (Pauses are messing this up) Commenting for now.
            
            var tempTimerDict = [String:Any?]()
            tempTimerDict["duration"] = duration
            tempTimerDict["currentTimerValue"] = 0.0
            tempTimerDict["startTime"] = taskStartDate
            tempTimerDict["endTime"] = taskEndDate
            
            let tempTimer = TimerBoy.init(firebaseDict: tempTimerDict)
            
            let tempTask = Task(name: taskName, type: taskType)
            tempTask.timer = tempTimer
            tempTask.pauseList = pauses
            tempTask.taskDuration = duration
            tempTask.taskStatus = .completed
            
            retTasksArr.append(tempTask)
            
        }
        
        return retTasksArr
        
    }
    
    
    
    func randomNumber(MIN: TimeInterval, MAX: TimeInterval)-> TimeInterval{
        return TimeInterval(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
    
}
