//
//  ChartHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/8/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Willow

class ChartHandler : NSObject {
    
    let log = Logger(logLevels: LogLevel.all, writers: [ConsoleWriter()])
    
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
//            makeChartForToday(frame : frame, chartTitle: vizType.vizTitle, dataPointLimit: dataPointLimit, completionH: { (theChartView, theChartTitle) in
//                completionH(theChartView, theChartTitle)
//            })
            makeBarChartForToday(frame: frame, chartTitle: vizType.vizTitle, dataPointLimit: dataPointLimit, completionH: { (theChartView, theChartTitle) in
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




extension ChartHandler : IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let values = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        return values[Int(value)]
    }
        
    func makeBarChartForToday(frame : CGRect, chartTitle : String, taskName : String? = nil, dataPointLimit : Int, completionH : @escaping (_ chartView : UIView, _ chartTitle : String)->()){
        
        if let taskName = taskName{
            PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname: nil, timePeriod: .today, completionHanlder: { (allTasks) in
                print("Fetched the Following tasks... ")
                var totalTimePerTask = [String : Double]()
                allTasks.forEach({print($0)})
                
                let uniqueTaskKeys = Set(allTasks.map({$0.taskName}))
                
                uniqueTaskKeys.forEach({ (eachTaskName) in
                        let totalTime = allTasks
                            .filter({$0.taskName == eachTaskName})
                            .reduce(0, {$1.timer.duration + $0})
                    
                    totalTimePerTask[eachTaskName] = totalTime
                    })
                
                self.log.debugMessage("Total time Spent by task : \(totalTimePerTask)")
                //.print("Total time Spent by task : \(totalTimePerTask)")
                //let totalDuration = allTasks.reduce(0, {$1.timer.duration + $0})
                
            })
        }
    }

    
    
//    func makeBarChart(frame : CGRect, vizType : TypeOfViz, taskName : String? = nil, dataPointLimit : Int, completionH : @escaping (_ theChartView : UIView, _ chartTitle : String)->()){
//        let barView = BARView.init(frame: frame)
//        barView.dataSource = self
//        completionH(barView, "BAR CHART MAN")
//    }
    
    // [Monday  : [[TaskA : 300], [TaskB : 400], [TaskC : 100]],
    //  Tuesday : [[TaskA : 300], [TaskB : 400], [TaskC : 100]]]
    
    
    func makeBarChartDataSet(theDimNamesMapping : [String], chartData : [[String:Double]]) -> [IChartDataSet]{
        
        
        let theDimNamesMapping = ["TaskA","TaskB","TaskC","TaskD","TaskE"]
        let theColorsArr : [NSUIColor] = [UIColor.init(hexString: "#334D5C"),UIColor.init(hexString: "#45B29D"),UIColor.init(hexString: "#EFC94C"),UIColor.init(hexString: "#E27A3F"),UIColor.init(hexString: "#DF5A49")]
        
        
        
        
        
        
        let theTimeDurationGroupMapping = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let theData = [[100,440,300,400,500,600,700],
                       [300,200,300,400,500,600,700],
                       [700,200,100,100,200,300,450],
                       [400,500,560,789,50,220,560],
                       [500,90,300,400,500,600,700]]
        
        //        let theData =  [[["Sun" : 300],["Mon" : 300],["Tue" : 400],["Wed" : 100],["Thu" : 300], ["Fri" : 400], ["Sat" : 100]],
        //                        [["Sun" : 300],["Mon" : 300],["Tue" : 400],["Wed" : 100],["Thu" : 300], ["Fri" : 400], ["Sat" : 100]]]
        
        var allDataSets = [IChartDataSet]()
        
        for (dataSetIdx,eachDataSet) in theData.enumerated(){  //[100,200,300,400,500,600,700]
            var barChartDataEntires = [BarChartDataEntry]()
            for dim1ValIndex in 0..<theTimeDurationGroupMapping.count{
                let tempEntry = BarChartDataEntry.init(x: Double(dim1ValIndex), y: Double(eachDataSet[dim1ValIndex]))
                barChartDataEntires.append(tempEntry)
            }
            let theDataSet = BarChartDataSet.init(values: barChartDataEntires, label: theDimNamesMapping[dataSetIdx])
//            theDataSet.axisDependency = .right
            theDataSet.colors = [theColorsArr[dataSetIdx]]
            allDataSets.append(theDataSet)
        }
        return allDataSets
    }
    
    func makeBarChart(frame : CGRect, chartData : [String:Double]? = nil, vizType : TypeOfViz, taskName : String? = nil, dataPointLimit : Int, completionH : @escaping (_ theChartView : UIView, _ chartTitle : String)->()){
        
        
        let chartView = BarChartView.init(frame: frame)
        
        let dataSet = makeBarChartDataSet(theDimNamesMapping: [], chartData: [])
        
        //dataSet.setColors(colorsArray, alpha: 1.0)
        let data = BarChartData(dataSets: dataSet)
        data.setDrawValues(false)
        chartView.data = data
        chartView.fitBars = true
        chartView.legend.enabled = true
        chartView.chartDescription = nil
        chartView.doubleTapToZoomEnabled = true
        
        //Customize the Chart View.
        chartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutCubic)
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.gridLineWidth = 0.5
        chartView.xAxis.gridColor = Utilities.shared.lightGrayColor
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.valueFormatter = self as IAxisValueFormatter
        
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
        
        let groupSpace = 0.3
        let barSpace = 0.025
        let barWidth = 0.3
        
        data.barWidth = barWidth
        
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        chartView.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        chartView.invalidateIntrinsicContentSize()
        
        
        completionH(chartView, "BAR CHART MAN")

    }
    
}







