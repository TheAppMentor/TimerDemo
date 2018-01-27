//
//  TaskListTVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/1/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

protocol TaskPickerTVCEventHandlerDelegate {
    func userPickedATaskWithName(name: String)
    func userWantsToViewMoretasks()
}

class TaskPickerTVC: UITableViewController {

    var allTaskColl: [TaskCollection] = []
    var selectedTaskCollToShowDetails: TaskCollection?
    var taskListToPass = [String : Task]()

    var eventHandlerDelegate: TaskPickerTVCEventHandlerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func reloadTableViewWithNewTasks() {
        PersistenceHandler.shared.fetchAllTaskCollections(completionHandler: { (theTaskColl) in
            self.allTaskColl = []
            self.allTaskColl = theTaskColl
            self.tableView.reloadData()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white,
             NSAttributedStringKey.font: Utilities.shared.regularFontSize]

        tableView.tableFooterView = UIView()
        reloadTableViewWithNewTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTaskColl.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListingCell", for: indexPath)

        // Configure the cell...
        // tag 11 : Task name Label
        // tag 22 : Number of sessions label
        // tag 33 : Total time heading
        // tag 44 : Total Time Value

        let fetchedTaskCollection =  allTaskColl[indexPath.row]

        if let taskNameLabel = cell.viewWithTag(11) as? UILabel {
            taskNameLabel.text = fetchedTaskCollection.taskName
        }

        if let numSessionsLabel = cell.viewWithTag(22) as? UILabel {
            let sessionCountText = String(fetchedTaskCollection.numberOfSessions())
            numSessionsLabel.text = sessionCountText + (sessionCountText == "1" ? " Session" :  " Sessions")
        }

        if let totalTimeLabel = cell.viewWithTag(44) as? UILabel {
            let totalTime = Utilities.shared.getHHMMSSFrom(seconds: Int(fetchedTaskCollection.totalDurationCompletedTasks))
            totalTimeLabel.text = totalTime
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        self.selectedTaskCollToShowDetails =  self.allTaskColl[indexPath.row]
        self.performSegue(withIdentifier: "showTaskDetails", sender: self)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandlerDelegate?.userPickedATaskWithName(name: self.allTaskColl[indexPath.row].taskName)
        dismissScreen()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier ?? "" {
        case "showTaskDetails":
            if let destVC = segue.destination as?  TaskDetailsVC {
                destVC.currentTaskColl = selectedTaskCollToShowDetails
                //destVC.taskList = taskListToPass
            }

        case "showAddTask":
            if let destVC = segue.destination as? AddTaskVC {
                if let theOtherEventHanlder = eventHandlerDelegate as? MainTimerScreenVC {
                    destVC.taskAddVCEventHandlerDelegate = theOtherEventHanlder
                }
            }

        default:
            break
        }

        if segue.identifier == "showTaskDetails"{
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var rowActionsArr : [UITableViewRowAction]? = []

       let deleteAction = UITableViewRowAction(style: .default, title: "Archive") { (theRowAction, theIndexPath) in
            print("User Opted to delete row")
            // Ask for Confirmation :
        }
        
        rowActionsArr?.append(deleteAction)

        return rowActionsArr
    }

    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAddTask", sender: self)
    }

    @IBAction func dismissScreen(_ sender: UIBarButtonItem) {
        dismissScreen()
    }

    func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }

}
