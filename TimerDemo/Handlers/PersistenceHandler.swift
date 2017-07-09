//
//  PersistenceHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/19/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class PersistenceHandler {
    
    static let shared = PersistenceHandler()
    
    var ref: DatabaseReference!
    
    private init() {
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
    }

    
    // =============================================//
    //         MARK: Task Processing
    // =============================================//
    
    func saveTask(task : Task) {
        print("Will now save task \(task)")
        //self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(task.taskID.uuidString).setValue(task.jsonFormat)
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(task.taskID.uuidString).setValue(["taskDetails" : task.dictFormat])
        
        self.fetchTaskCollectionWithName(taskName: task.taskName) { (fetchedTaskColl) in
            if fetchedTaskColl != nil{
                let updatedTaskColl = fetchedTaskColl?.addTaskID(task: task)
                self.saveTaskCollection(taskColl: updatedTaskColl!)
            }
        }
    }
    
    func fetchTaskWithID(taskID : String, completionHandler : @escaping (_ fetchedTask : Task)->()) {
        print("PH : Fetching Task For \(taskID)")
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(taskID).child("taskDetails").observe(DataEventType.value, with: { (snapshot) in
            let fetchedTaskDict = snapshot.value as? [String:Any?] ?? [:]
            if let theTask = Task(firebaseDict: fetchedTaskDict){
                print("PH : I have now created a task \(theTask)")
                completionHandler(theTask)
            }
        })
    }
    
    func fetchTasksWithID(taskIDArray : [String], completionHandler : @escaping (_ fetchedTaskArr : [Task])->()) {
        
        print("PH : I am going to fetch values for \(taskIDArray)")
        var tempTaskArr = [Task]()
        
        for i in 0..<taskIDArray.count{
            let eachTaskID = taskIDArray[i]
            self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(eachTaskID).child("taskDetails").observe(DataEventType.value, with: { (snapshot) in
                let fetchedTaskDict = snapshot.value as? [String:Any?] ?? [:]
                if let theTask = Task(firebaseDict: fetchedTaskDict){
                    tempTaskArr.append(theTask)
                    print("Duration for this task is : \(theTask.timer.timerElapsedTime)")
                    if i == taskIDArray.count - 1 {
                        completionHandler(tempTaskArr)
                    }
                }
            })
        }
        
    }
    
    
    
    
    // =============================================//
    //         MARK: User Info Processing
    // =============================================//
    
    func saveUserInfo(userInfo : UserInfo, completionHandler : (()->())? = nil) {
//        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("UserInfo").child("UserDetails").setValue(userInfo.dictFormat)
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("UserInfo").child("UserDetails").setValue(userInfo.dictFormat) { (_, _) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newTaskAddedToRecentTasks"), object: nil)
        }
        
    }
    
    func fetchUserInfo(completionHandler : @escaping (_ theUserInfo : UserInfo)->()) {
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("UserInfo").child("UserDetails").observeSingleEvent(of: .value, with: { (snapshot) in
            let fetchedUserInfo = snapshot.value as? [String : Any?] ?? [:]
            
            if fetchedUserInfo.isEmpty{
                self.setInitialValueForUserInfo(completionHanlder_: { (theUserInfo) in
                    completionHandler(theUserInfo)
                })
            }else{
                if let tempUser = UserInfo(firebaseDict: fetchedUserInfo){
                    completionHandler(tempUser)
                }
            }
        })
    }
    
    func setInitialValueForUserInfo(completionHanlder_  : (_ theUserInfo : UserInfo) -> ()) {
        let tempUser = UserInfo(userID: "", isAnonymous: true, userName: "", displayName: "", email: "", phone: "", recentUsedTaskColl: ["Default"], mostUsedTaskColl: ["Default"])
        saveUserInfo(userInfo: tempUser)
        completionHanlder_(tempUser)
    }
    
    
    
    
    // =============================================//
    //         MARK: Task Collection Processing
    // =============================================//
    
    func saveTaskCollection(taskColl : TaskCollection) {
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("TaskCollection").child(taskColl.taskName).setValue(taskColl.dictFormat)
    }
    
    func fetchAllTaskCollections(completionHandler : ((_ fetchedTaskColl : [TaskCollection])->())? = nil){
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("TaskCollection").observe(DataEventType.value, with: { (snapshot) in
            let fetchedDictAllColl = snapshot.value as? [String:[String : Any?]] ?? [:]
            let collArray = Array(fetchedDictAllColl.values)
            
            var tempTaskCollArray = [TaskCollection]()
            
                for eachColl in collArray{
                    if let tempColl = TaskCollection(firebaseDict: eachColl){
                        tempTaskCollArray.append(tempColl)
                    }
                }
            completionHandler?(tempTaskCollArray)
        })
    }
    
    
    func fetchTaskCollectionsMatchingNames(taskCollNames : [String], completionHandler : @escaping (_ taskCollArray : [TaskCollection]) -> ()) {
        var tempMatchedTaskCollArray = [TaskCollection]()
        for eachIndex in 0..<taskCollNames.count{
            
            fetchTaskCollectionWithName(taskName: taskCollNames[eachIndex], completionHandler: { (theTaskColl) in
                if let validTaskColl = theTaskColl{
                    tempMatchedTaskCollArray.append(validTaskColl)
                    
                    if (eachIndex == (taskCollNames.count - 1)){
                        completionHandler(tempMatchedTaskCollArray)
                    }
                }
            })
            
        }
    }
    
    func fetchTaskCollectionWithName(taskName : String, completionHandler : ((_ fetchedTaskCollArr : TaskCollection?)->())? = nil) {
        //TODO: prashanth this looks a little fishy.
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("TaskCollection").child(taskName).observeSingleEvent(of: .value, with: { (snapshot) in
            if let fetchedDict = snapshot.value as? [String : AnyObject]{
                if let tempTaskColl = TaskCollection(firebaseDict: fetchedDict){
                    completionHandler?(tempTaskColl)
                }
            }else{
                // On first launch we will not have a task collection, or may be we should.. just incase .. crete on ehre
                let defaultTaskColl = TaskCollection(taskName: taskName)
                completionHandler?(defaultTaskColl)
            }
        })
    }
    
    func fetchTotalTimeForTaskCollection(taskCollection : TaskCollection, completionHanlder : @escaping (_ totalTime : TimeInterval) -> ()) {
        
        print("\t\t\tPH : Fetching total time .... Begin")
        
        var totalTime : TimeInterval = 0
        
            self.fetchTasksWithID(taskIDArray: taskCollection.allAssociatedTaskIDs(), completionHandler: { (theTaskArr) in
                assert(!theTaskArr.isEmpty, "We Have got back an empty task array")
                for eachTask in theTaskArr{
                    print("!!!!!!!!!!!!!!!!!!!!!!!!!   \(eachTask.taskID) : \(eachTask.timer.timerElapsedTime)")
                    totalTime += (eachTask.timer.timerElapsedTime ?? 0)
                }
                completionHanlder(totalTime)
            })
    }
    
    // =============================================//
    //         MARK: Preferences Processing
    // =============================================//
    
    func setInitialValueForPreferences(completionHanlder : () -> ()) {
        
        let prefDetailsArray = ["Goals":["dailyGoal" : ["displayName" : "Daily Goal","currentValue" : 5,"listOfValues" : [1,2,3,4,5],"unitName" : "Sessions"]],
                                "Alerts":[
                                    "isVibrateOn" : ["displayName" : "Vibrate","currentValue" : false,"listOfValues" : [true,false],"unitName" : ""],
                                    "taskCompletedSound":["displayName":"Task Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""],
                                    "longBreakCompletedSound":["displayName":"Long Break Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""],
                                    "shortBreakCompletedSound":["displayName":"Short Break Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""]
            ],
                                "Intervals":[
                                    "shortBreakInterval" : ["displayName" : "Short Break Interval","currentValue" : 5,"listOfValues" : [1,2,3,4,5,6,7,8,9,10],"unitName" : "Sessions"],
                                    "longBreakInterval" : ["displayName" : "Long Break Interval","currentValue" : 5,"listOfValues" : [1,2,3,4,5,6,7,8,9,10],"unitName" : "Sessions"]
            ],
                                "Duration":[
                                    "taskDurationMinutes" : ["displayName" : "Task Duration","currentValue" : 25,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"],
                                    "shortBreakDurationMinutes" : ["displayName" : "Short Break Duration","currentValue" : 25,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"],
                                    "longBreakDurationMinutes" : ["displayName" : "Long Break Duration","currentValue" : 5,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"]
            ]]
        
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").setValue(prefDetailsArray)
        completionHanlder()
        
        
//        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").child("Goals").setValue(["dailyGoal" : ["displayName" : "Daily Goal","currentValue" : 5,"listOfValues" : [1,2,3,4,5],"unitName" : "Sessions"]])
//
//
//        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").child("Alerts").setValue([
//                            "isVibrateOn" : ["displayName" : "Vibrate","currentValue" : false,"listOfValues" : [true,false],"unitName" : ""],
//                            "taskCompletedSound":["displayName":"Task Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""],
//                            "longBreakCompletedSound":["displayName":"Long Break Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""],
//                            "shortBreakCompletedSound":["displayName":"Short Break Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""]
//            ])
//
//        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").child("Intervals").setValue(
//            [
//                "shortBreakInterval" : ["displayName" : "Short Break Interval","currentValue" : 5,"listOfValues" : [1,2,3,4,5,6,7,8,9,10],"unitName" : "Sessions"],
//                "longBreakInterval" : ["displayName" : "Long Break Interval","currentValue" : 5,"listOfValues" : [1,2,3,4,5,6,7,8,9,10],"unitName" : "Sessions"]
//            ])
//
//        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").child("Duration").setValue(
//            [
//                "taskDurationMinutes" : ["displayName" : "Task Duration","currentValue" : 25,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"],
//                "shortBreakDurationMinutes" : ["displayName" : "Short Break Duration","currentValue" : 25,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"],
//                "longBreakDurationMinutes" : ["displayName" : "Long Break Duration","currentValue" : 5,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"]
//            ])
        
    }
    
    func fetchAllPreferences(completionHandler : @escaping (_ fetchedPreference : [String : AnyObject])->()) {
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if postDict.isEmpty{
                self.setInitialValueForPreferences {
                    print("____________Completion called from isempty")
                    self.fetchAllPreferences(completionHandler: { (fetchedValues) in
                        completionHandler(fetchedValues)
                    })
                }
            }else{
                print("____________Completion called from ELSE")
                completionHandler(postDict)
                }            
        })
    }
    
    func fetchPreferenceCategory(preferenceType : PreferenceType, completionHandler : @escaping (_ fetchedPreference : [String : AnyObject])->()) {
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").child(preferenceType.rawValue).observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            completionHandler(postDict)            
        })
    }
    
    //TODO: Each time a value in perferece changes, we are updating the entire category, this needs to be changed to modify only that specific Perfernce.
    func updatePreferenceCategory(preferenceType : PreferenceType, withPreference : PreferenceCategory) {
        for eachPerf in withPreference.allPerferences{
                self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Preferences").child("PreferenceDetails").child(preferenceType.rawValue).child(eachPerf.name).setValue(eachPerf.dictFormat)
        }
    }
}












extension Timer{
    
}
