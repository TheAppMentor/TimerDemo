//
//  PauseCollection.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/20/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct PauseCollection {
    
    var pauses = [Pause]()
    
    mutating func addPause(pause : Pause) -> PauseCollection {
        var tempPauseList = self
        tempPauseList.pauses.append(pause)
        return tempPauseList
    }
    
}
