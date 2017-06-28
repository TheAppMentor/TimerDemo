//
//  TaskCollection.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct TaskCollection {
    var taskCollectionName: String = ""
    
    private var taskCollection: [Task] = []

    func totalDuration() -> CFTimeInterval {
        return 0.0
    }
    
}
