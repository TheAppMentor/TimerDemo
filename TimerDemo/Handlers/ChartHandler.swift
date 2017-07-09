//
//  ChartHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/8/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit

class ChartHandler {
    static let shared : ChartHandler = ChartHandler()
    
    private init(){
        
    }
    
    func makeChart(frame : CGRect, vizType : TypeOfViz, dataPointLimit : Int, completionH : @escaping (_ theChartView : UIView, _ chartTitle : String)->()){
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
    
    private func makeChartForToday(frame : CGRect, chartTitle : String, dataPointLimit : Int, completionH : @escaping (_ chartView : UIView, _ chartTitle : String)->()){
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
    
    
    private func makeChartForThisWeek(frame : CGRect, chartTitle : String, dataPointLimit : Int, completionH : @escaping (_ chartView : UIView, _ chartTitle : String)->()){
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
