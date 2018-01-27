//
//  Utilities.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/7/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

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
