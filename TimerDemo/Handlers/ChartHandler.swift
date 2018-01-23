//
//  ChartHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/8/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit
import Bars
import Charts

class ChartHandler : NSObject {
    static let shared : ChartHandler = ChartHandler()
    
    private override init(){
    }
    
    func makeChart(frame : CGRect, vizType : TypeOfViz, taskName : String? = nil, dataPointLimit : Int, completionH : @escaping (_ theChartView : UIView, _ chartTitle : String)->()){
        // Based on viz Type Fetch the data.
        switch vizType {
        case .recent:
            makeChartForRecent(frame : frame, chartTitle: vizType.vizTitle, dataPointLimit: dataPointLimit, completionH: { (theChartView, theChartTitle) in
                completionH(theChartView, theChartTitle)
            })
            
        case .chartToday:
            makeChartForToday(frame : frame, chartTitle: vizType.vizTitle, dataPointLimit: dataPointLimit, completionH: { (theChartView, theChartTitle) in
                completionH(theChartView, theChartTitle)
            })
            
        case .chartThisWeek:
            makeChartForThisWeek(frame : frame, chartTitle: vizType.vizTitle, dataPointLimit: dataPointLimit, completionH: { (theChartView, theChartTitle) in
                completionH(theChartView, theChartTitle)
            })
            
        case .chartAlltime:
            break
            
        default:
            break
        }
    }
    
    private func makeChartForRecent(frame : CGRect, chartTitle : String, dataPointLimit : Int, completionH : @escaping (_ chartView : UIView, _ chartTitle : String)->()){
        var tempChartData = ChartDataConformer(chartTitle: chartTitle, chartDataPoints: [])
        
        let taskCollList = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: dataPointLimit)
        
        var tempChartDPArr = [ChartDataPoint]()
        
        PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: taskCollList) { (fetchedTaskCollArr) in
            for eachTaskColl in fetchedTaskCollArr{
                let tempChartDataPt = ChartDataPoint(dimension: eachTaskColl.taskName, measure: eachTaskColl.totalDurationCompletedTasks, measureDisplayValue: nil)
                tempChartDPArr.append(tempChartDataPt)
            }
            
            tempChartData.chartDataPoints = tempChartDPArr
            
            if let chartView = self.makeChartWithData(chartData: tempChartData, frame: frame){
                completionH(chartView, chartTitle)
            }
        }
    }
    
    private func makeChartForToday(frame : CGRect, chartTitle : String, taskName : String? = nil, dataPointLimit : Int, completionH : @escaping (_ chartView : UIView, _ chartTitle : String)->()){
        var tempChartData = ChartDataConformer(chartTitle: chartTitle, chartDataPoints: [])

        let timeList = ["12 - 6 AM","7 AM","8 AM","9 AM","10 AM","11 AM","12 PM","1 PM","2 PM", "3PM", "4PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]

                var tempChartDPArr = [ChartDataPoint]()

        for eachTimePeriod in timeList{
            let tempChartDataPt = ChartDataPoint(dimension: " ", measure: 2, measureDisplayValue: nil)
            tempChartDPArr.append(tempChartDataPt)
        }
        
//        let taskCollList = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: dataPointLimit)
//
//        var tempChartDPArr = [ChartDataPoint]()
//
//        PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: taskCollList) { (fetchedTaskCollArr) in
//            for eachTaskColl in fetchedTaskCollArr{
//                let tempChartDataPt = ChartDataPoint(dimension: eachTaskColl.taskName, measure: eachTaskColl.totalDurationCompletedTasks, measureDisplayValue: nil)
//                tempChartDPArr.append(tempChartDataPt)
//            }
        
            tempChartData.chartDataPoints = tempChartDPArr
            
            if let chartView = self.makeChartWithData(chartData: tempChartData, frame: frame){
                completionH(chartView, chartTitle)
            }
        }    
    
    private func makeChartForThisWeek(frame : CGRect, chartTitle : String, taskName : String? = nil,dataPointLimit : Int, completionH : @escaping (_ chartView : UIView, _ chartTitle : String)->()){
        var tempChartData = ChartDataConformer(chartTitle: chartTitle, chartDataPoints: [])
        
        let taskCollList = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: dataPointLimit)
        
        var tempChartDPArr = [ChartDataPoint]()
        
        PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: taskCollList) { (fetchedTaskCollArr) in
            for eachTaskColl in fetchedTaskCollArr{
                let tempChartDataPt = ChartDataPoint(dimension: eachTaskColl.taskName, measure: eachTaskColl.totalDurationCompletedTasks, measureDisplayValue: nil)
                tempChartDPArr.append(tempChartDataPt)
            }
            
            tempChartData.chartDataPoints = tempChartDPArr
            
            if let chartView = self.makeChartWithData(chartData: tempChartData, frame: frame){
                completionH(chartView, chartTitle)
            }
        }
    }
    
    
    
    private func makeChartWithData(chartData : ChartData, frame : CGRect) -> UIView?{
        if let processedChartData = processChartData(chartData: chartData){
            let theVizChartView =  VizChartView(frame: frame , data: processedChartData)
            theVizChartView.chartData = processedChartData
            return theVizChartView
        }
        return nil
    }
    
    
    private func processChartData(chartData : ChartData) -> ChartData? {
        
        var tempChartData = ChartDataConformer(chartTitle: "Test Title", chartDataPoints: [])
        
        for eachDataPoint in chartData.chartDataPoints{
            var dataPoint = eachDataPoint
            dataPoint.measureDisplayValue = Utilities.shared.getHHMMSSFrom(seconds: Int(eachDataPoint.measure), compact: true)
            tempChartData.chartDataPoints.append(dataPoint)
        }
        return tempChartData
    }
}




extension ChartHandler : BARViewDataSource {
    func numberOfBars(in barView: BARView!) -> UInt {
        return 24
    }
    
    func barView(_ barView: BARView!, valueForBarAt index: UInt) -> CGFloat {
        let arr : [CGFloat] = [1.0,2.0,3.0,4.0,5.0,1.0,2.0,3.0,4.0,5.0,1.0,2.0,3.0,4.0,5.0,1.0,2.0,3.0,4.0,5.0,1.0,2.0,3.0,4.0]
        return arr[Int(index)]
    }
    
//    func makeBarChart(frame : CGRect, vizType : TypeOfViz, taskName : String? = nil, dataPointLimit : Int, completionH : @escaping (_ theChartView : UIView, _ chartTitle : String)->()){
//        let barView = BARView.init(frame: frame)
//        barView.dataSource = self
//        completionH(barView, "BAR CHART MAN")
//    }
    
    func makeBarChart(frame : CGRect, vizType : TypeOfViz, taskName : String? = nil, dataPointLimit : Int, completionH : @escaping (_ theChartView : UIView, _ chartTitle : String)->()){
        let chartView = BarChartView.init(frame: frame)
        
        
        let dp1 = BarChartDataEntry.init(x: 1.0, y: 5.0)
        let dp2 = BarChartDataEntry.init(x: 2.0, y: 8.0)
        let dp3 = BarChartDataEntry.init(x: 3.0, y: 11.0)
        let dp4 = BarChartDataEntry.init(x: 4.0, y: 35.0)
        let dp5 = BarChartDataEntry.init(x: 5.0, y: 67.0)
        let dp6 = BarChartDataEntry.init(x: 6.0, y: 89.0)
        let dp7 = BarChartDataEntry.init(x: 7.0, y: 55.0)

        let dataSet = BarChartDataSet.init(values: [dp1,dp2,dp3,dp4,dp5,dp6,dp7], label: "Bar Chart man.")
        let data = BarChartData(dataSets: [dataSet])
        chartView.data = data
        
        //Customize the Chart View.
        chartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutCubic)
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        
        // Customize right axis.
        let rightAxis = chartView.getAxis(.right)
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        
        // customize the left axis.
        let leftAxis = chartView.getAxis(.left)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawZeroLineEnabled = true


        chartView.notifyDataSetChanged()
        
        
        completionH(chartView, "BAR CHART MAN")

    }
    
}







