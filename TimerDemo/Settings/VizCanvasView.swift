//
//  VizCanvasView.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/12/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

@IBDesignable


class VizCanvasView: UIView {
    
    var chartData : ChartData? = ChartDataConformer() as ChartData
    
    let axisLabelHeight : CGFloat = 20.0
    let dataLabelHeight : CGFloat = 20.0
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
//        let barContainerLayer = CALayer()
//        barContainerLayer.frame = CGRect(x: 0, y: 0, width: bounds.width/numberOfDataPoints, height: bounds.height)
//        
//        let theColumnLayer = imageForDataPoint(dataPoint: ChartDataPoint(dimension: "Mon", measure: 20))
//        
//        theColumnLayer.frame = CGRect(x: barContainerLayer.bounds.width/2 - 5.0,
//                                      y: barContainerLayer.frame.height - theColumnLayer.bounds.height - axisLabelHeight * 1.25,  // Maintian a distance of atleast quarter the label height
//                                      width: theColumnLayer.bounds.width,
//                                      height: theColumnLayer.bounds.height)
//        
//        
//        barContainerLayer.addSublayer(theColumnLayer)
//        
//        let labelFrame = CGRect(x: barContainerLayer.frame.origin.x,
//                                y: barContainerLayer.bounds.height - axisLabelHeight,
//                                width: barContainerLayer.bounds.width,
//                                height: axisLabelHeight)
//        
//        
//        barContainerLayer.addSublayer(textLayerWith(textString: "Mon", frame: labelFrame))

        
//        layer.addSublayer(barContainerLayer)
        processChartData(chartData: chartData!)
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
        setupView()
    }
    
    func setupView(){
        let bundle = Bundle.init(for: type(of: self))
        let ourNib = UINib(nibName: "VizCanvasView", bundle: bundle)
        let theView = ourNib.instantiate(withOwner: self, options: nil).first as! UIView
        theView.frame = self.bounds
        self.addSubview(theView)
    }
    
    
    
    // Chart Data Processing :
    
    func processChartData(chartData : ChartData) {
        let metaData = getMetaData(chartData: chartData)
        
        let maxColHeight = bounds.height - axisLabelHeight - dataLabelHeight
        let numberOfColumns = metaData?.numberOfDataPoints
        let eachColumnContainerWidth = bounds.width/CGFloat(numberOfColumns!)
        
        for (eachIndex,eachDataPoint) in chartData.chartDataPoints.enumerated(){
            
            let colContainerFrame = CGRect(x: CGFloat(eachIndex) * eachColumnContainerWidth, y: 0, width: eachColumnContainerWidth, height: bounds.height)
            let height = (maxColHeight/(metaData?.maxDataPoint.measure)!) * eachDataPoint.measure
            
            let eachColContainer = buildColumnContainer(dataPoint: eachDataPoint, colContainerFrame: colContainerFrame, colWidth: 10.0, colHeight: height)
            eachColContainer.backgroundColor = UIColor.yellow.cgColor
            layer.addSublayer(eachColContainer)
        }
    }
    
    
    
    func getMetaData(chartData : ChartData) -> ChartMetaData? {
        let dataPointCount  = chartData.chartDataPoints.count
        let maxDataPoint = chartData.chartDataPoints.max { (dataPoint1, dataPoint2) -> Bool in return dataPoint1.measure < dataPoint2.measure}
        let minDataPoint = chartData.chartDataPoints.min { (dataPoint1, dataPoint2) -> Bool in return dataPoint1.measure < dataPoint2.measure}
        
        return ChartMetaData(minDataPoint: minDataPoint!, maxDataPoint: maxDataPoint!, numberOfDataPoints: dataPointCount)
    }
    
    
    
    
    
    
    
    
    func buildColumnContainer(dataPoint : ChartDataPoint, colContainerFrame : CGRect, colWidth : CGFloat, colHeight : CGFloat ) -> CALayer {
        
        let columnContainerLayer = CALayer()
        //barContainerLayer.frame = CGRect(x: 0, y: 0, width: bounds.width/numberOfDataPoints, height: bounds.height)
        columnContainerLayer.frame = colContainerFrame
        
//        let theColumnLayer = imageForDataPoint(dataPoint: ChartDataPoint(dimension: dataPoint.dimension, measure: dataPoint.measure))
        let theColumnLayer = columnImageWith(size: CGSize(width: colWidth, height: colHeight))
        
        theColumnLayer.frame = CGRect(x: columnContainerLayer.bounds.width/2 - colWidth/2.0,
                                      y: columnContainerLayer.frame.height - theColumnLayer.bounds.height - axisLabelHeight * 1.25,  // Maintian a distance of atleast quarter the label height
            width: theColumnLayer.bounds.width,
            height: theColumnLayer.bounds.height)
        
        
        columnContainerLayer.addSublayer(theColumnLayer)
        
        let labelFrame = CGRect(x: columnContainerLayer.frame.origin.x,
                                y: columnContainerLayer.bounds.height - axisLabelHeight,
                                width: columnContainerLayer.bounds.width,
                                height: axisLabelHeight)
        
        
        columnContainerLayer.addSublayer(textLayerWith(textString: dataPoint.dimension, frame: labelFrame))
        
        return columnContainerLayer
    }
    
    
    
    
    func columnImageWith(size : CGSize) -> CALayer {
        
        let theColumn = CAShapeLayer()
        let thePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: 3.0).cgPath
        theColumn.path = thePath
        theColumn.fillColor = UIColor.red.cgColor
        theColumn.lineWidth = 0.0
        
        let gradient = CAGradientLayer()
        gradient.frame = frame
        
        gradient.colors = [Utilities.shared.lightGrayColor.cgColor,
                           Utilities.shared.darkGrayColor.cgColor]
        
//        gradient.colors = [Utilities.shared.lightRedColor.cgColor,
//                           Utilities.shared.darkRedColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.mask = theColumn
        
        gradient.frame = frame
        
        return gradient
    }
    
    func textLayerWith(textString : String, frame : CGRect) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = textString
        textLayer.font = Utilities.shared.verySmallFontSize
        textLayer.fontSize = 12.0
        textLayer.foregroundColor = UIColor.darkGray.cgColor
        textLayer.frame = frame
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.main.scale
        
        return textLayer
    }
    

}
