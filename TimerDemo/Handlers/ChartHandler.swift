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

class ChartHandler: NSObject {
    
    let log = Logger(logLevels: LogLevel.all, writers: [ConsoleWriter()])
    
    static let shared: ChartHandler = ChartHandler()
    
    private override init() {
    }
    
    func makeChart(frame: CGRect, vizType: TypeOfViz, taskName: String? = nil, dataPointLimit: Int, completionH : @escaping (_ theChartView: UIView, _ chartTitle: String)->Void) {
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
    
    private func makeChartForRecent(frame: CGRect, chartTitle: String, dataPointLimit: Int, completionH : @escaping (_ chartView: UIView, _ chartTitle: String)->Void) {
        var tempChartData = ChartDataConformer(chartTitle: chartTitle, chartDataPoints: [])
        
        let taskCollList = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: dataPointLimit)
        
        var tempChartDPArr = [ChartDataPoint]()
        
        PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: taskCollList) { (fetchedTaskCollArr) in
            for eachTaskColl in fetchedTaskCollArr {
                let tempChartDataPt = ChartDataPoint(dimension: eachTaskColl.taskName, measure: eachTaskColl.totalDurationCompletedTasks, measureDisplayValue: nil)
                tempChartDPArr.append(tempChartDataPt)
            }
            
            tempChartData.chartDataPoints = tempChartDPArr
            
            if let chartView = self.makeChartWithData(chartData: tempChartData, frame: frame) {
                completionH(chartView, chartTitle)
            }
        }
    }
    
    private func makeChartForToday(frame: CGRect, chartTitle: String, taskName: String? = nil, dataPointLimit: Int, completionH : @escaping (_ chartView: UIView, _ chartTitle: String)->Void) {
        var tempChartData = ChartDataConformer(chartTitle: chartTitle, chartDataPoints: [])
        
        let timeList = ["12 - 6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3PM", "4PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
        
        var tempChartDPArr = [ChartDataPoint]()
        
        for eachTimePeriod in timeList {
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
        
        if let chartView = self.makeChartWithData(chartData: tempChartData, frame: frame) {
            completionH(chartView, chartTitle)
        }
    }
    
    private func makeChartForThisWeek(frame: CGRect, chartTitle: String, taskName: String? = nil, dataPointLimit: Int, completionH : @escaping (_ chartView: UIView, _ chartTitle: String)->Void) {
        var tempChartData = ChartDataConformer(chartTitle: chartTitle, chartDataPoints: [])
        
        let taskCollList = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: dataPointLimit)
        
        var tempChartDPArr = [ChartDataPoint]()
        
        PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: taskCollList) { (fetchedTaskCollArr) in
            for eachTaskColl in fetchedTaskCollArr {
                let tempChartDataPt = ChartDataPoint(dimension: eachTaskColl.taskName, measure: eachTaskColl.totalDurationCompletedTasks, measureDisplayValue: nil)
                tempChartDPArr.append(tempChartDataPt)
            }
            
            tempChartData.chartDataPoints = tempChartDPArr
            
            if let chartView = self.makeChartWithData(chartData: tempChartData, frame: frame) {
                completionH(chartView, chartTitle)
            }
        }
    }
    
    private func makeChartWithData(chartData: ChartData, frame: CGRect) -> UIView? {
        if let processedChartData = processChartData(chartData: chartData) {
            let theVizChartView =  VizChartView(frame: frame, data: processedChartData)
            theVizChartView.chartData = processedChartData
            return theVizChartView
        }
        return nil
    }
    
    private func processChartData(chartData: ChartData) -> ChartData? {
        
        var tempChartData = ChartDataConformer(chartTitle: "Test Title", chartDataPoints: [])
        
        for eachDataPoint in chartData.chartDataPoints {
            var dataPoint = eachDataPoint
            dataPoint.measureDisplayValue = Utilities.shared.getHHMMSSFrom(seconds: Int(eachDataPoint.measure), compact: true)
            tempChartData.chartDataPoints.append(dataPoint)
        }
        return tempChartData
    }
    
    var allTaskNames : [String] = []
    
}

extension ChartHandler: IAxisValueFormatter {
    
    func makeBarChartForToday(frame: CGRect, chartTitle: String, taskName: String? = nil, dataPointLimit: Int, completionH : @escaping (_ chartView: UIView, _ chartTitle: String)->Void) {
        
        if let taskName = taskName {
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

    func makeChartDataSet(taskListModel : TaskListingViewModel) -> IChartDataSet{
        
        let theDimNamesMapping = taskListModel.allTasksNames
        allTaskNames = theDimNamesMapping
        
        var barChartDataEntires = [BarChartDataEntry]()

        for i in 0..<taskListModel.numberOfTasks(){
            let taskDuration = taskListModel.totalDurationOfTasksInCollectionAtIndex(indexPath: IndexPath.init(row: i, section: 0), taskStatus: .completed)
        
            let tempEntry = BarChartDataEntry.init(x: Double(i), y: taskDuration, data: nil)
            barChartDataEntires.append(tempEntry)
        }
        
        let chartDataSet = BarChartDataSet.init(values: barChartDataEntires, label: "Simple Chart")
        chartDataSet.colors = ChartColorTemplates.colorful()
        return chartDataSet
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis is YAxis{
            let theValue = Utilities.shared.getHHMMSSFrom(seconds: Int(value), compact: true)
            return theValue
        }
        
        if axis is XAxis{
            return allTaskNames[Int(value)]
        }
        return "Error"
    }
    
    func makeBarChart(frame: CGRect, chartData: TaskListingViewModel, vizType: TypeOfViz, taskName: String? = nil, dataPointLimit: Int, completionH : @escaping (_ theChartView: UIView, _ chartTitle: String)->Void) {

        let chartView = BarChartView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        let dataSet = makeChartDataSet(taskListModel: chartData)
        
        let data = BarChartData(dataSet: dataSet)
        data.setDrawValues(true)    // draws value on top of each bar
        data.setValueFormatter(self as IValueFormatter)
        chartView.data = data
        chartView.setVisibleXRangeMaximum(5.0)
        
        //By default barWidth ration is 0.85 so based on this it will cover 85% area of chart if you have only 1 Bar on chart and if        you have 2 it will calculate ration based on Bar count so you can set approx bar width with this property.
    
        data.barWidth = Double(0.5)
        
        customizeChartView(chartView: chartView)
        
        chartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutCubic)
        
        customizeXAxis(chartView: chartView)
        customizeLeftAxis(chartView: chartView)
        customizeRightAxis(chartView: chartView)
        
        chartView.notifyDataSetChanged()
        
        print("ChartView's Frame is : \(chartView.frame)")
        completionH(chartView, " ")
    }
    
    fileprivate func customizeLegend(_ chartView: BarChartView) {
        //chartView.fitBars = true
        // This is a hack. Only if we show the legend, I am able to show multiline axis lables.
        chartView.legend.enabled = true
        chartView.legend.verticalAlignment = .bottom
        chartView.legend.textColor = UIColor.clear
        chartView.legend.form = .none
    }
    
    fileprivate func customizeChartView(chartView : BarChartView){
        
        customizeLegend(chartView)
        
        chartView.chartDescription = nil
        chartView.setScaleEnabled(false)

        // Set Zooming properties
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false

        // Set Dragging properties
//        chartView.dragYEnabled = false
//        chartView.dragXEnabled = true

        chartView.drawValueAboveBarEnabled = true
    }
    
    fileprivate func customizeRightAxis(chartView : BarChartView){
        let rightAxis = chartView.getAxis(.right)
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
    }

    fileprivate func customizeLeftAxis(chartView : BarChartView){
        let leftAxis = chartView.getAxis(.left)
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false  // Temporarily disabling left asix vlaues
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawZeroLineEnabled = false
        leftAxis.valueFormatter = self
        leftAxis.axisMinimum = 0.0
    }

    fileprivate func customizeXAxis(chartView: BarChartView) {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.wordWrapEnabled = true
        
        xAxis.drawLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.gridLineWidth = 0.5
        xAxis.gridColor = Utilities.shared.lightGrayColor
        xAxis.drawAxisLineEnabled = false
        xAxis.valueFormatter = self as IAxisValueFormatter
        xAxis.granularity = 1.0
    }
}

extension ChartHandler: IValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String{
        let formattedValue = Utilities.shared.getHHMMSSFrom(seconds: Int(value), compact: true)
        return formattedValue
    }
}

