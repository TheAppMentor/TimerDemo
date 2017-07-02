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
        return currentTaskColl?.numberOfSessions() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "taskSessionCell")
        
        if let taskID = currentTaskColl?.fetchTaskIDAtIndex(row: indexPath.row){
            cell?.textLabel?.text = taskList[taskID]?.taskName
            cell?.detailTextLabel?.text = taskList[taskID]?.taskType.rawValue
        }
        
        return cell!
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
