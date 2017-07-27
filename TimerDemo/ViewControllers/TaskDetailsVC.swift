//
//  TaskDetailsVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/2/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class TaskDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var currentTaskColl : TaskCollection?
    var taskList = [String:Task]()
    var taskDisplayList = [Task]()
    
    @IBOutlet weak var sessionListTableView: UITableView!
    @IBOutlet weak var taskPickerSegementControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sessionListTableView.tableFooterView = UIView()
        
        title = currentTaskColl?.taskName
        
        taskPickerSegementControl.selectedSegmentIndex = 0
        populateViewForTimePeriod(timePeriod: .today)
    }
    
//    func aggregateTaskForADay(taskArr : [Task]) -> [String : AnyObject?] {
//
//        let timeList = ["12 - 6 AM","7 AM","8 AM","9 AM","10 AM","11 AM","12 PM","1 PM","2 PM", "3PM", "4PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
//
//
//    }
//
    
    @IBAction func segmentPicked(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : populateViewForTimePeriod(timePeriod: .today)
        case 1 : populateViewForTimePeriod(timePeriod: .week)
        case 2 : populateViewForTimePeriod(timePeriod: .month)
        default: break
        }
        
    }
    
    func populateViewForTimePeriod(timePeriod : TimePeriod) {
        PersistenceHandler.shared.fetchAllTasksForTimePeriod(taskname : currentTaskColl?.taskName,timePeriod: timePeriod) { (theTaskArr) in
            // filter out only tasks matching current task coll name
            //TODO : Prashanth potential optimization here.
            
            self.taskDisplayList = []
            
            for eachTask in theTaskArr{
                if eachTask.taskName == self.currentTaskColl?.taskName{
                    self.taskDisplayList.append(eachTask)
                }
            }
            
            //Sort Task Display List :
            self.taskDisplayList.sort(by: { (task1, task2) -> Bool in
                guard let validTask1 = task1.savedDate else {return false}
                guard let validTask2 = task2.savedDate else {return false}
                return validTask1 > validTask2
            })
            
            self.sessionListTableView.reloadData()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDisplayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"taskSessionCell")
        
             let theCurrTask = taskDisplayList[indexPath.row]
        
            let taskStartDate = theCurrTask.timer.taskStartDateString
            let taskEndDate = theCurrTask.timer.taskEndDateString
        
        let taskDateStringToDisplay = (taskStartDate == taskEndDate) ? taskStartDate : "\(taskStartDate) - \(taskEndDate)"
            let taskStartTimeDisplayString = theCurrTask.timer.taskStartTimeString
            let taskEndTimeDisplayString = theCurrTask.timer.taskEndTimeString

            cell?.textLabel?.text = "\(taskDateStringToDisplay)    \(taskStartTimeDisplayString)-\(taskEndTimeDisplayString)"
            cell?.detailTextLabel?.text = theCurrTask.taskType.rawValue
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.white
        headerView.font = Utilities.shared.largeFontSize
        headerView.textAlignment = .center
        headerView.textColor = Utilities.shared.darkGrayColor
        headerView.text = "All Sessions"
        
        return headerView
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if segue.identifier == "showVizDetailsChart"{
            if let destVC = segue.destination as? VizDetailsPageVC{
                destVC.listOfVizToDisplay = [.chartToday,.chartThisWeek,.chartThisMonth]
                destVC.shouldDisplayChartTitle = false
            }
        }
    
    }
    

}
