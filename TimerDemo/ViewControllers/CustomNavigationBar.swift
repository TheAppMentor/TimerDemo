//
//  CustomNavigationBar.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/20/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
 
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let newSize :CGSize = CGSize(width: self.frame.size.width, height: 88)
            return newSize
        }    
}
