
//
//  VizDisplayVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class VizDisplayVC: UIViewController {
    
    var typeOfViz : TypeOfViz?
    var shouldDisplayChartTitle : Bool = true

    @IBOutlet weak var vizTitleLabel: UILabel!
    @IBOutlet weak var vizChartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(VizDisplayVC.fetchInfoForTableAndReload), name: NSNotification.Name(rawValue: "newTaskAddedToRecentTasks"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupChart()
    }
    
    func setupChart() {
        ChartHandler.shared.makeChart(frame: vizChartView.bounds, vizType: typeOfViz!, dataPointLimit: 3, completionH: {[unowned self] (theChartView, theChartTitle) in
            self.vizTitleLabel.text = self.shouldDisplayChartTitle ? theChartTitle : ""
            self.vizChartView.addSubview(theChartView)
            theChartView.frame = self.view.bounds
        })
    }
    
    func fetchInfoForTableAndReload() {
        setupChart()
    }
}
