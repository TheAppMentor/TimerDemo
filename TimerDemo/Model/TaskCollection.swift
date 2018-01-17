//
//  TaskCollection.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct TaskCollection {
    
//    var description: String {
//        return "\n ---------------------------------------- \n Task Collection Description : \n  \t name : \t\t \(taskName) \n \t totalDurationTasksAllStatus : \t \(totalDurationTasksAllStatus) \n \t numberOfSessionsAllStatus : \t \(numberOfSessionsAllStatus) \n \t totalDurationCompletedTasks : \t \(totalDurationCompletedTasks) \n \t numberOfSessionsCompletedStatus : \t \(numberOfSessionsCompletedStatus) \n"
//    }
    
    var taskName : String
    private var listOfAssociatedTaskID: [String] = []
    private var totalDuration : CFTimeInterval = 0.0
    
    var totalDurationTasksAllStatus : CFTimeInterval = 0.0
    var totalDurationCompletedTasks : CFTimeInterval = 0.0
    
    private var numberOfSessionsAllStatus : Int = 0
    private var numberOfSessionsCompletedStatus : Int = 0
    
    init(taskName : String) {
        self.taskName = taskName
    }
    
    init?(firebaseDict : [String : Any?]) {
        guard let validTaskName = firebaseDict["taskName"] as? String else {return nil}
        let validListOfAssociatedTaskID = firebaseDict["listOfAssociatedTaskID"] as? [String] ?? [String]()
        guard let validTotalDurationTasksAllStatus = firebaseDict["totalDurationTasksAllStatus"] as? TimeInterval else {return nil}
        guard let validTotalDurationCompletedTasks = firebaseDict["totalDurationCompletedTasks"] as? TimeInterval else {return nil}
        guard let validNumberOfSessionsAllStatus = firebaseDict["numberOfSessionsAllStatus"] as? Int else {return nil}
        guard let validNumberOfSessionsCompletedStatus = firebaseDict["numberOfSessionsCompletedStatus"] as? Int else {return nil}
        
        taskName = validTaskName
        listOfAssociatedTaskID = validListOfAssociatedTaskID
        totalDurationTasksAllStatus = validTotalDurationTasksAllStatus
        totalDurationCompletedTasks = validTotalDurationCompletedTasks
        numberOfSessionsAllStatus = validNumberOfSessionsAllStatus
        numberOfSessionsCompletedStatus = validNumberOfSessionsCompletedStatus
    }
    
    func calcTotalDuration(completionH : @escaping (_ timeInterval : TimeInterval) -> ()) {
        print("\t\tTask Collection : Requesting for total time")
        PersistenceHandler.shared.fetchTotalTimeForTaskCollection(taskCollection: self) { (theTimeInterval) in
            print("\t\tTask Collection : Got back Response")
            completionH(theTimeInterval)
        }
    }
    
//    func getTotalDuration(completionHandler : (_ totalTime : TimeInterval) -> ()) {
//        PersistenceHandler.shared.fetchTotalTimeForTaskCollection(taskCollection: self) { (theTimeInterval) in
//            completionHandler()
//        }
//    }
    
    func numberOfSessions() -> Int {
       return listOfAssociatedTaskID.count
    }
    
    func allAssociatedTaskIDs() -> [String] {
        return listOfAssociatedTaskID
    }
    
    func addTaskID(taskID : String, task : Task) -> TaskCollection  {
        var tempColl = self
        
        // Check for Duplicates and add.
        if listOfAssociatedTaskID.contains(taskID) == false{
            tempColl.listOfAssociatedTaskID.append(taskID)
            tempColl.numberOfSessionsAllStatus += 1
            
            tempColl.totalDurationTasksAllStatus += task.timer.duration
            
            if task.taskStatus == .completed {
                tempColl.totalDurationCompletedTasks += task.timer.duration
                tempColl.numberOfSessionsCompletedStatus += 1
            }
        }
        return tempColl
    }
    
    func deletedTaskID(taskID : String) -> TaskCollection  {
        var tempColl = self
        if let itemIndex = listOfAssociatedTaskID.index(of: taskID){
            tempColl.listOfAssociatedTaskID.remove(at: itemIndex)
        }
        return tempColl
    }
    
    func fetchTaskIDAtIndex(row : Int) -> String {
        return listOfAssociatedTaskID[row]
    }
    
    var dictFormat : [String : Any?]{
        var tempDict = [String : Any?]()
        
        tempDict["taskName"] = taskName
        tempDict["listOfAssociatedTaskID"] = listOfAssociatedTaskID
        tempDict["totalDurationTasksAllStatus"] = totalDurationTasksAllStatus
        tempDict["totalDurationCompletedTasks"] = totalDurationCompletedTasks
        tempDict["numberOfSessionsAllStatus"] = numberOfSessionsAllStatus
        tempDict["numberOfSessionsCompletedStatus"] = numberOfSessionsCompletedStatus
        
        return tempDict
    }
    
}
