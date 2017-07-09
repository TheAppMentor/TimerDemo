//
//  TypeOfViz.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/9/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

enum TypeOfViz : String {
    case tableTaskList
    case chartToday
    case chartThisWeek
    case chartAlltime
    case recent
    
    var vizTitle : String{
        switch self {
        case .recent:           return "Recent Tasks"
        case .tableTaskList:    return "Recent Tasks"
        case .chartToday:       return "Today"
        case .chartThisWeek:    return "This Week"
        case .chartAlltime:     return "All Time"
        }
    }
}
