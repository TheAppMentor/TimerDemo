//
//  ChartDisplayVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 2/21/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

protocol ChartDataDelegate {
    func getDataModelForChart() -> TaskListingViewModel?
}

import UIKit

class ChartDisplayVC: UIViewController {
    
    var dataDelegate : ChartDataDelegate?
    
    @IBOutlet weak var vizTitleLabel: UILabel!
    @IBOutlet weak var vizChartView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        renderChart()
    }
    
    func renderChart() {
        if let chartDataModel = dataDelegate?.getDataModelForChart(){
            setupChart(chartDataModel: chartDataModel)
        }
    }
    
    func setupChart(chartDataModel : TaskListingViewModel) {
        vizChartView.subviews.forEach({$0.removeFromSuperview()})
        
        ChartHandler.shared.makeBarChart(frame: vizChartView.bounds, chartData: (dataDelegate?.getDataModelForChart()!)!, vizType: .chartToday, dataPointLimit: 3) { (theChartView, theChartTitle) in
                self.vizChartView.addSubview(theChartView)            
                theChartView.frame = self.vizChartView.bounds
                }

        
//        ChartHandler.shared.makeBarChart(frame: vizChartView.bounds, vizType: .chartToday, dataPointLimit: 3) { (theChartView, theChartTitle) in
//            self.vizTitleLabel.text = "Chart Title"
//            self.vizChartView.addSubview(theChartView)
//            theChartView.frame = self.vizChartView.bounds
//        }
    }
}
