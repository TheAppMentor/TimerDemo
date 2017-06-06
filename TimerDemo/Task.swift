//
//  Task.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct Task {

    private var taskID : UUID
    private var timer : TimerBoy = TimerBoy()
    private var taskName : String
    private var taskType : TaskType
    
    var taskStatus : TaskStatus = .notStarted
    var isPerfectTask : Bool{
        return false
    }
    
    
    init(name : String, type : TaskType) {
        taskID = UUID()
        taskName = name
        taskType = type
    }
    
    
    func start() {
        
    }
    
    func pause() {
        
    }
    
    func resume() {
        
    }
    
    func abandon() {
        
    }
    
    func edit(){
        
    }
    
    func delete(){
        
    }
    
    
    // Helper method :
    
    func isTaskNameAvailable() -> Bool {
        
        return true
    }
    
}
