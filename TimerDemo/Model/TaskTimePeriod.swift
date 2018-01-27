//
//  TaskTimePeriod.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import SwiftDate

enum TimePeriod: String {
    case today
    case week
    case month
    case thisYear

    case yesterday
    case lastWeek
    case lastMonth

    case allTime
}
extension TimePeriod {

    var groupingDimValues: [String] {
        switch self {
        case .today :
            return ["Today"]
        case .yesterday :
            return ["Yesterday"]
        case .week, .lastWeek :
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        case .month, .lastMonth :
            return ["Week 1", "Week2", "Week 3", "Week 4"]
        case .thisYear :
            return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        default :
            return [""]
        }
    }

}
extension TimePeriod {

    var startDate: Date {

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

    var endDate: Date {
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
