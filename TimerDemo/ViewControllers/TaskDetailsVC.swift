//
//  TaskDetailsVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/2/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class TaskDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartDataDelegate {

    var logr : LoggingHandler{
        return LoggingHandler.shared
    }
    
    private var taskListViewModel : TaskListingViewModel?
    private var chartDisplayVC : ChartDisplayVC?
    
    @IBOutlet weak var sessionListTableView: UITableView!
    @IBOutlet weak var taskPickerSegementControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sessionListTableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : Utilities.shared.fontWithRegularSize, NSAttributedStringKey.foregroundColor : UIColor.white]

        taskPickerSegementControl.selectedSegmentIndex = 0
        populateViewForTimePeriod(timePeriod: .today)
    }
    
    @IBAction func doneButtonPressed(_ sender : UIButton){
        self.navigationController?.dismiss(animated: true, completion: {
            self.logr.logAnalyticsEvent(analyticsEvent: .navigatedOutAnalyzeScreen)
        })
    }

    @IBAction func segmentPicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : populateViewForTimePeriod(timePeriod: .today)
        case 1 : populateViewForTimePeriod(timePeriod: .yesterday)
        case 2 : populateViewForTimePeriod(timePeriod: .week)
        case 3 : populateViewForTimePeriod(timePeriod: .month)
        default: break
        }
    }
    
    
    func populateViewForTimePeriod(timePeriod: TimePeriod) {
        
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname : nil, timePeriod: timePeriod) { (theTaskArr) in

            let allTaskNames : [String] = theTaskArr.map({return $0.taskName})
            let uniqueTaskNames = Set.init(allTaskNames)
            let uniqueTaskNamesArr = Array.init(uniqueTaskNames)
            
            PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: uniqueTaskNamesArr, completionHandler: { (theTaskCollection) in
                self.taskListViewModel = TaskListingViewModel(taskList: theTaskArr, taskCollectionList: theTaskCollection)
                self.sessionListTableView.reloadData()
                self.chartDisplayVC?.renderChart()
            })
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListViewModel?.numberOfTasks() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListingCell", for: indexPath)
        
        // Configure the cell...
        // tag 11 : Task name Label
        // tag 22 : Number of sessions label
        // tag 33 : Total time heading
        // tag 44 : Total Time Value
        
        if let taskNameLabel = cell.viewWithTag(11) as? UILabel {
            taskNameLabel.text = taskListViewModel?.nameTaskCollAtIndex(indexPath: indexPath)
        }
        
        if let numSessionsLabel = cell.viewWithTag(22) as? UILabel {
            if let sessionCount = taskListViewModel?.numberOfSessionsInTaskCollectionAtIndex(indexPath: indexPath){
                let sessionCountText = "\(sessionCount)"
                numSessionsLabel.text = sessionCountText + (sessionCountText == "1" ? " Session" :  " Sessions")
            }
        }
        
        if let totalTimeLabel = cell.viewWithTag(44) as? UILabel {
            if let totalDuration = taskListViewModel?.totalDurationOfTasksInCollectionAtIndex(indexPath: indexPath, taskStatus: .completed){
                let totalTimeText = Utilities.shared.getHHMMSSFrom(seconds: Int(totalDuration))
                totalTimeLabel.text = totalTimeText
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.shared.tableViewCellHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.white
        headerView.font = Utilities.shared.fontWithRegularSize
        headerView.textAlignment = .center
        headerView.textColor = Utilities.shared.darkGrayColor
        headerView.text = "Task Details"

        return headerView
    }

    func getDataModelForChart() -> TaskListingViewModel? {
        return taskListViewModel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChartDisplayVC"{
            if let destVC = segue.destination as? ChartDisplayVC{
                destVC.dataDelegate = self
                self.chartDisplayVC = destVC
            }
        }
    }
    
}
