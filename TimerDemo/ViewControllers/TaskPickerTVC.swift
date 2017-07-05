	//
//  TaskListTVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/1/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class TaskPickerTVC: UITableViewController {
    
    //var allTasks : [TaskCollection]
    var allTasks : [String] = []
    var selectedTaskCollToShowDetails : TaskCollection?
    var taskListToPass = [String : Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        PersistenceHandler.shared.fetchAllTaskCollections(completionHandler: { (theTaskColl) in
            //self.allTasks = theTaskColl.map({return $0.taskName})
            theTaskColl.forEach({self.allTasks.append($0.taskName)})
            print("Reloading the Task with : \(self.allTasks)")
            self.tableView.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: Utilities.shared.regularFontSize]
        
        tableView.tableFooterView = UIView()
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
            print("We have a task collection man.. \(fetchedTaskCollection)")
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
                totalTimeLabel.text = "3 hr 44 min"
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        PersistenceHandler.shared.fetchTaskCollectionWithName(taskName: allTasks[indexPath.row]) { (fetchedTaskCollection) in
            print("We have a task collection man.. \(fetchedTaskCollection)")
            self.selectedTaskCollToShowDetails = fetchedTaskCollection
            
            //Fetch all associated Tasks Also :  //TODO: THis is where we need the smart logic to fetch only those tasks that the tbleview actually needs. Dont fetch everything.
            PersistenceHandler.shared.fetchTasksWithID(taskIDArray: (self.selectedTaskCollToShowDetails?.allAssociatedTaskIDs())!, completionHandler: { (theTask) in
                self.taskListToPass[theTask.taskID.uuidString] = theTask
                self.performSegue(withIdentifier: "showTaskDetails", sender: self)
            })
            
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Selected : \(allTasks[indexPath.row])")
        PersistenceHandler.shared.fetchTaskCollectionWithName(taskName: allTasks[indexPath.row]) { (fetchedTaskCollection) in
            print("We have a task collection man.. \(fetchedTaskCollection)")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTaskDetails"{
            if let destVC = segue.destination as?  TaskDetailsVC{
                destVC.currentTaskColl = selectedTaskCollToShowDetails
                destVC.taskList = taskListToPass
                print("Passing Task List : \(taskListToPass)")
                
            }
        }
    }
    
    @IBAction func dismissScreen(_ sender: UIBarButtonItem) {
        dismissScreen()
    }
    
    func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
    

}
