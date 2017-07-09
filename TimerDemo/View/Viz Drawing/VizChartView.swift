//
//  VizChartView.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/12/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit

func ==(lhs : ChartDataPoint, rhs : ChartDataPoint) -> Bool {
    return (lhs.dimension == rhs.dimension && lhs.measure == rhs.measure)
}

struct ChartDataPoint : Equatable {
    var dimension : String
    var measure : TimeInterval
    var measureDisplayValue : String?
}

protocol ChartData {
    var chartTitle : String {get set}
    var chartDataPoints : [ChartDataPoint] {get set}
}

struct ChartDataConformer : ChartData {
    
    var chartTitle : String
    var chartDataPoints : [ChartDataPoint]
    
    //var chartTitle : String = "Title Boy"
//    var chartDataPoints = [
//        ChartDataPoint(dimension: "Programming", measure: 40.0, measureDisplayValue: "Hi"),
//        ChartDataPoint(dimension: "Default", measure: 65.0, measureDisplayValue: "Hi"),
//        ChartDataPoint(dimension: "Read Fiction", measure: 20.0, measureDisplayValue: "Hi")]
}

struct ChartMetaData {
    let minDataPoint : ChartDataPoint
    let maxDataPoint : ChartDataPoint
    let numberOfDataPoints : Int
}

@IBDesignable

class VizChartView : UIView,ChartDataProvider  {    
    // Layer/Drawing based chart
    
    @IBInspectable var isCornerRounded : Bool = true
    @IBInspectable var theCornerRadius : CGFloat = 5.0
    
    @IBOutlet weak var vizCanvasView: VizCanvasView!{
        didSet{
            print("VizChart View Got SET !!!!!!!!!!!!!!!")
            vizCanvasView.chartDataProvider = self
        }
    }
    var chartData : ChartData?
    
    override func draw(_ rect: CGRect) {
        
    }
    
    init(frame : CGRect, data : ChartData) {
        super.init(frame: frame)
        chartData = data
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView(withData : ChartData? = nil){
        let bundle = Bundle.init(for: type(of: self))
        let ourNib = UINib(nibName: "VizChartView", bundle: bundle)
        let theView = ourNib.instantiate(withOwner: self, options: nil).first as! UIView
        theView.frame = self.bounds
        self.addSubview(theView)
        
        if isCornerRounded == true {
            layer.cornerRadius = theCornerRadius
            layer.masksToBounds = false
        }
        setNeedsDisplay()
    }
    
    
    
    func getMetaData(chartData : ChartData) -> ChartMetaData? {
        let dataPointCount  = chartData.chartDataPoints.count
        let maxDataPoint = chartData.chartDataPoints.max { (dataPoint1, dataPoint2) -> Bool in return dataPoint1.measure > dataPoint2.measure}
        let minDataPoint = chartData.chartDataPoints.min { (dataPoint1, dataPoint2) -> Bool in return dataPoint1.measure < dataPoint2.measure}
        
        return ChartMetaData(minDataPoint: minDataPoint!, maxDataPoint: maxDataPoint!, numberOfDataPoints: dataPointCount)
    }
    
    override func didMoveToSuperview() {
        setNeedsDisplay()
    }
}
