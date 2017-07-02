//
//  TaskCollection.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct TaskCollection {
    
    var taskName : String
    private var listOfAssociatedTaskID: [String] = []
    
    init(taskName : String) {
        self.taskName = taskName
    }
    
    init?(firebaseDict : [String : Any?]) {
        guard let validTaskName = firebaseDict["taskName"] as? String else {return nil}
        guard let validListOfAssociatedTaskID = firebaseDict["listOfAssociatedTaskID"] as? [String] else {return nil}
        
        taskName = validTaskName
        listOfAssociatedTaskID = validListOfAssociatedTaskID
    }
    
    func numberOfSessions() -> Int {
       return listOfAssociatedTaskID.count
    }
    
    func allAssociatedTaskIDs() -> [String] {
        return listOfAssociatedTaskID
    }
    
    func totalDuration() -> CFTimeInterval {
        return 0.0
    }
    
    func addTaskID(taskID : String) -> TaskCollection  {
        var tempColl = self
        tempColl.listOfAssociatedTaskID.append(taskID)
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
        
        return tempDict
    }
    
}
