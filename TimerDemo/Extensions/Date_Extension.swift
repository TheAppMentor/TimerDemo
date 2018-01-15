//
//  Date_Extension.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 1/15/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Date {
    
    // ====================================================== //
    //           Start and End of Today
    // ====================================================== //
    
    var startOfToday : Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    var endOfToday : Date{
        //For End Date
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let dateAtEnd = Calendar.current.date(byAdding: components, to: startOfToday)
        return dateAtEnd ?? Date()
    }
    
    // ====================================================== //
    //           Start and End of Yesterday
    // ====================================================== //
    
    var startOfYesterday : Date {
        let startOfYesterDay = Calendar.current.date(byAdding: .day, value: -1, to: startOfToday)!
        return startOfYesterDay
    }
    
    var endOfYesterday : Date{
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfYesterday = Calendar.current.date(byAdding: components, to: startOfYesterday)!
        return endOfYesterday
    }
    
    // ====================================================== //
    //           Start and End of Month Date
    // ====================================================== //
    
    var startOfMonth : Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth : Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, second: -1), to: startOfMonth)!
    }
    
    
    // ====================================================== //
    //           Start and End of Last Month Date
    // ====================================================== //
    
    var startOfLastMonth : Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return Calendar.current.date(byAdding: dateComponents, to: startOfMonth)!
    }
    
    var endOfLastMonth : Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        dateComponents.second = -1
        return Calendar.current.date(byAdding: dateComponents, to: startOfLastMonth)!
    }
    
    // ====================================================== //
    //           Start and End of Week Date
    // ====================================================== //
    
    var startOfWeek: Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek)!
    }
    
    // ====================================================== //
    //           Start and End of Last Week Date
    // ====================================================== //
    
    var startOfLastWeek: Date {
        
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = -1
        
        return Calendar.current.date(byAdding: dateComponents, to: startOfWeek)!
    }
    
    var endOfLastWeek: Date {
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = 1
        dateComponents.second = -1
        
        return Calendar.current.date(byAdding: dateComponents, to: startOfLastWeek)!
    }
    
    // ====================================================== //
    //           Start and End of Year Date
    // ====================================================== //
    
    var startOfCurrentYear : Date {
        let currentDay = Calendar.current.dateComponents([.day], from: startOfToday)
        
        var dateComponents = DateComponents()
        dateComponents.day = -(currentDay.day!)
        dateComponents.second = 1
        
        return Calendar.current.date(byAdding: dateComponents, to: endOfToday)!
    }
    
    var endOfCurrentYear : Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1
        return Calendar.current.date(byAdding: dateComponents, to: endOfToday)!
    }
    
    
    // ====================================================== //
    //           Start and End of Last Year Date
    // ====================================================== //
    
    var startOfLastYear : Date {
        var dateComponents = DateComponents()
        dateComponents.year = -1
        return Calendar.current.date(byAdding: dateComponents, to: startOfCurrentYear)!
    }
    
    var endOfLastYear : Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1
        dateComponents.second = -1
        return Calendar.current.date(byAdding: dateComponents, to: startOfLastYear)!
    }
    
    
    
    
    
    
    
    func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd
        
        return calendar.date(byAdding: months, to: self)
    }
    
    // Year
    var currentYear: String? {
        return getDateComponent(dateFormat: "yy")
        //return getDateComponent(dateFormat: "yyyy")
    }
    
    
    func getDateComponent(dateFormat: String) -> String? {
        let format = DateFormatter()
        format.dateFormat = dateFormat
        return format.string(from: self)
    }
    
    func getFirstDayOfCurrentYear() -> Date? {
        var dateComp = DateComponents()
        let currYear = Calendar.current.dateComponents([.year], from: Date())
        dateComp.year = currYear.year
        dateComp.day = 1
        //Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        return Calendar.current.date(from: dateComp)
    }
    
    func getDatesForStartAndEndOfEachMonth() -> [Int : (monthStartDate : Date?, monthEndDate : Date?)] {
        //let yearStartDate = getFirstDayOfCurrentYear()
        
        var tempRetunD = [Int : (monthStartDate : Date?, monthEndDate : Date?)]()
        
        for eachMonth in 0..<12{
            let monthStartDate = dateByAddingMonths(eachMonth)
            let monthEndDate = monthStartDate?.endOfMonth
            tempRetunD[eachMonth] = (monthStartDate : monthStartDate, monthEndDate : monthEndDate)
        }
        return tempRetunD
    }
}
