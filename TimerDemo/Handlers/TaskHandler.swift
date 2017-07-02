//
//  TaskHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol TaskHandlerDelegate {
    func timerDidChangeValue(seconds : CFTimeInterval)
    func currentDidPause()
    func currentTaskDidResume()
    func currentTaskDidAbandon()
    func currentTaskDidComplete()
}

class TaskHandler : TaskEventHanlder {
    
    static let shared = TaskHandler()
    
    var delegate : TaskHandlerDelegate?
    
    var taskDuration : CFTimeInterval{
        switch (currentTask?.taskType)! {
        case .deepFocus :   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "taskDurationMinutes")?.currentValue as! Int))
        case .shortBreak:   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "longBreakDurationMinutes")?.currentValue as! Int))
        case .longBreak :   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "shortBreakDurationMinutes")?.currentValue as! Int))
            
            
//        case .deepFocus :   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "taskDurationMinutes")?.currentValue as! Int) * 60)
//        case .shortBreak:   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "longBreakDurationMinutes")?.currentValue as! Int) * 60)
//        case .longBreak :   return CFTimeInterval((OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Duration, prefName: "shortBreakDurationMinutes")?.currentValue as! Int) * 60)
        }
    } // 1 Minute
    
    private init() {}
    
    var currentTask : Task?
    
    func createTask(name : String, type : TaskType) {
        currentTask = nil
        
        currentTask = Task(name: name, type: type)
        currentTask?.delegate = self
        currentTask?.taskDuration = taskDuration
    }
    
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
    
    func timerDidChangeValue(seconds: CFTimeInterval){
        delegate?.timerDidChangeValue(seconds: seconds)
    }
    
    func taskDidResume() {
     delegate?.currentTaskDidResume()
    }
    
    func taskDidPause(){
        delegate?.currentDidPause()
    }
    
    func taskDidAbandon() {
        delegate?.currentTaskDidAbandon()
        archiveCurrentTask()
    }
    
    func abandonCurrentTask(){
        currentTask?.abandon()
        
    // Save the abandoned task to the task collection.
        
    }
    
    func taskDidComplete() {
        currentTask?.taskStatus = .completed
        // Add this task to the task collection.
        archiveCurrentTask()
        delegate?.currentTaskDidComplete()
    }
    
    func archiveCurrentTask() {
        //Add Current task to appropriate Task Collection.
        PersistenceHandler.shared.saveTask(task: currentTask!)
        //PersistenceHandler.shared.saveUserInfo(userInfo: UserInfo(userID: "SomeShit", isAnonymous: true, userName: "Some Fellow", displayName: "The Fellow", email: "The fellow@ gmail.com", phone: "12121212121232121"))
    }
    
}
