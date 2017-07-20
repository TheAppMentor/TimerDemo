//
//  Utilities.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/7/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    static let shared = Utilities()
    
    // Colors
    let lightRedColor = UIColor(red: CGFloat(237.0 / 255.0), green: CGFloat(85.0 / 255.0), blue: CGFloat(101.0 / 255.0), alpha: 1.0)
    let darkRedColor = UIColor(red: CGFloat(218.0/255.0), green: CGFloat(68.0/255.0), blue: CGFloat(83.0/255.0), alpha: 1.0)
    
    let lightBlueColor = UIColor(red: CGFloat(102.0 / 255.0), green: CGFloat(136.0 / 255.0), blue: CGFloat(195.0 / 255.0), alpha: 1.0)
    let darkBlueColor = UIColor(red: CGFloat(57.0/255.0), green: CGFloat(98.0/255.0), blue: CGFloat(176.0/255.0), alpha: 1.0)
    
    let lightGreenColor = UIColor(red: CGFloat(68.0 / 255.0), green: CGFloat(160.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: 1.0)
    let darkGreenColor = UIColor(red: CGFloat(25.0/255.0), green: CGFloat(149.0/255.0), blue: CGFloat(151.0/255.0), alpha: 1.0)
    
    let lightGrayColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: 0.25)
    let darkGrayColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: 0.50)    
    
    // Fonts
    let minuteFontSize   = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
    let verySmallFontSize   = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
    let smallFontSize       = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
    let regularFontSize     = UIFont(name: "HelveticaNeue-Light", size: 17.0)!
    let largeFontSize       = UIFont(name: "HelveticaNeue-Light", size: 24.0)!
    let veryLargeFontSize   = UIFont(name: "HelveticaNeue-Light", size: 28.0)!
    
    
    // Helper Methods
    internal func convertTimeIntervalToDisplayFormat(seconds : CFTimeInterval) -> String {
        return hmsFrom(seconds: Int(seconds))
    }
    
    internal func hmsFrom(seconds: Int) -> String {
        let mins = seconds/60
        let secs = seconds % 60
        
        let minsDisplay = mins < 10 ? "0\(mins)" : "\(mins)"
        let secsDisplay  = secs < 10 ? "0\(secs)" : "\(secs)"
        
        
        return minsDisplay + ":" + secsDisplay
        //return ("Hours : \(seconds / 3600)  Minutes : \((seconds % 3600) / 60)  Seconds : \((seconds % 3600) % 60)")
    }
    
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    func getHHMMSSFrom(seconds : Int, compact : Bool = false) -> String {
        
        let hrs = seconds/(60 * 60)
        let mins = (seconds % 3600) / 60
        let secs = (seconds % 3600) % 60
        
        let hrString = compact ? "h" : "hr"
        let minString = compact ? "m" : "min"
        let sectring = compact ? "s" : "sec"
        
        let hrsDisplay = hrs == 0 ? "" : "\(hrs) \(hrString)"
        let minsDisplay = mins == 0 ? "" : "\(mins) \(minString)"
        let secsDisplay = secs == 0 ? "" : "\(secs) \(sectring)"
        
        if hrs > 0 {
            return hrsDisplay + " " + minsDisplay
        } else if mins > 0{
            return minsDisplay + " " + secsDisplay
        } else{
            return secsDisplay
        }
    }
}


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
    //           Start and End of Month Date
    // ====================================================== //
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth())!
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
    //           Start and End of Year Date
    // ====================================================== //
    
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
            let monthEndDate = monthStartDate?.endOfMonth()
            tempRetunD[eachMonth] = (monthStartDate : monthStartDate, monthEndDate : monthEndDate)
        }
        return tempRetunD
    }

}




extension UIView {
    class func fromNib<A: UIView> (nibName name: String, bundle: Bundle? = nil) -> A? {
        let bundle = bundle ?? Bundle.main
        let nibViews = bundle.loadNibNamed(name, owner: self, options: nil)
        return nibViews?.first as? A
    }
    
    class func fromNib<T: UIView>() -> T? {
        return fromNib(nibName: String(describing: T.self), bundle: nil)
    }
}

