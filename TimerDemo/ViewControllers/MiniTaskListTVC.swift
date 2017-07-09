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
}
