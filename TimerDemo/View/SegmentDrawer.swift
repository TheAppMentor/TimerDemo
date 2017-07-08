//
//  SegmentDrawer.swift
//  DonutChartViewer
//
//  Created by Moorthy, Prashanth on 3/31/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit

// Donut Segment Class

class SegmentDrawer : UIView {
    
    var segmentInfo : DonutSegmentInfo
    
    var strokeWidth : CGFloat
    var radius : CGFloat
    
    var segmentCenter : CGPoint {
        return CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    
    private override init(frame: CGRect) {
        strokeWidth = 20.0
        segmentInfo = DonutSegmentInfo(segmentColor: UIColor.gray, segmentStartAngle: 0, segmentEndAngle: 0)
        self.radius = 70.0
        super.init(frame: frame)
    }
    
    convenience init(frame : CGRect, radius : CGFloat, strokeWidth : CGFloat, theSegmentInfo : DonutSegmentInfo){
        self.init(frame : frame)
        self.strokeWidth = strokeWidth
        segmentInfo = theSegmentInfo
        self.radius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        print("Draw Rect Got Called")
        
        let segmentPath = UIBezierPath()
        segmentPath.addArc(withCenter: segmentCenter, radius: self.radius, startAngle: segmentInfo.segmentStartAngle, endAngle: segmentInfo.segmentEndAngle, clockwise: true)
        segmentPath.lineWidth = strokeWidth
        segmentInfo.segmentColor.setStroke()
        segmentPath.stroke()
    }
}
