//
//  TaskListingViewModel.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 2/16/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct TaskListingObj {
    var taskName : String = ""
    var numberOfSessions : Int = 0
    var totalDurationCompletedTasks : CFTimeInterval = 0.0
    var totalDurationAllTasks : CFTimeInterval = 0.0
    var taskList : [Task] = []
}

struct TaskListingViewModel {
    
    private var taskCollection : [TaskListingObj] = []{
        didSet{
            taskCollection.sort { (obj1, obj2) -> Bool in
                obj1.numberOfSessions > obj2.numberOfSessions
            }
        }
    }
    
    var allTasksNames : [String]{
        let listOfTaskNames = taskCollection.map({return $0.taskName})
        return listOfTaskNames
    }
    
    init(taskList : [Task], taskCollectionList : [TaskCollection]) {
        
        let allTaskNames : [String] = taskList.map({return $0.taskName})
        let uniqueTaskNames = Set.init(allTaskNames)
        //let uniqueTaskNamesArr = Array.init(uniqueTaskNames)
        
        uniqueTaskNames.forEach { (eachTaskName) in
            let allTasks = taskList.filter({return $0.taskName == eachTaskName})
            let totalDurationCompletedTasks = allTasks.reduce(0, { (result, theTask) -> CFTimeInterval in
                if theTask.taskStatus == .completed{
                    return result + theTask.timer.duration
                }
                return result
            })
            
            let totalDurationAllTasks = allTasks.reduce(0, { (result, theTask) -> CFTimeInterval in
                return result + theTask.timer.duration
            })
            
            let tempTaskListingObj = TaskListingObj.init(taskName: eachTaskName, numberOfSessions: allTasks.count, totalDurationCompletedTasks: totalDurationCompletedTasks, totalDurationAllTasks: totalDurationAllTasks, taskList: taskList)
            
            self.taskCollection.append(tempTaskListingObj)
        }
    }
    
    func numberOfTasks() -> Int{
        return taskCollection.count
    }
    
    func nameTaskCollAtIndex(indexPath : IndexPath) -> String{
        return taskCollection[indexPath.row].taskName
    }
    
    func numberOfSessionsInTaskCollectionAtIndex(indexPath : IndexPath) -> Int{
        return taskCollection[indexPath.row].numberOfSessions
    }
    
    func totalDurationOfTasksInCollectionAtIndex(indexPath : IndexPath, taskStatus : TaskStatus) -> CFTimeInterval{
        switch taskStatus {
        case .completed:
            return taskCollection[indexPath.row].totalDurationCompletedTasks
        default:
            return taskCollection[indexPath.row].totalDurationAllTasks
        }
    }


}
