//
//  TimerBoy.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

protocol TimerEventHandler {
    func timerDidChangeValue(seconds : CFTimeInterval)
    func timerDIdPause()
    func timerDidFreeze()
    func timerDidUnfreeze(timeRemaining : TimeInterval)
    func timerDidResume()
    func timerDidAbandon()
    func timerDidComplete()
}


class TimerBoy {
    
    var delegate : TimerEventHandler?
    
    fileprivate var startTime: Date?
    fileprivate var endTime : Date?    // Notes : This need not be equal to the timer duration, it could be anytime, coz the guy can pause the task etc.
    
    var duration: TimeInterval = 25.0 // Get his value from the settings Plist
    var currentTimerValue : TimeInterval!
    
    var taskTimer: Timer?
    
    var timeRemaining: TimeInterval? {
        return currentTimerValue
    }
    
    var taskStartDateString : String{
        let dateString = startTime?.toString(dateFormat: "MMM d")
        return dateString ?? ""
    }
    
    var taskStartTimeString : String{
        let dateString = startTime?.toString(dateFormat: "h:mm a")
        return dateString ?? ""
    }


    var taskEndDateString : String{
        let dateString = endTime?.toString(dateFormat: "MMM d")
        return dateString ?? ""
    }

    var taskEndTimeString : String{
        let dateString = endTime?.toString(dateFormat: "h:mm a")
        return dateString ?? ""
    }

    var dictFormat : [String : Any]{
        var tempDict = [String : Any]()
        
        tempDict["startTime"] = startTime?.timeIntervalSince1970 ?? 0
        tempDict["endTime"] = endTime?.timeIntervalSince1970 ?? 0
        tempDict["duration"] = duration
        tempDict["currentTimerValue"] = currentTimerValue ?? 0
        
        return tempDict
    }
    
    
    var timerElapsedTime : TimeInterval?{
        //TODO: This is wrong!!! the guy could have puased the tiemr ... so you can calulate this way !
        guard startTime != nil else {return nil}
        guard endTime != nil else {return nil}
        
        print("          Timer Talking   => StartTime : \(startTime)   End Time : \(endTime)  => \(endTime!.timeIntervalSince(startTime!))")
        return endTime!.timeIntervalSince(startTime!)
    }

    func startTimer() {
        startTime = Date()
        currentTimerValue = duration + 1.0 //Hack : Beasue timer starts and fires immediately, we end one second too soon.
        createTaskTimer()
        taskTimer?.fire()
    }
    
    func pauseTimer() {
        taskTimer?.invalidate()
        //taskTimer = nil
        delegate?.timerDIdPause()
    }
    
    func freezeTimer() {
        taskTimer?.invalidate()
        delegate?.timerDidFreeze()
    }
    
    func UnfreezeTimer(estimatedEndTime : Date) {
        self.currentTimerValue = estimatedEndTime.timeIntervalSince(Date())
        createTaskTimer()
        taskTimer?.fire()
        delegate?.timerDidUnfreeze(timeRemaining: self.currentTimerValue)
    }
    
    func resumeTimer() {
        createTaskTimer()
        taskTimer?.fire()
        delegate?.timerDidResume()
    }
    
    func resetTimer() {
        startTime = nil
    }
    
    func abandonTimer() {
        endTime = Date()
        taskTimer?.invalidate()
        delegate?.timerDidAbandon()
    }
    
    
    func createTaskTimer() {
        taskTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (theTimer) in
            if self.currentTimerValue <= 0{
                self.taskTimer?.invalidate()
                self.endTime = Date()
                self.delegate?.timerDidComplete()
            }
            
            self.currentTimerValue = self.currentTimerValue - 1.0
            self.delegate?.timerDidChangeValue(seconds: self.currentTimerValue)
            //timerLabel.text = "\(currentTimerValue)"
        }
    }
}


extension TimerBoy{
    
    convenience init?(firebaseDict : [String : Any?]) {
        
        self.init()
        
        guard let validDuration = firebaseDict["duration"] as? TimeInterval else {return nil}
        guard let validCurrTimerVal = firebaseDict["currentTimerValue"] as? TimeInterval else {return nil}
        
        //TODO : This will definlti be an issue.. fix it.. nil and zeor are all not the same thing man.
        let startTimeInterval = firebaseDict["startTime"] as? Double ?? nil
        let endTimeInterval = firebaseDict["endTime"] as? Double ?? nil
        
        if startTimeInterval != nil {startTime = Date(timeIntervalSince1970: startTimeInterval!)} else {startTime = nil}
        if endTimeInterval != nil {endTime = Date(timeIntervalSince1970: endTimeInterval!)} else {endTime = nil}
        
        duration = validDuration
        currentTimerValue = validCurrTimerVal
    }
    
    
    // Helper Methods
    internal func convertTimeIntervalToDisplayFormat(seconds : CFTimeInterval) -> String {
        return hmsFrom(seconds: Int(seconds))
    }
    
    internal func hmsFrom(seconds: Int) -> String {
        return ("Hours : \(seconds / 3600)  Minutes : \((seconds % 3600) / 60)  Seconds : \((seconds % 3600) % 60)")
    }
    
    internal func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
}

