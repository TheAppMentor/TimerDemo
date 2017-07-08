//
//  Task.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

protocol TaskEventHanlder {
    func timerDidChangeValue(seconds: CFTimeInterval)
    func taskDidPause()
    func taskDidResume()
    func taskDidAbandon()
    func taskDidComplete()
}

class Task : TimerEventHandler {
    
    var delegate : TaskEventHanlder?
    
    var taskID: UUID
    internal var timer: TimerBoy! = TimerBoy()
    internal var taskName: String                // We this value both in the task and in the Task colleciont, to help fire base keep a tow way reference.
    var taskType: TaskType
    internal var taskTags: [String]?             // Here we can associate hash Tags with tasks to group and categorize them.
    
    var taskStatus: TaskStatus = .notStarted
    
//    var taskDuration : CFTimeInterval = SettingsHandler.shared.taskDurationMinutes.currentValue
    var taskDuration : CFTimeInterval = 60 {
        didSet{
            timer.duration = taskDuration
        }
        
    }  // Make it 25 * 60 later
    
    var timeRemaining : CFTimeInterval{
        
        set{
            timer.currentTimerValue = newValue
        }
        
        get{
            return timer.timeRemaining!
        }
    }
    
    var isPerfectTask: Bool{
        return pauseList.isEmpty
    }
    
    private var pauseList = [Pause]()
    
    var pauseListDictFormat : [[String:Any?]]{
        var tempPauseArr = [[String:Any?]]()
        pauseList.forEach({tempPauseArr.append($0.dictFormat)})
        return tempPauseArr
    }
    
    private var currentPause : Pause?
    
    init(name: String, type: TaskType) {
        taskID = UUID()
        taskName = name
        taskType = type
        
        timer.duration = taskDuration
        timer.delegate = self
    }
    
    init?(firebaseDict : [String:Any?]) {
        guard let validTaskID = firebaseDict["taskID"] as? String else {return nil}
        guard let validTaskName = firebaseDict["taskName"] as? String else {return nil}
        guard let validTaskType = firebaseDict["taskType"] as? String else {return nil}
        guard let validPerfectTask = firebaseDict["isPerfectTask"] as? Bool else {return nil}
//        guard let validTimer = firebaseDict["timer"] as? String else {return nil}  //TODO: Prashanth need to code for the timer guy.. archive and unarchive.
        guard let validTimer = firebaseDict["timer"] as? [String : Any?] else {return nil}  //TODO: Prashanth need to code for the timer guy.. archive and unarchive.
        
        var validPauseList = [["":""]]
                
        
        
        taskID = UUID(uuidString: validTaskID)!
        taskName = validTaskName
        taskType = TaskType(rawValue: validTaskType)!
        //isPerfectTask = validPerfectTask
        timer = TimerBoy(firebaseDict: validTimer)!
        print("Timer Check : Recreated Timer : \(timer)")
        
        for eachPauseDict in validPauseList{
            if let aPause = Pause(firebaseDict: eachPauseDict){
                pauseList.append(aPause)
            }
        }
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
        timer.abandonTimer()
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
    
    func timerDidChangeValue(seconds: CFTimeInterval) {
        delegate?.timerDidChangeValue(seconds: seconds)
    }
    
    func timerDIdPause(){
        delegate?.taskDidPause()
    }
    
    func timerDidResume(){
        delegate?.taskDidResume()
    }
    
    
    func timerDidAbandon(){
        taskStatus = .abandoned
        delegate?.taskDidAbandon()
    }
    
    func timerDidComplete() {
        delegate?.taskDidComplete()
        print("Delegate : Task : Timer Ended... ")
    }
    
    
}


extension Task{
    
    var dictFormat : [String : Any]{
        var tempDict = [String : Any]()
        tempDict["taskID"] = taskID.uuidString
        tempDict["taskName"] = taskName
//        tempDict["timer"] = "ERROR >>> WE NEED TO SAVE THE TIMER HERE"
        tempDict["timer"] = timer.dictFormat
        print("Timer Check : Recreated Timer : \(tempDict["timer"])")
        tempDict["taskType"] = taskType.rawValue
        tempDict["taskStatus"] = taskStatus.rawValue
        tempDict["isPerfectTask"] = isPerfectTask
        tempDict["pauseList"] = pauseListDictFormat
        
        return tempDict
    }
    
    var jsonFormat : String {
        let tempDict = dictFormat
        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal!
    }
}
