//
//  TaskHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

class TaskManager {
    
    static let shared = TaskManager()
    
    var delegate : TaskHandlerDelegate?
    
    var taskDuration : CFTimeInterval{
        switch (currentTask?.taskType)! {
        case .deepFocus :   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "taskDurationMinutes")?.currentValue as! Int) * 60)
        case .shortBreak:   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "shortBreakDurationMinutes")?.currentValue as! Int) * 60)
        case .longBreak :   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "longBreakDurationMinutes")?.currentValue as! Int) * 60)
        }
    }
    
    private init() {}
    
    var currentTask : Task?
    
    // =====================================
    // MARK: Create Task
    // =====================================
    
    func createTask(name : String, type : TaskType) {
        currentTask = nil
        currentTask = Task(name: name, type: type)
        currentTask?.delegate = self
        currentTask?.taskDuration = taskDuration
    }
    
    // =====================================
    // MARK: Task State Handling
    // =====================================
    
    func startCurrentTask(){
        currentTask?.start()
        currentTask?.taskStatus = .running
    }
    
    func pauseCurrentTask() {
        currentTask?.pause()
        currentTask?.taskStatus = .paused
    }
    
    func resumeCurrentTask() {
        currentTask?.resume()
        currentTask?.taskStatus = .running
    }
    
    func freezeCurrentTask() {
        currentTask?.freeze()
    }
    
    
    // =====================================
    // MARK: Task Archiving Methods
    // =====================================
    
    func archiveCurrentTask() {
        //Add Current task to appropriate Task Collection.
        PersistenceHandler.shared.saveTask(task: currentTask!)
    }
    
    
    
    // =====================================
    // MARK: Task Helper Methods
    // =====================================
    
    func checkIfTaskNameIsValid(taskName : String, compHandler : @escaping (_ taskAlreayExists : Bool)->()){
        
        PersistenceHandler.shared.fetchAllTaskCollections { (theTaskCollList) in
            
            for eachTask in theTaskCollList{
                if eachTask.taskName == taskName{
                    compHandler(true)
                    return
                }
            }
            compHandler(false)
        }
    }
}

extension TaskManager : TaskEventHanlder {
    
    // =====================================
    // MARK: Task Event Delegate Handling
    // =====================================
    
    func timerDidChangeValue(seconds: CFTimeInterval){
        delegate?.timerDidChangeValue(seconds: seconds)
    }
    
    func taskDidResume() {
        delegate?.currentTaskDidResume()
    }
    
    func taskDidPause(){
        delegate?.currentDidPause()
    }
    
    func taskDidFreeze() {
        delegate?.currentTaskDidFreeze()
    }
    
    func taskDidUnFreeze(timeRemaining : TimeInterval) {
        delegate?.currentTaskDidUnFreeze(timeRemaining : timeRemaining)
    }
    
    func taskDidAbandon() {
        delegate?.currentTaskDidAbandon()
        archiveCurrentTask()
    }
    
    func abandonCurrentTask(){
        currentTask?.abandon()
    }
    
    func taskDidComplete() {
        currentTask?.taskStatus = .completed
        // Add this task to the task collection.
        archiveCurrentTask()
        UserInfoHandler.shared.addTaskCollToRecent(taskCollName: currentTask?.taskName ?? "")
        
        delegate?.currentTaskDidComplete()
    }
    
}
