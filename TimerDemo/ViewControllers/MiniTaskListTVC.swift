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
    let tableMoreRowHeight : CGFloat = 30.0
    
    var eventHandlerDelegate : TaskPickerTVCEventHandlerDelegate?
    
    func isLastRowInTable(theIndexPath : IndexPath) -> Bool{
        return theIndexPath.row == taskCollectionList.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MiniTaskListTVC.fetchInfoForTableAndReload), name: NSNotification.Name(rawValue: "newTaskAddedToRecentTasks"), object: nil)
        fetchInfoForTableAndReload()
    }
        
    @objc func fetchInfoForTableAndReload()  {
        let recentTasks = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: 3)
        
        PersistenceHandler.shared.fetchTaskCollectionsMatchingNames(taskCollNames: recentTasks) { (allTaskCollections) in
            self.taskCollectionList = allTaskCollections
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskCollectionList.count + 1  // +1 for More... row.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Are we on the last cell.
        if isLastRowInTable(theIndexPath: indexPath){
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreTaskListCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "miniTaskListCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = taskCollectionList[indexPath.row].taskName
        
        let totalDuartion = Utilities.shared.getHHMMSSFrom(seconds: Int(taskCollectionList[indexPath.row].totalDurationCompletedTasks))
        cell.detailTextLabel?.text = totalDuartion
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isLastRowInTable(theIndexPath: indexPath) ? tableMoreRowHeight : calcCellHeight()
    }
    
    func calcCellHeight() -> CGFloat {
        return (tableView.frame.height - tableHeaderHeight - tableMoreRowHeight)/CGFloat(taskCollectionList.count)   // +1 for the more... row.
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableHeaderHeight * 0.75))
        headerView.backgroundColor = UIColor.white
        headerView.font = Utilities.shared.regularFontSize
        headerView.textAlignment = .center
        headerView.textColor = Utilities.shared.darkGrayColor
        headerView.text = "Recent Tasks"
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isLastRowInTable(theIndexPath: indexPath){
            eventHandlerDelegate?.userWantsToViewMoretasks()
            return
        }
        
        eventHandlerDelegate?.userPickedATaskWithName(name: taskCollectionList[indexPath.row].taskName)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
