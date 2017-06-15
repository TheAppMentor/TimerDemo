//
//  Pause.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct Pause {
    var startTime : Date
    var endTime : Date?
    
    var duration : CFTimeInterval?{
        return endTime?.timeIntervalSince(startTime)
    }
    
    var reason : String?
}
