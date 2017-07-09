
//
//  VizDisplayVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

enum TypeOfViz : String {
    case tableTaskList
    case chartToday
    case chartThisWeek
    case chartAlltime
    case recent
    
    var vizTitle : String{
        switch self {
        case .recent:           return "Recent Tasks"
        case .tableTaskList:    return "Recent Tasks"
        case .chartToday:       return "Today"
        case .chartThisWeek:    return "This Week"
        case .chartAlltime:     return "All Time"
        }
    }
}

class VizDisplayVC: UIViewController {
    
    var typeOfViz : TypeOfViz?
    
    @IBOutlet weak var vizTitleLabel: UILabel!
    @IBOutlet weak var vizChartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        print("Viz Display VC Awake From Nib got called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ChartHandler.shared.makeChart(frame: vizChartView.bounds, vizType: typeOfViz!, dataPointLimit: 3, completionH: { (theChartView, theChartTitle) in
            self.vizTitleLabel.text = theChartTitle
            self.vizChartView.addSubview(theChartView)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
