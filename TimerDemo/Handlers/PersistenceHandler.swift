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
        
        print("Save Task Called")
        
        var taskDictToSave = task.dictFormat
        taskDictToSave["savedDate"] = [".sv":"timestamp"]
        
        //self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").childByAutoId().setValue(taskDictToSave)
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").childByAutoId().setValue(taskDictToSave) { (theError, dbRef) in
            
            print("The Key is : \(dbRef.key)")
            
            self.fetchTaskWithID(taskID: dbRef.key, completionHandler: { (theTask) in
                
                self.fetchTaskCollectionWithName(taskName: theTask.taskName) { (fetchedTaskColl) in
                        if fetchedTaskColl != nil{
                            let updatedTaskColl = fetchedTaskColl?.addTaskID(taskID: dbRef.key, task: theTask)
                            self.saveTaskCollection(taskColl: updatedTaskColl!)
                        }
                    }
                })
        }
    }
            
            
            
            
            
            
            
            
            
            
            
            
            
//            if theError == nil{
//                self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").queryEqual(toValue: dbRef.key).observe(.childAdded, with: { (snapshot) in
//                    print("SnapShot Value is : \(snapshot.value as? [String:Any?] ?? [:])")
//                })
//
////                self.fetchTaskCollectionWithName(taskName: task.taskName) { (fetchedTaskColl) in
////                    let thePostDict = dbRef.v .value as? [String : Any?] ?? [:]
////                    if let thetempTask = Task(firebaseDict: thePostDict){
////                        if fetchedTaskColl != nil{
////                            let updatedTaskColl = fetchedTaskColl?.addTaskID(taskID: dbRef.key, task: thetempTask)
////                            self.saveTaskCollection(taskColl: updatedTaskColl!)
////                        }
////                    }
////                }
//
//            }
//
//        }
//
//
////        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
////
////            self.fetchTaskCollectionWithName(taskName: task.taskName) { (fetchedTaskColl) in
////                let thePostDict = snapshot.value as? [String : Any?] ?? [:]
////                if let thetempTask = Task(firebaseDict: thePostDict){
////                    if fetchedTaskColl != nil{
////                        let updatedTaskColl = fetchedTaskColl?.addTaskID(taskID: snapshot.key, task: thetempTask)
////                        self.saveTaskCollection(taskColl: updatedTaskColl!)
////                    }
////                }
////            }
//        })
//    }
    
    func fetchTaskWithID(taskID : String, completionHandler : @escaping (_ fetchedTask : Task)->()) {
        print("PH : Fetching Task For \(taskID)")
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(taskID).observe(DataEventType.value, with: { (snapshot) in
            let fetchedTaskDict = snapshot.value as? [String:Any?] ?? [:]
            if let theTask = Task(firebaseDict: fetchedTaskDict){
                print("PH : I have now created a task \(theTask)")
                completionHandler(theTask)
            }
        })
    }
    
    func fetchAllTasksMatchingArray(taskIDArray : [String], completionHandler : @escaping (_ fetchedTaskArr : [Task])->()) {
        
        var tempTaskArr = [Task]()
        
        for i in 0..<taskIDArray.count{
            let eachTaskID = taskIDArray[i]
            self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(eachTaskID).observeSingleEvent(of: .value, with: { (snapshot) in
                let fetchedTaskDict = snapshot.value as? [String:Any?] ?? [:]
                if let theTask = Task(firebaseDict: fetchedTaskDict){
                    tempTaskArr.append(theTask)
                    if i == taskIDArray.count - 1 {
                        completionHandler(tempTaskArr)
                    }
                }
            })
        }
    }
    
    func fetchAllTasksForTimePeriod(taskname : String? = nil, timePeriod : TimePeriod, completionHanlder : @escaping (_ fetchedTaskArr : [Task])->()) {
        
        let calendar = Calendar.current
        let today = Date()
        var queryStartDate : TimeInterval?
        var queryEndDate : TimeInterval?

        switch timePeriod {
        case .today:
            queryStartDate = today.startOfToday.timeIntervalSince1970 * 1000
            queryEndDate = today.endOfToday.timeIntervalSince1970 * 1000
        
        case .week:
            print("We need to figure out how to handle this")
            queryStartDate = today.startOfWeek.timeIntervalSince1970 * 1000
            queryEndDate = today.endOfWeek.timeIntervalSince1970 * 1000
            
        case .month:
            print("We need to figure out how to handle this")
            queryStartDate = today.startOfMonth().timeIntervalSince1970 * 1000
            queryEndDate = today.endOfMonth().timeIntervalSince1970 * 1000

        case .allTime:
            print("fetch tasks for today")
        }
        
        print("Querying for ......  \(createDateFromTimeInterval(timeInterval: queryStartDate!/1000)) : \(createDateFromTimeInterval(timeInterval: queryEndDate!/1000))")

        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").queryOrdered(byChild: "savedDate").queryStarting(atValue: queryStartDate).queryEnding(atValue: queryEndDate).observeSingleEvent(of: .value, with: { (snapshot) in

            let postDict = snapshot.value as? [String:Any?] ?? [:]
            var tempTaskArr = [Task]()
            for (_,eachTask) in postDict.enumerated(){
                if let validTaskDict = eachTask.value as? [String : Any?]{
                    if let tempTask = Task(firebaseDict: validTaskDict){
                        let theTime = validTaskDict["savedDate"] as! TimeInterval
                        print("\(tempTask.taskName) \t\t-> \(self.createDateFromTimeInterval(timeInterval: theTime/1000))")
                        tempTaskArr.append(tempTask)
                    }
                }
            }
            
            var matchingTasks : [Task] = []
            var sortedTempTask : [Task] = []
            // Group the fetched tasks based on task name.
            if let validTaskName = taskname{
                matchingTasks = tempTaskArr.filter({ return $0.taskName == validTaskName})
            }
            
            // Sort Matching tasks by Saved date.
            sortedTempTask = matchingTasks.sorted(by: { (task1, task2) -> Bool in
                guard let validTask1 = task1.savedDate else {return false}
                guard let validTask2 = task2.savedDate else {return false}
                return validTask1 > validTask2
            })

            
            var tempTaskGroupingDict = [Int:[Task]]()
            
            // Group tasks by time period :
            switch timePeriod{
            case .month :
                for eachTask in sortedTempTask{
                    let theTaskDate = Date(timeIntervalSince1970: eachTask.savedDate!/1000)
                    if let ordinality = Calendar.current.ordinality(of: .weekOfMonth, in: .month, for: theTaskDate){
                        print("Date is \(self.createDateFromTimeInterval(timeInterval: eachTask.savedDate!/1000)) : Ordinality : \(ordinality)")

                        var tempArr = tempTaskGroupingDict[ordinality] ?? [Task]()
                        tempArr.append(eachTask)
                        tempTaskGroupingDict[ordinality] = []
                        tempTaskGroupingDict[ordinality] = tempArr
                    }
                }
                break

            case .week :
                for eachTask in sortedTempTask{
                    let theTaskDate = Date(timeIntervalSince1970: eachTask.savedDate!/1000)

                    
                    
                    if let ordinality = Calendar.current.dateComponents([.weekday], from: theTaskDate).weekday{
                        print("Date is \(self.createDateFromTimeInterval(timeInterval: eachTask.savedDate!/1000)) : Ordinality : \(ordinality)")
                        
                        var tempArr = tempTaskGroupingDict[ordinality] ?? [Task]()
                        tempArr.append(eachTask)
                        tempTaskGroupingDict[ordinality] = []
                        tempTaskGroupingDict[ordinality] = tempArr
                    }
                }
                break

            case .today :
                for eachTask in sortedTempTask{
                    let theTaskDate = Date(timeIntervalSince1970: eachTask.savedDate!/1000)
                    
                    if let ordinality = Calendar.current.dateComponents([.hour], from: theTaskDate).hour{
                        print("Date is \(self.createDateFromTimeInterval(timeInterval: eachTask.savedDate!/1000)) : Ordinality : \(ordinality)")
                        
                        var tempArr = tempTaskGroupingDict[ordinality] ?? [Task]()
                        tempArr.append(eachTask)
                        tempTaskGroupingDict[ordinality] = []
                        tempTaskGroupingDict[ordinality] = tempArr

                    }
                }
                break

                
            default :
                break
            }
            
            print("Grouped Tasks ---> : \(tempTaskGroupingDict)")
            completionHanlder(sortedTempTask)
        })
    }
    
    
    
    
    func createDateFromTimeInterval(timeInterval : TimeInterval) -> String{
        let dateSinceRefDate = Date(timeIntervalSinceReferenceDate: timeInterval)
        let dateSince1970 = Date(timeIntervalSince1970: timeInterval)
        
        let theFormatter = DateFormatter()
        theFormatter.dateFormat = "dd-MMM-YYYY HH:MM:SS"
        
        let displayFormat = theFormatter.string(from: dateSince1970)
        
        return displayFormat
        
        //print("\(displayFormat) (since 1790)     Since 1970 * 1000 ->  \(dateSince1970)   Since Ref Date * 1000 -> \(dateSinceRefDate)")
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
        let tempUser = UserInfo(userID: "", isAnonymous: true, userName: "", displayName: "", email: "", phone: "", recentUsedTaskColl: [], mostUsedTaskColl: [])
        saveUserInfo(userInfo: tempUser)
        completionHanlder_(tempUser)
    }
    
    
    
    
    // =============================================//
    //         MARK: Task Collection Processing
    // =============================================//
    
    func saveTaskCollection(taskColl : TaskCollection) {
       
       print("Save Task Collection Got Called")
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
        
            self.fetchAllTasksMatchingArray(taskIDArray: taskCollection.allAssociatedTaskIDs(), completionHandler: { (theTaskArr) in
                assert(!theTaskArr.isEmpty, "We Have got back an empty task array")
                for eachTask in theTaskArr{
                    totalTime += (eachTask.timer.timerElapsedTime ?? 0)
                }
                completionHanlder(totalTime)
            })
    }
    
    // =============================================//
    //         MARK: Preferences Processing
    // =============================================//
    
    func setInitialValueForPreferences(completionHanlder : () -> ()) {
        
        let prefDetailsArray = [//"Goals":["dailyGoal" : ["displayName" : "Daily Goal","currentValue" : 5,"listOfValues" : [1,2,3,4,5],"unitName" : "Sessions"]],
                                "Alerts":[
                                    "isVibrateOn" : ["displayName" : "Vibrate","currentValue" : false,"listOfValues" : [true,false],"unitName" : ""],
                                    "taskCompletedSound":["displayName":"Task Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""],
                                    //"longBreakCompletedSound":["displayName":"Long Break Completed Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""],
                                    "shortBreakCompletedSound":["displayName":"Short Break Done Alert","currentValue":"Alert Tune 1","listOfValues":["Alert Tune 1","Alert Tune 2","Alert Tune 3"],"unitName" : ""]
            ],
                                //"Intervals":[
                                    //"shortBreakInterval" : ["displayName" : "Short Break Interval","currentValue" : 5,"listOfValues" : [1,2,3,4,5,6,7,8,9,10],"unitName" : "Sessions"],
                                    //"longBreakInterval" : ["displayName" : "Long Break Interval","currentValue" : 5,"listOfValues" : [1,2,3,4,5,6,7,8,9,10],"unitName" : "Sessions"]
            //],
                                "Duration":[
                                    "taskDurationMinutes" : ["displayName" : "Task Duration","currentValue" : 25,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"],
                                    "shortBreakDurationMinutes" : ["displayName" : "Short Break Duration","currentValue" : 25,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"],
                                    //"longBreakDurationMinutes" : ["displayName" : "Long Break Duration","currentValue" : 5,"listOfValues" : [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90],"unitName" : "Minutes"]
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
