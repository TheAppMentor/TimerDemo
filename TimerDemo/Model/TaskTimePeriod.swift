//
//  TaskTimePeriod.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

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
            return Date().startOfToday
        case .week:
            return Date().startOfWeek
        case .month:
            return Date().startOfMonth
        case .thisYear:
            return Date().startOfCurrentYear
        case .yesterday:
            return Date().startOfYesterday
        case .lastWeek:
            return Date().startOfLastWeek
        case .lastMonth:
            return Date().startOfLastMonth
        case .allTime:
            return Date.distantPast
        }
    }
    
    var endDate : Date{
        switch self {
        case .today:
            return Date().endOfToday
        case .week:
            return Date().endOfWeek
        case .month:
            return Date().endOfMonth
        case .thisYear:
            return Date().endOfCurrentYear
        case .allTime:
            return Date().endOfToday
        case .yesterday:
            return Date().endOfYesterday
        case .lastWeek:
            return Date().endOfLastWeek
        case .lastMonth:
            return Date().endOfLastMonth
        }
    }    
}
