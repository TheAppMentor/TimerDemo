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

    @IBOutlet weak var sessionListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "taskSessionCell")
        
        if let taskID = currentTaskColl?.fetchTaskIDAtIndex(row: indexPath.row){
            let taskStartDate = taskList[taskID]?.timer.taskStartDateString ?? " "
            let taskEndDate = taskList[taskID]?.timer.taskEndDateString ?? " "
            let taskDateStringToDisplay = (taskStartDate == taskEndDate) ? taskStartDate : "\(taskStartDate) - \(taskEndDate)"
            let taskStartTimeDisplayString = taskList[taskID]?.timer.taskStartTimeString ?? " "
            let taskEndTimeDisplayString = taskList[taskID]?.timer.taskEndTimeString ?? " "

            cell?.textLabel?.text = "\(taskDateStringToDisplay)    \(taskStartTimeDisplayString)-\(taskEndTimeDisplayString)"
            cell?.detailTextLabel?.text = taskList[taskID]?.taskType.rawValue
        }
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
