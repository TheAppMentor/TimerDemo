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
    
    // App Version Number.
    let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String


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
    let fontWithMinuteSize   = UIFont(name: "HelveticaNeue-Light", size: 10.0)!
    let fontWithVerySmallSize   = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
    let fontWithSmallSize       = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
    let fontWithRegularSize     = UIFont(name: "HelveticaNeue-Light", size: 17.0)!
    let fontWithLargeSize       = UIFont(name: "HelveticaNeue-Light", size: 24.0)!
    let fontWithVeryLargeSize   = UIFont(name: "HelveticaNeue-Light", size: 28.0)!

    // Helper Methods
    internal func convertTimeIntervalToDisplayFormat(seconds: CFTimeInterval) -> String {
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

    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->Void) {

        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)

    }

    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }

    func getHHMMSSFrom(seconds: Int, compact: Bool = false) -> String {

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
        } else if mins > 0 {
            return minsDisplay + " " + secsDisplay
        } else {
            return secsDisplay
        }
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
