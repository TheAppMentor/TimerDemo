//
//  RoundedButton.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/13/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
import RSPlayPauseButton

class RoundedButton: RSPlayPauseButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code

        layer.shadowOffset = CGSize(width: 1, height: 4)
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false

//        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
//        
////        let shadowShapeLayer = CAShapeLayer()
////        circleShape.path = circlePath.cgPath
////        circleShape.fillColor = UIColor.white.cgColor
////        circleShape.frame = bounds
//        
//        let circleShape = CAShapeLayer()
//        circleShape.path = circlePath.cgPath
//        circleShape.fillColor = UIColor.white.cgColor
//        circleShape.frame = bounds
//        circleShape.shadowOffset = CGSize(width: 1, height: 4)
//        
//        circleShape.shadowRadius = 3.0
//        circleShape.shadowColor = UIColor.lightGray.cgColor
//        circleShape.shadowOpacity = 0.5
//        circleShape.masksToBounds = false
//        
//        layer.mask = circleShape
//        //layer.masksToBounds = true
//        
//        layer.addSublayer(circleShape)
//        
//        //clipsToBounds = true

    }

}
