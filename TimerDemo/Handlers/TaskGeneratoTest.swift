//
//  TaskGeneratoTest.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/19/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import Firebase

extension PersistenceHandler {

    func saveTestTask(taskDict: [String: Any?]) {
            self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").childByAutoId().setValue(taskDict)

            self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").queryLimited(toLast: 5) .observe(.childAdded, with: { (snapshot) in

                self.fetchTaskCollectionWithName(taskName: taskDict["taskName"] as! String) { (fetchedTaskColl) in
                    let thePostDict = snapshot.value as? [String: Any?] ?? [:]
                    if let thetempTask = Task(firebaseDict: thePostDict) {
                        if fetchedTaskColl != nil {
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

    var theArr: [[String: Any?]] = []

    var timer: Timer!
    var currentIndex = 0

    func saveTestTask() {

        let today = Date()
        let dateForm = DateFormatter()
        dateForm.dateFormat = "YYYY"
        let yearBoy = Int(dateForm.string(from: today))!

        dateForm.dateFormat = "MM"
        let monthBoy = Int(dateForm.string(from: today))!

        dateForm.dateFormat = "dd"
        let dayBoy = Int(dateForm.string(from: today))!

        //=========================== //
        //  Create Tasks for Today
        //=========================== //
        let numberOfTodayTasks = 10

        for _ in 0...numberOfTodayTasks {
            let result = createDateFromComponents(year: yearBoy, month: monthBoy, day: dayBoy, hour: Int(arc4random_uniform(23)), minute: Int(arc4random_uniform(59)), second: Int(arc4random_uniform(59)))
            theArr.append(["isPerfectTask": true, "taskName": "Today Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": result.firebaseDate + 250, "startTime": result.firebaseDate, "duration": 5.0], "taskType": "deepFocus", "savedDate" : result.firebaseDate] as [String: Any])
            print(result.descString)
        }

        //        //=========================== //
        //        //  Create Tasks for yesterday
        //        //=========================== //
        //        let numberOfYesterdayTasks = 10
        //
        //        for _ in 0...numberOfYesterdayTasks{
        //            let result = createDateFromComponents(year: yearBoy, month: monthBoy, day: dayBoy - 1, hour: Int(arc4random_uniform(23)), minute: Int(arc4random_uniform(59)), second: Int(arc4random_uniform(59)))
        //
        //            theArr.append(["isPerfectTask": true, "taskName": "Yesterday Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": result.firebaseDate + 250, "startTime": result.firebaseDate, "duration": 5.0], "taskType": "deepFocus","savedDate" : result.firebaseDate] as [String : Any])
        //            print(result.descString)
        //        }
        //
        //
        //        //=========================== //
        //        //  Create Tasks for This week
        //        //=========================== //
        //        let numberOfWeekTasks = 10
        //
        //        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        //        let dslTimeOffset = NSTimeZone.local.daylightSavingTimeOffset(for: date)
        //        let weekStartDate = date.addingTimeInterval(dslTimeOffset)
        //
        //        dateForm.dateFormat = "dd"
        //        dateForm.string(from: weekStartDate)
        //        let weekStart = Int(dateForm.string(from: weekStartDate))!
        //
        //
        //        for _ in 0...numberOfWeekTasks{
        //            let result = createDateFromComponents(year: yearBoy, month: monthBoy, day: Int(arc4random_uniform(UInt32(7))) + weekStart, hour: Int(arc4random_uniform(23)), minute: Int(arc4random_uniform(59)), second: Int(arc4random_uniform(59)))
        //
        //            theArr.append(["isPerfectTask": true, "taskName": "Week Task", "pauseList": [], "taskStatus": "completed", "timer": ["currentTimerValue": 0.0, "endTime": result.firebaseDate + 250, "startTime": result.firebaseDate, "duration": 5.0], "taskType": "deepFocus","savedDate" : result.firebaseDate] as [String : Any])
        //            print(result.descString)
        //        }

        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (_) in
            self.reallySaveTestTask()
        }
        timer.fire()
    }

    func createDateFromComponents(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> (descString: String, firebaseDate: TimeInterval) {

        var components = DateComponents()

        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second

        let theFormatter = DateFormatter()
        theFormatter.dateFormat = "dd-MMM-YYYY hh:mm:ss"

        theFormatter.string(from: Calendar.current.date(from: components)!)

        //print("Date is : \(Calendar.current.date(from: components)!)")
        let finalDate = Calendar.current.date(from: components)!
        //    print("\(theFormatter.string(from: finalDate))                  -> Date : \(finalDate)        -> Firebase Date  : \(finalDate.timeIntervalSince1970)         -> Since Ref Date : \(finalDate.timeIntervalSinceReferenceDate)")

//        print("\(theFormatter.string(from: finalDate))                  -> Date : \(finalDate)        -> Firebase Date : \"savedDate\" : \(finalDate.timeIntervalSince1970 * 1000)         -> Since Ref Date : \(finalDate.timeIntervalSinceReferenceDate)")

        let stringToReturn = "\(theFormatter.string(from: finalDate))                  -> Date : \(finalDate)        -> Firebase Date : \"savedDate\" : \(finalDate.timeIntervalSince1970 * 1000)         -> Since Ref Date : \(finalDate.timeIntervalSinceReferenceDate)"

        return (stringToReturn, finalDate.timeIntervalSince1970 * 1000.0)

    }

    func reallySaveTestTask() {

        //let theArr : [[String:Any?]] = []

        // Saving Tasks for today :
        PersistenceHandler.shared.saveTestTask(taskDict: theArr[currentIndex])
        currentIndex += 1

        if currentIndex == theArr.count {
            timer.invalidate()
            theArr = []
        }

    }
}

//
