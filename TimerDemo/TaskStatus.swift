//
//  TaskStatus.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

enum TaskStatus {
    case notStarted
    case running
    case paused
    case pausedBecauseAppResignedActive
    case completed
    case abandoned
}
