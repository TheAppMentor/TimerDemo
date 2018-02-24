//
//  TaskCollectionTests.swift
//  TimerDemoTests
//
//  Created by Prashanth Moorthy on 27/01/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import XCTest

class TaskCollectionTests: XCTestCase {
    
    let taskGen = TaskGeneratorSetup()
    
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
    
    
    
    
    func testTotalNumberOfSessionsToday() {

        taskGen.createTaskForToday()
        let timePeriodToTest : TimePeriod = .today
        
        let expect1 = XCTestExpectation.init(description: "Wait for task fetch from firebase")
        
        var numberOfTasks = 0
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: timePeriodToTest) { (taskList) in
            
            let taskNames = taskList.map({$0.taskName})
            let unqTaskNamesArr = Array.init(Set.init(taskNames))

            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: unqTaskNamesArr, completionHandler: { (taskCollArr) in

                // Meat of this test is here.....
                let taskListingViewModel = TaskListingViewModel.init(taskList: taskList, taskCollectionList: taskCollArr)
                for eachRow in 0..<taskListingViewModel.numberOfTasks(){
                    numberOfTasks += taskListingViewModel.numberOfSessionsInTaskCollectionAtIndex(indexPath: IndexPath.init(row: eachRow, section: 0))
                }
               expect1.fulfill()
            })
        }
        
        wait(for: [expect1], timeout: 20.0)

        XCTAssertEqual(numberOfTasks, 11, "Mismatch in number of tasks.....")
        
        addTeardownBlock {
            PersistenceHandler.shared.deleteTaskColl(taskName: "Task Today 1")
            PersistenceHandler.shared.deleteTaskColl(taskName: "Task Today 2")
        }
    }

    
    func testTotalNumberOfSessionsYesterday() {

        taskGen.createTaskForYesterday()
        let timePeriodToTest : TimePeriod = .yesterday
        
        let expect1 = XCTestExpectation.init(description: "Wait for task fetch from firebase")
        
        var numberOfTasks = 0
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: timePeriodToTest) { (taskList) in
            
            let taskNames = taskList.map({$0.taskName})
            let unqTaskNamesArr = Array.init(Set.init(taskNames))
            
            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: unqTaskNamesArr, completionHandler: { (taskCollArr) in
                
                // Meat of this test is here.....
                let taskListingViewModel = TaskListingViewModel.init(taskList: taskList, taskCollectionList: taskCollArr)
                for eachRow in 0..<taskListingViewModel.numberOfTasks(){
                    numberOfTasks += taskListingViewModel.numberOfSessionsInTaskCollectionAtIndex(indexPath: IndexPath.init(row: eachRow, section: 0))
                }
                expect1.fulfill()
            })
        }
        
        wait(for: [expect1], timeout: 20.0)
        
        XCTAssertEqual(numberOfTasks, 5, "Mismatch in number of tasks.....")
        
        addTeardownBlock {
            PersistenceHandler.shared.deleteTaskColl(taskName: "Yesterday 1")
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    func testNumberOfTasksToday() {

        taskGen.createTaskForToday()

        let timePeriodToTest : TimePeriod = .today

        let expect1 = XCTestExpectation.init(description: "Wait for task fetch from firebase")
        
        var numberOfTasksToday = 0
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: timePeriodToTest) { (taskList) in
            let taskNames = taskList.map({$0.taskName})
            let uniqueTasknames = Set.init(taskNames)
            let unqTaskNamesArr = Array.init(uniqueTasknames)
            
            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: unqTaskNamesArr, completionHandler: { (taskCollArr) in
                
                // Meat of this test is here.....
                let taskListingViewModel = TaskListingViewModel.init(taskList: taskList, taskCollectionList: taskCollArr)
                numberOfTasksToday = taskListingViewModel.numberOfTasks()
                
                expect1.fulfill()
            })
        }
        
        wait(for: [expect1], timeout: 10.0)
        
        
        XCTAssertEqual(numberOfTasksToday, 2, "Mismatch in number of tasks.....")
        addTeardownBlock {
            PersistenceHandler.shared.deleteTaskColl(taskName: "Task Today 1")
            PersistenceHandler.shared.deleteTaskColl(taskName: "Task Today 2")
        }
    }

    func testNumberOfTasksYesterday() {
        taskGen.createTaskForYesterday()
        
        let timePeriodToTest : TimePeriod = .yesterday
        
        let expect1 = XCTestExpectation.init(description: "Wait for task fetch from firebase")
        
        var numberOfTasksYesterday = 0
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: timePeriodToTest) { (taskList) in
            let taskNames = taskList.map({$0.taskName})
            let uniqueTasknames = Set.init(taskNames)
            let unqTaskNamesArr = Array.init(uniqueTasknames)
            
            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: unqTaskNamesArr, completionHandler: { (taskCollArr) in
                
                // Meat of this test is here.....
                let taskListingViewModel = TaskListingViewModel.init(taskList: taskList, taskCollectionList: taskCollArr)
                numberOfTasksYesterday = taskListingViewModel.numberOfTasks()
                
                expect1.fulfill()
            })
        }
        
        wait(for: [expect1], timeout: 10.0)
        
        
        XCTAssertEqual(numberOfTasksYesterday, 1, "Mismatch in number of tasks.....")
        addTeardownBlock {
            PersistenceHandler.shared.deleteTaskColl(taskName: "Yesterday 1")
        }
    }


    //totalDurationOfTasksInCollectionAtIndex
    func testTotaDurationOfAllTaskToday() {

        taskGen.createTaskForToday()
        
        let timePeriodToTest : TimePeriod = .today
        
        let expect1 = XCTestExpectation.init(description: "Wait for task fetch from firebase")
        
        var totalDurationTask : CFTimeInterval = 0
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: timePeriodToTest) { (taskList) in
            
            let taskNames = taskList.map({$0.taskName})
            let unqTaskNamesArr = Array.init(Set.init(taskNames))
            
            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: unqTaskNamesArr, completionHandler: { (taskCollArr) in
                
                // Meat of this test is here.....
                let taskListingViewModel = TaskListingViewModel.init(taskList: taskList, taskCollectionList: taskCollArr)
                for eachRow in 0..<taskListingViewModel.numberOfTasks(){
                    totalDurationTask += taskListingViewModel.totalDurationOfTasksInCollectionAtIndex(indexPath: IndexPath.init(row: eachRow, section: 0), taskStatus: .completed)
                }
                expect1.fulfill()
            })
        }
        
        addTeardownBlock {
            PersistenceHandler.shared.deleteTaskColl(taskName: "Task Today 1")
            PersistenceHandler.shared.deleteTaskColl(taskName: "Task Today 2")
        }
        
        wait(for: [expect1], timeout: 10.0)
        
        XCTAssertEqual(totalDurationTask, 6600 , "Mismatch in number of tasks.....")

    }

    
    func testTotaDurationOfAllLastWeek() {

        taskGen.createTaskForLastWeek()
        
        let timePeriodToTest : TimePeriod = .lastWeek
        
        let expect1 = XCTestExpectation.init(description: "Wait for task fetch from firebase")
        
        var totalDurationTask : CFTimeInterval = 0
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: timePeriodToTest) { (taskList) in
            
            let taskNames = taskList.map({$0.taskName})
            let unqTaskNamesArr = Array.init(Set.init(taskNames))
            
            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: unqTaskNamesArr, completionHandler: { (taskCollArr) in
                
                // Meat of this test is here.....
                let taskListingViewModel = TaskListingViewModel.init(taskList: taskList, taskCollectionList: taskCollArr)
                for eachRow in 0..<taskListingViewModel.numberOfTasks(){
                    totalDurationTask += taskListingViewModel.totalDurationOfTasksInCollectionAtIndex(indexPath: IndexPath.init(row: eachRow, section: 0), taskStatus: .completed)
                }
                expect1.fulfill()
            })
        }
        
        wait(for: [expect1], timeout: 10.0)
        
        XCTAssertEqual(totalDurationTask, 6000 , "Mismatch in number of tasks.....")

        addTeardownBlock {
            PersistenceHandler.shared.deleteTaskColl(taskName: "Last Week 1")
            PersistenceHandler.shared.deleteTaskColl(taskName: "Last Week 2")
            PersistenceHandler.shared.deleteTaskColl(taskName: "Last Week 3")
            PersistenceHandler.shared.deleteTaskColl(taskName: "Last Week 4")
        }
    }
    
    func testTotaDurationOfMonth() {

        taskGen.createTaskForThisMonth()
        let timePeriodToTest : TimePeriod = .month
        
        let expect1 = XCTestExpectation.init(description: "Wait for task fetch from firebase")
        
        var totalDurationTask : CFTimeInterval = 0
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: timePeriodToTest) { (taskList) in
            
            let taskNames = taskList.map({$0.taskName})
            let unqTaskNamesArr = Array.init(Set.init(taskNames))
            
            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: unqTaskNamesArr, completionHandler: { (taskCollArr) in
                
                // Meat of this test is here.....
                let taskListingViewModel = TaskListingViewModel.init(taskList: taskList, taskCollectionList: taskCollArr)
                for eachRow in 0..<taskListingViewModel.numberOfTasks(){
                    totalDurationTask += taskListingViewModel.totalDurationOfTasksInCollectionAtIndex(indexPath: IndexPath.init(row: eachRow, section: 0), taskStatus: .completed)
                }
                expect1.fulfill()
            })
        }
        
        wait(for: [expect1], timeout: 10.0)
        //
        //        let expectedTasks = taskGen.readTaskExpectedResultsFile()
        //        let expectedResult = expectedTasks.filter({$0.savedDate! > timePeriodToTest.startDate.timeIntervalSince1970 * 1000 && $0.savedDate! < timePeriodToTest.endDate.timeIntervalSince1970 * 1000})
        
        XCTAssertEqual(totalDurationTask, 3000 , "Mismatch in number of tasks.....")
        
        addTeardownBlock {
            
            PersistenceHandler.shared.deleteTaskColl(taskName: "This Month 1")
            PersistenceHandler.shared.deleteTaskColl(taskName: "This Month 2")

        }
    }

    
}
