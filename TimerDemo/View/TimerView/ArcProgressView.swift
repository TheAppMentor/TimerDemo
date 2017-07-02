//
//  CircularProgressView.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/13/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

@IBDesignable

class ArcProgressView: UIView,CAAnimationDelegate {
    
    var timerDuration : CFTimeInterval = 25 * 60{
        didSet{
            timerLabel.text = Utilities.shared.convertTimeIntervalToDisplayFormat(seconds: timerDuration)
        }
    }
    var currentTimerValue : Int = 20
    
    var taskTimer: Timer!
    
    let arcViewShape = CAShapeLayer()
    
    var startAngle : CGFloat = 0.0
    var endAngle : CGFloat = 0.0
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var arcRadius : CGFloat = 110.0
    
    var arcStartAngle : CGFloat = -CGFloat.pi - CGFloat.pi/4.0
    var arcEndAngle : CGFloat = CGFloat.pi/2.0 - CGFloat.pi/4.0
    
    var arcWidth : CGFloat = 16.0
    var arcBackgroundStrokeColor = UIColor(colorLiteralRed: (155.0/255.0), green: (155.0/255.0), blue: (155.0/255.0), alpha: 0.5).cgColor
    var arcForegroundStrokeColor = UIColor(colorLiteralRed: (255.0/255.0), green: (255.0/255.0), blue: (255.0/255.0), alpha: 1.0).cgColor
    
    var arcPathEndState : UIBezierPath{
        let tempPath = UIBezierPath(arcCenter: center, radius: arcRadius, startAngle: arcStartAngle, endAngle: arcEndAngle, clockwise: true)
        
        tempPath.lineWidth = arcWidth
        tempPath.lineCapStyle = .round
        
        return tempPath
    }
    
    
    let arcProgressShape = CAShapeLayer()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawArcBackground()
        drawArcForeGround()
    }
    
    func drawArcBackground() {
        let arcBackgroundShape = CAShapeLayer()
        arcBackgroundShape.path = arcPathEndState.cgPath
        arcBackgroundShape.fillColor = UIColor.clear.cgColor
        arcBackgroundShape.strokeColor = arcBackgroundStrokeColor
        arcBackgroundShape.lineWidth = arcWidth
        arcBackgroundShape.lineCap = kCALineCapRound
        arcBackgroundShape.name = "BackGroundArc"
        
        layer.mask = arcBackgroundShape
        layer.addSublayer(arcBackgroundShape)
    }
    
    
    func drawArcForeGround() {
        //        let arcProgressShape = CAShapeLayer()
        arcProgressShape.path = arcPathEndState.cgPath
        arcProgressShape.fillColor = UIColor.clear.cgColor
        arcProgressShape.strokeColor = arcForegroundStrokeColor
        arcProgressShape.lineWidth = arcWidth
        arcProgressShape.lineCap = kCALineCapRound
        arcProgressShape.name = "ForeGroundArc"
        
        layer.mask = arcProgressShape
        layer.addSublayer(arcProgressShape)
    }
    
    
    func animateProgressBar() {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = timerDuration
        anim.fromValue = 0
        anim.toValue = 1
        anim.speed = 1.0
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        anim.isRemovedOnCompletion = true
//        anim.fillMode = kCAFillModeForwards
        anim.delegate = self
        arcProgressShape.add(anim, forKey: "arcAnimation")
    }
    
    func pauseAnimation(){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    
    func resetLayerToFullPosition() {
        layer.speed = 100.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
//        layer.sublayers?.forEach({
//            print("Found This fellow...");
//            if $0.name == "ForeGroundArc"{
//                ($0 as! CAShapeLayer).strokeEnd = 1.0
//                layer.setNeedsDisplay()
//            }
//        })
        
        
    }
    
    func resumeAnimationFromStart(){
    }
    
    
    func resetAnimation() {
        print("Prashanth : We need to figure out how to reset this animation man......")
//        animateProgressBar()
//        arcProgressShape.animationKeys()
        
        layer.sublayers?.forEach({
            if $0.name == "ForeGroundArc"{
            print("Found This fellow...");
                if let theAnimation = $0.animation(forKey: "arcAnimation"){
                    print("Found the Animation also...");
                    ($0 as! CAShapeLayer).strokeEnd = 0.0
                    //($0 as! CAShapeLayer).presentation()?
                    $0.add(theAnimation, forKey: "arcAnimation")
                    //($0 as! CAShapeLayer).strokeEnd = 0.0
                }else{
                    assertionFailure("Could not find the animation !!!")
                }
            }
        })
    }
    
    
    func animationDidStart(_ anim: CAAnimation) {
        print("ANimation Started")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation ENded \(flag)")
        layer.speed = 1.0
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
        let ourNib = UINib(nibName: "ArcProgressView", bundle: bundle)
        let theView = ourNib.instantiate(withOwner: self, options: nil).first as! UIView
        theView.frame = self.bounds
        self.addSubview(theView)
    }
}
