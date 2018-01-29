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
    func taskDidFreeze()
    func taskDidUnFreeze(timeRemaining: TimeInterval)
    func taskDidResume()
    func taskDidAbandon()
    func taskDidComplete()
}

class Task: TimerEventHandler, CustomStringConvertible {

    var logr : LoggingHandler {
        return LoggingHandler.shared
    }
    
    var description: String {
        return "\n ---------------------------------------- \n Task Description : \n  \t name : \t\t \(taskName) \n \t savedDate : \t \(String(describing: savedDate)) \n"
    }

    var delegate: TaskEventHanlder?

    //var taskID: String
    internal var timer: TimerBoy! = TimerBoy()
    internal var taskName: String                // We this value both in the task and in the Task colleciont, to help fire base keep a two way reference.
    var taskType: TaskType
    internal var taskTags: [String]?             // Here we can associate hash Tags with tasks to group and categorize them.
    internal var savedDate: TimeInterval?
    var taskStatus: TaskStatus = .notStarted

    var taskDuration: CFTimeInterval = 60 {
        didSet {
            timer.duration = taskDuration
        }

    }  // Make it 25 * 60 later

    var timeRemaining: CFTimeInterval {

        set {
            timer.currentTimerValue = newValue
        }

        get {
            return timer.timeRemaining!
        }
    }

    var isPerfectTask: Bool {
        return pauseList.isEmpty
    }

    var pauseList = [Pause]()

    var pauseListDictFormat: [[String: Any?]] {
        var tempPauseArr = [[String: Any?]]()
        pauseList.forEach({tempPauseArr.append($0.dictFormat)})
        return tempPauseArr
    }

    private var currentPause: Pause?

    init(name: String, type: TaskType) {
        taskName = name
        taskType = type

        timer.duration = taskDuration
        timer.delegate = self
    }

    init?(firebaseDict: [String: Any?]) {
        guard let validTaskName = firebaseDict["taskName"] as? String else {assertionFailure("\(#function) -> Invalid taskName"); return nil}
        guard let validTaskType = firebaseDict["taskType"] as? String else {assertionFailure("\(#function) -> Invalid taskType"); return nil}
        guard let validSavedDate = firebaseDict["savedDate"] as? TimeInterval else {assertionFailure("\(#function) -> Invalid Saved Date"); return nil}
//        guard let validPerfectTask = firebaseDict["isPerfectTask"] as? Bool else {return nil}
        guard let validTimer = firebaseDict["timer"] as? [String: Any?] else {assertionFailure("\(#function) -> Invalid timer"); return nil}
        guard let tempTaskStatus = firebaseDict["taskStatus"] as? String else {assertionFailure("\(#function) -> Invalid taskStatus"); return nil}
        guard let validTaskStatus = TaskStatus(rawValue: tempTaskStatus) else {assertionFailure("\(#function) -> Invalid taskStatus"); return nil}

        var validPauseList = [["":""]]
        //guard let validPauseList = firebaseDict["pauseList"] as? [[String:Any?]] else {assertionFailure("\(#function) -> Invalid Pause list"); return nil}

        //taskID = UUID(uuidString: validTaskID)!
        taskName = validTaskName
        taskType = TaskType(rawValue: validTaskType)!
        //isPerfectTask = validPerfectTask
        timer = TimerBoy(firebaseDict: validTimer)!
        taskStatus = validTaskStatus
        savedDate = validSavedDate

        for eachPauseDict in validPauseList {
            if let aPause = Pause(firebaseDict: eachPauseDict) {
                pauseList.append(aPause)
            }
        }
    }

     func start() {
        timer.startTimer()
        logr.logAnalyticsEvent(analyticsEvent: .task_Started(taskName: taskName))
    }

     func pause() {
        taskStatus = .paused
        timer.pauseTimer()
        currentPause = Pause(startTime: Date(), endTime: nil, reason: "Pause Reason ....")
    }

    func freeze() {
        taskStatus = .pausedBecauseAppResignedActive
        timer.freezeTimer()
        currentPause = Pause(startTime: Date(), endTime: nil, reason: "Task Went to Background ....")
    }

    func Unfreeze(estimatedEndTime: Date) {
        taskStatus = .running
        timer.UnfreezeTimer(estimatedEndTime: estimatedEndTime)
    }

     func resume() {
        currentPause?.endTime = Date()
        if let currentPause = currentPause {
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

    func timerDIdPause() {
        delegate?.taskDidPause()
    }

    func timerDidFreeze() {
        delegate?.taskDidFreeze()
    }

    func timerDidUnfreeze(timeRemaining: CFTimeInterval) {
        delegate?.taskDidUnFreeze(timeRemaining: timeRemaining)
    }

    func timerDidResume() {
        delegate?.taskDidResume()
    }

    func timerDidAbandon() {
        taskStatus = .abandoned
        delegate?.taskDidAbandon()
    }

    func timerDidComplete() {
        delegate?.taskDidComplete()
        logr.logAnalyticsEvent(analyticsEvent: .task_Ended(taskName: taskName))
    }

}

extension Task {

    var dictFormat: [String: Any] {
        var tempDict = [String: Any]()
        tempDict["taskName"] = taskName
        tempDict["timer"] = timer.dictFormat
        tempDict["taskType"] = taskType.rawValue
        tempDict["taskStatus"] = taskStatus.rawValue
        tempDict["isPerfectTask"] = isPerfectTask
        tempDict["pauseList"] = pauseListDictFormat

        return tempDict
    }

    var jsonFormat: String {
        let tempDict = dictFormat
        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)

        return stringVal!
    }
}
