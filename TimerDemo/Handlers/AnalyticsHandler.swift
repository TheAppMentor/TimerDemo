//
//  AnalyticsHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 3/1/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import Foundation


struct AnalyticsHandler {
    
    init(taskListingViewModel : TaskListingViewModel) {
        print("Here is the data... firebaseData")
    }
    
//    func getTaskDetailsWithMaxTime(timePeriod : TimePeriod, completionH : @escaping (_ TaskName : String, _ TaskDuration : CFTimeInterval, _ sessions : Int) -> ()) {
//
//        PersistenceHandler.shared.fetchTotalTimeForTaskCollection(taskCollection: <#T##TaskCollection#>, completionHanlder: <#T##(TimeInterval) -> Void#>)
//
//        PersistenceHandler.shared.fetchAllInformationForCurrentUser { (theUserInfo) in
//            print("🍺🍺🍺🍺🍺🍺 -> fetchAllInformationForCurrentUser ")
//            print(theUserInfo)
//            completionH("Hello", 2000.0, 10)
//        }
//    }
//
//    func fetchTaskNameForMaxTime(timePeriod : TimePeriod, taskCollections : [] ) -> String {
//
//
//
//        return ""
//    }
}
