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
    func timerDidResume()
    func timerDidAbandon()
    func timerDidComplete()
}


class TimerBoy {
    
    var delegate : TimerEventHandler?
    
    private var startTime: Date?
    private var endTime : Date?    // Notes : This need not be equal to the timer duration, it could be anytime, coz the guy can pause the task etc.
    
    var duration: CFTimeInterval = 25.0 // Get his value from the settings Plist
    var currentTimerValue : CFTimeInterval!
    
    
    var taskTimer: Timer!
    
    var timeRemaining: CFTimeInterval? {
        return currentTimerValue
    }

    func startTimer() {
        startTime = Date()
        currentTimerValue = duration
        createTaskTimer()
        taskTimer.fire()
    }
    
    func pauseTimer() {
        taskTimer.invalidate()
        //taskTimer = nil
        delegate?.timerDIdPause()
    }
    
    func resumeTimer() {
        createTaskTimer()
        taskTimer.fire()
        delegate?.timerDidResume()
    }
    
    func resetTimer() {
        startTime = nil
    }
    
    func abandonTimer() {
        endTime = Date()
        taskTimer.invalidate()
        delegate?.timerDidAbandon()
    }
    
    
    func createTaskTimer() {
        taskTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (theTimer) in
            if self.currentTimerValue <= 0{
                self.taskTimer.invalidate()
                self.delegate?.timerDidComplete()
            }
            
            self.currentTimerValue = self.currentTimerValue - 1.0
            self.delegate?.timerDidChangeValue(seconds: self.currentTimerValue)
            //timerLabel.text = "\(currentTimerValue)"
        }
    }
    
}


extension TimerBoy{
    
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

