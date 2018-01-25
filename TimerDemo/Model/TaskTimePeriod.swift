//
//  TaskTimePeriod.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import SwiftDate


enum TimePeriod : String{
    case today
    case week
    case month
    case thisYear

    case yesterday
    case lastWeek
    case lastMonth

    case allTime
}

extension TimePeriod{
    
    var startDate : Date {
        
        switch self {
        case .today:
            return Date().startOf(component: .day)
        case .week:
            return Date().startWeek
        case .month:
            return Date().startOf(component: .month)
        case .thisYear:
            return Date().startOf(component: .year)
        case .yesterday:
            return Date().startOf(component: .day) - 1.day
        case .lastWeek:
            return Date().startWeek - 1.week
        case .lastMonth:
            return Date().startOf(component: .month) - 1.month
        case .allTime:
            return Date.distantPast
        }
    }
    
    var endDate : Date{
        switch self {
        case .today:
            return Date().endOfDay
        case .week:
            return Date().endWeek
        case .month:
            return Date().endOf(component: .month)
        case .thisYear:
            return Date().endOf(component: .year)
        case .allTime:
            return Date().endOf(component: .year)
        case .yesterday:
            return Date().endOf(component: .day) - 1.day
        case .lastWeek:
            return Date().endWeek - 1.week
        case .lastMonth:
            return Date().endOf(component: .month) - 1.month
        }
    }    
}
