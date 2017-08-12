    //
//  TaskListTVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/1/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
    
    protocol TaskPickerTVCEventHandlerDelegate {
        func userPickedATaskWithName(name : String)
        func userWantsToViewMoretasks()
    }

class TaskPickerTVC: UITableViewController {
    
    //var allTasks : [TaskCollection]
    var allTasks : [String] = []
    var selectedTaskCollToShowDetails : TaskCollection?
    var taskListToPass = [String : Task]()
    
    var eventHandlerDelegate : TaskPickerTVCEventHandlerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        PersistenceHandler.shared.fetchAllTaskCollections(completionHandler: { (theTaskColl) in
            theTaskColl.forEach({self.allTasks.append($0.taskName)})
            print("Reloading the Task with : \(self.allTasks)")
            self.tableView.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white,
             NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): Utilities.shared.regularFontSize]
        
        tableView.tableFooterView = UIView()
        tableView.reloadData()   //Incase a new task is added we need to reload. //TODO: May not be a good way if there are many tasks.. need to refine this further
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListingCell", for: indexPath)
        
        //TODO: This might be slow to fetch incase of scrollign etc.. check this....
        PersistenceHandler.shared.fetchTaskCollectionWithName(taskName: allTasks[indexPath.row]) { (fetchedTaskCollection) in
            // Configure the cell...
            // tag 11 : Task name Label
            // tag 22 : Number of sessions label
            // tag 33 : Total time heading
            // tag 44 : Total Time Value
            
            if let taskNameLabel = cell.viewWithTag(11) as? UILabel{
                taskNameLabel.text = self.allTasks[indexPath.row]
            }
            
            if let numSessionsLabel = cell.viewWithTag(22) as? UILabel{
                let sessionCountText = String(describing:(fetchedTaskCollection?.numberOfSessions() ?? 0))
                numSessionsLabel.text = sessionCountText + (sessionCountText == "1" ? " Session" :  " Sessions")
            }
            
            if let totalTimeLabel = cell.viewWithTag(44) as? UILabel{
                PersistenceHandler.shared.fetchTaskCollectionWithName(taskName: self.allTasks[indexPath.row]) { (fetchedTaskCollection) in
                    
                    let totalTime = Utilities.shared.getHHMMSSFrom(seconds: Int(fetchedTaskCollection?.totalDurationCompletedTasks ?? 0))
                    totalTimeLabel.text = totalTime
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        PersistenceHandler.shared.fetchTaskCollectionWithName(taskName: allTasks[indexPath.row]) { (fetchedTaskCollection) in
            self.selectedTaskCollToShowDetails = fetchedTaskCollection

            self.performSegue(withIdentifier: "showTaskDetails", sender: self)

            
//            //Fetch all associated Tasks Also :  //TODO: THis is where we need the smart logic to fetch only those tasks that the tbleview actually needs. Dont fetch everything.
//            PersistenceHandler.shared.fetchAllTasksMatchingArray(taskIDArray: (self.selectedTaskCollToShowDetails?.allAssociatedTaskIDs())!, completionHandler: { (theTaskArr) in
//                for (eachTaskIndex,eachTask) in theTaskArr.enumerated(){
//                    if let theTaskID = self.selectedTaskCollToShowDetails?.allAssociatedTaskIDs()[eachTaskIndex]{
//                        self.taskListToPass[theTaskID] = eachTask
//                    }
//                }
//                self.performSegue(withIdentifier: "showTaskDetails", sender: self)
//            })
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandlerDelegate?.userPickedATaskWithName(name: allTasks[indexPath.row])
        dismissScreen()
    }

    
    
    
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier ?? "" {
        case "showTaskDetails":
            if let destVC = segue.destination as?  TaskDetailsVC{
                destVC.currentTaskColl = selectedTaskCollToShowDetails
                //destVC.taskList = taskListToPass
            }
            
        case "showAddTask":
            if let destVC = segue.destination as? AddTaskVC{
                if let theOtherEventHanlder = eventHandlerDelegate as? MainTimerScreenVC{
                    destVC.taskAddVCEventHandlerDelegate = theOtherEventHanlder //TODO: maybe not a good way to get back to the mainscreen vc.
                }
//                tableView.reloadData()
            }
            
        default:
            break
        }
        
        
        if segue.identifier == "showTaskDetails"{
        }
    }
    
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAddTask", sender: self)
        self.allTasks = []
    }
    
    
    
    @IBAction func dismissScreen(_ sender: UIBarButtonItem) {
        dismissScreen()
    }
    
    func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
    

}
