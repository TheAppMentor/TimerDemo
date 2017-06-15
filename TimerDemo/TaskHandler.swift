//
//  TaskHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

protocol TaskHandlerDelegate {
    func timerValueChanged(seconds : CFTimeInterval)
    func currentTaskPaused()
    func currentTaskResumed()
    func currentTaskAbandoned()
    func currentTaskCompleted()
}

class TaskHandler : TaskEventHanlder {
    
    static let shared = TaskHandler()
    var delegate : TaskHandlerDelegate?
    var taskDuration : CFTimeInterval = 60 // 1 Minute
    
    private init() { 
    }
    
    var currentTask : Task?
    
    func createTask(name : String, type : TaskType) {
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
    
    func timerValueChanged(seconds: CFTimeInterval){
        delegate?.timerValueChanged(seconds: seconds)
    }
    
    func taskResumed() {
     delegate?.currentTaskResumed()
    }
    
    func taskPaused(){
        delegate?.currentTaskPaused()
    }
    
    func taskAbandoned(){
     delegate?.currentTaskAbandoned()
    }
    
    func taskCompleted() {
        currentTask?.taskStatus = .completed
        // Add this task to the task collection.
        delegate?.currentTaskCompleted()
    }
    
    
}
