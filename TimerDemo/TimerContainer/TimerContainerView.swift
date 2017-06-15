//
//  TimerContainerView.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/13/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

@IBDesignable

class TimerContainerView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
//        let thePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        let theCurvedPath = UIBezierPath()
        theCurvedPath.move(to: CGPoint(x: 0, y: bounds.height))
        theCurvedPath.addLine(to: CGPoint(x: 0, y: 0))
        theCurvedPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        theCurvedPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        theCurvedPath.addQuadCurve(to: CGPoint(x: 0, y: bounds.height), controlPoint: CGPoint(x: bounds.width/2, y: bounds.height/1.3))
        
        
        let timerContainer = CAShapeLayer()
        //timerContainer.path = thePath.cgPath
        timerContainer.path = theCurvedPath.cgPath
        timerContainer.fillColor = UIColor.lightGray.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.mask = timerContainer
        gradientLayer.colors = [Utilities.shared.lightRedColor.cgColor,Utilities.shared.darkRedColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        layer.mask = gradientLayer
        //layer.insertSublayer(gradientLayer, at: 1)
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    
    func setupView() {
        let bundle = Bundle.init(for: type(of: self))
        let ourNib = UINib(nibName: "TimerContainerView", bundle: bundle)
        let theView = ourNib.instantiate(withOwner: self, options: nil).first as! UIView
        theView.frame = self.bounds
        self.addSubview(theView)
    }
}
