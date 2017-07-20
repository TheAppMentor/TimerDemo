//
//  TaskGeneratoTest.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/19/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import Firebase

extension PersistenceHandler{

    func saveTestTask(taskDict : [String:Any?]) {
            self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").childByAutoId().setValue(taskDict)
            
            
            self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").queryLimited(toLast: 5) .observe(.childAdded, with: { (snapshot) in
                
                self.fetchTaskCollectionWithName(taskName: taskDict["taskName"] as! String) { (fetchedTaskColl) in
                    let thePostDict = snapshot.value as? [String : Any?] ?? [:]
                    if let thetempTask = Task(firebaseDict: thePostDict){
                        if fetchedTaskColl != nil{
                            let updatedTaskColl = fetchedTaskColl?.addTaskID(taskID: snapshot.key, task: thetempTask)
                            self.saveTaskCollection(taskColl: updatedTaskColl!)
                        }
                    }
                }
            })
        }
    
}


class TestTaskGenerator {
    
    static let shared = TestTaskGenerator()
    
    var timer : Timer!
    
    func saveTestTask(){
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (_) in
            self.reallySaveTestTask()
        }
        
        timer.fire()
    }
    
    var currentIndex = 0
    
    func reallySaveTestTask(){
   
//        let theArr = [
//        ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500431400000] as [String : Any],
//
//        ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500435000000] as [String : Any],
//
//        ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500445800000] as [String : Any],
//        ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500449400000] as [String : Any],
//
//        ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500456540000] as [String : Any],
//
//        ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500474600000] as [String : Any]
//        ]

        
//        // FOR all Months of the year.
//        let theArr = [["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1513564200000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1510889400000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1508135400000.0 ],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1505460600000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1502782200000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500345000000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1497670200000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1494916200000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1492241400000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1489483740000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1486996200000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1484231400000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1484231400000.0],
//         ["isPerfectTask": true, "taskName": "Year Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1484231400000.0]]
        
        // For This week.
        
//        let theArr = [["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500345000000.0],
//                      ["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500262200000.0],
//                      ["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500186600000.0],
//                      ["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500103800000.0],
//                      ["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500024540000.0],
//                      ["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1499956200000.0],
//                      ["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1499869800000.0]]

        // For Evey Day of the current week.
        
//        let theArr = [["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500517800000.0],
//         ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500521400000.0],
//         ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500532200000.0],
//         ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500535800000.0],
//         ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500024540000.0],
//         ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500542940000.0],
//         ["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": 1500465598.8877659, "startTime": 1500465592.885612, "duration": 5.0], "taskType": "deepFocus","savedDate" : 1500561000000.0]]

        let theArr : [[String:Any?]] = []
        
        // Saving Tasks for today :
        PersistenceHandler.shared.saveTestTask(taskDict: theArr[currentIndex])
        currentIndex += 1
        
        if currentIndex == theArr.count{
            timer.invalidate()
        }
        
        
    }
}




//


