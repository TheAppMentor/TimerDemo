//
//  TimerBoy.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct TimerBoy {
    
    private var startTime : Date?
    private var duration : CFTimeInterval = 25.0 // Get his value from the settings Plist
    
    private var timeRemaining : CFTimeInterval? {
        if let theStartTime = startTime{
            return (duration - theStartTime.timeIntervalSinceNow)
        }
        return nil
    }
    
    var displayValue : String{
        return convertTimeIntervalToDisplayFormat()
    }

    mutating func startTimer(withDuration : CFTimeInterval = 25 * 60){
        startTime = Date()
        duration = withDuration
    }
    
    func pauseTimer() {
    }
    
    mutating func resetTimer() {
        startTime = nil
    }

}


extension TimerBoy{
    // Helper Methods
    internal func convertTimeIntervalToDisplayFormat() -> String{
        return "Timer"
    }
    
}

