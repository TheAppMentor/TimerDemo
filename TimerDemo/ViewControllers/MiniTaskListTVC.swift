//
//  MiniTaskListTVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class MiniTaskListTVC: UITableViewController {
    
    var taskCollectionList = [TaskCollection]()
    let tableHeaderHeight : CGFloat = 30.0
    
    var eventHandlerDelegate : TaskPickerTVCEventHandlerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(MiniTaskListTVC.fetchInfoForTableAndReload), name: NSNotification.Name(rawValue: "newTaskAddedToRecentTasks"), object: nil)
        fetchInfoForTableAndReload()
        
    }
    
    func fetchInfoForTableAndReload()  {
        let recentTasks = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: 3)
        
        PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: recentTasks) { (allTaskCollections) in
            self.taskCollectionList = allTaskCollections
            self.tableView.reloadData()
        }
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
        return taskCollectionList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miniTaskListCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = taskCollectionList[indexPath.row].taskName
        
        let totalDuartion = Utilities.shared.getHHMMSSFrom(seconds: Int(taskCollectionList[indexPath.row].totalDurationCompletedTasks))
        cell.detailTextLabel?.text = totalDuartion
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calcCellHeight()
    }
    
    func calcCellHeight() -> CGFloat {
        return (tableView.frame.height - tableHeaderHeight)/CGFloat(taskCollectionList.count)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.white
        headerView.font = Utilities.shared.largeFontSize
        headerView.textAlignment = .center
        headerView.textColor = Utilities.shared.darkGrayColor
        headerView.text = "Recent Tasks"
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandlerDelegate?.userPickedATaskWithName(name: taskCollectionList[indexPath.row].taskName)
        tableView.deselectRow(at: indexPath, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
