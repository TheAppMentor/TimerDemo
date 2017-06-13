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
    
    let lightGrayColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: 0.25)
    let darkGrayColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: 0.50)    
    
    // Fonts
    let verySmallFontSize   = UIFont(name: "HelveticaNeue-Light", size: 12.0)
    let smallFontSize       = UIFont(name: "HelveticaNeue-Light", size: 14.0)
    let regularFontSize     = UIFont(name: "HelveticaNeue-Light", size: 17.0)
    let largeFontSize       = UIFont(name: "HelveticaNeue-Light", size: 24.0)
    
    
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

