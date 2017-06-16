//
//  Task.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

protocol TaskEventHanlder {
    func timerValueChanged(seconds: CFTimeInterval)
    func taskPaused()
    func taskResumed()
    func taskAbandoned()
    func taskCompleted()
}

class Task : TimerEventHandler {
    
    var delegate : TaskEventHanlder?
    
    private var taskID: UUID
    private var timer: TimerBoy = TimerBoy()
    private var taskName: String                // We dont need this, this will be same as task collection name.
    private var taskType: TaskType
    private var taskTags: [String]?             // Here we can associate hash Tags with tasks to group and categorize them.
    
    var taskStatus: TaskStatus = .notStarted
    
//    var taskDuration : CFTimeInterval = SettingsHandler.shared.taskDurationMinutes.currentValue
    var taskDuration : CFTimeInterval = 60  // Make it 25 * 60 later
    
    var timeRemaining : CFTimeInterval{
        return timer.timeRemaining!
    }
    
    var isPerfectTask: Bool{
        return pauseList.isEmpty
    }
    
    var pauseList = [Pause]()
    
    private var currentPause : Pause?
    
    init(name: String, type: TaskType) {
        taskID = UUID()
        taskName = name
        taskType = type
        
        timer.duration = taskDuration
        timer.delegate = self
    }
    
     func start() {
        timer.startTimer()
    }
    
     func pause() {
        taskStatus = .paused
        timer.pauseTimer()
        currentPause = Pause(startTime: Date(), endTime: nil, reason: "Pause Reason ....")
    }
    
     func resume() {
        currentPause?.endTime = Date()
        if let currentPause = currentPause{
            pauseList.append(currentPause)
        }
        currentPause = nil
        taskStatus = .running
        timer.resumeTimer()
    }
    
     func abandon() {
        taskStatus = .abandoned
    }
    
     func edit() {
        
    }
    
     func delete() {
        taskStatus = .abandoned
    }
    
    // Helper method :
    
    func isTaskNameAvailable() -> Bool {
        return true
    }
    
    func timerValueChanged(seconds: CFTimeInterval) {
        delegate?.timerValueChanged(seconds: seconds)
    }
    
    func timerPaused(){
        delegate?.taskPaused()
    }
    
    func timerHasResumed(){
        delegate?.taskResumed()
    }
    
    
    func timerAbandoned(){
        delegate?.taskAbandoned()
    }
    
    
    func timerCompleted() {
        delegate?.taskCompleted()
        print("Delegate : Task : Timer Ended... ")
    }
    
    
}
