//
//  TaskHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

protocol TaskHandlerDelegate {
    func timerDidChangeValue(seconds : CFTimeInterval)
    func currentTaskPaused()
    func currentTaskResumed()
    func currentTaskAbandoned()
    func currentTaskCompleted()
}

class TaskHandler : TaskEventHanlder {
    
    static let shared = TaskHandler()
    
    var delegate : TaskHandlerDelegate?
    
    var taskDuration : CFTimeInterval{
        switch (currentTask?.taskType)! {
        case .deepFocus :   return 60
        case .shortBreak:   return 5
        case .longBreak :   return 5
        }
    } // 1 Minute
    
    private init() { 
    }
    
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
     delegate?.currentTaskResumed()
    }
    
    func taskDidPause(){
        delegate?.currentTaskPaused()
    }
    
    func taskDidAbandon() {
        delegate?.currentTaskAbandoned()
    }
    
    
    func abandonCurrentTask(){
        currentTask?.abandon()
        archiveCurrentTask()
        
    // Save the abandoned task to the task collection.
        
    }
    
    func taskDidComplete() {
        currentTask?.taskStatus = .completed
        // Add this task to the task collection.
        delegate?.currentTaskCompleted()
    }
    
    func archiveCurrentTask() {
        //Add Current task to appropriate Task Collection.
    }
    
}
