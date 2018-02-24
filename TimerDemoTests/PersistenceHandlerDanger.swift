//
//  PersistenceHandlerDanger.swift
//  TimerDemoTests
//
//  Created by Moorthy, Prashanth on 2/19/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import Firebase

extension PersistenceHandler {
    
    func deleteTaskColl(taskName : String){
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("TaskCollection").child(taskName).child("listOfAssociatedTaskID").observe(DataEventType.value) { (snapshot) in
            let fetchedTaskIDArr = snapshot.value as? [String] ?? []
            
            self.deleteTaskWithIDs(taskID: fetchedTaskIDArr, compH: {
                self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("TaskCollection").child(taskName).removeValue { (theErr, dbRef) in
                    sleep(1)
                }
            })
        }
    }
    
    func deleteTaskWithIDs(taskID : [String], compH : ()->()){
        for eachTaskID in taskID{
            print("Deleting Task ID : \(eachTaskID)")
            ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(eachTaskID)
        }
        compH()
    }    
}



