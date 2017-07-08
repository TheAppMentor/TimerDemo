//
//  DonutComposer.swift
//  DonutChartViewer
//
//  Created by Moorthy, Prashanth on 3/31/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit

struct DonutComposer {
    
    var donutFrame : CGRect
    
    func drawDonutUsingData(data : DonutData, center : CGPoint, radius : CGFloat) -> UIView{
        
        let pieAssemblyView = UIView(frame: donutFrame)
        
        for eachDonutSegInfo in getDonutMetaData(data: data){
            let theSegment = SegmentDrawer(frame: donutFrame, radius: radius, strokeWidth: 50.0, theSegmentInfo: eachDonutSegInfo)
            theSegment.backgroundColor = UIColor.clear
            pieAssemblyView.addSubview(theSegment)
        }
        
        pieAssemblyView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        pieAssemblyView.layer.shadowColor = UIColor.green.cgColor
        pieAssemblyView.layer.shadowRadius = 5
        pieAssemblyView.layer.shadowOpacity = 0.25
        pieAssemblyView.layer.masksToBounds = false

        
        return pieAssemblyView
    }
    
    func getDonutMetaData(data : DonutData) -> [DonutSegmentInfo] {
        
        var nextStartAngle = CGFloat(-M_PI_2)
        
        let sumOfDataPoints = data.dataPoints.reduce(0, +)
        var theDonutSegArray = [DonutSegmentInfo]()
        
        for (index, eachDataPoint) in data.dataPoints.enumerated(){
            
            let segmentAngle = CGFloat((eachDataPoint/sumOfDataPoints) * 2 * M_PI)
            
            let tempDonutSegInfo = DonutSegmentInfo(segmentColor: data.colorPalette[index],
                                                    segmentStartAngle: nextStartAngle,
                                                    segmentEndAngle: nextStartAngle + segmentAngle)
            
            theDonutSegArray.append(tempDonutSegInfo)
            
            nextStartAngle += segmentAngle
        }
        
        return theDonutSegArray
    }
    
}
