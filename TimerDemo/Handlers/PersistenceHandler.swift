//
//  PersistenceHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/19/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PersistenceHandler {
    
    static let shared = PersistenceHandler()
    
    var ref: DatabaseReference!
    
    private init() {
        ref = Database.database().reference()
    }
    
    func saveTask(task : Task) {
        print("Will now save task \(task)")
        //self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(task.taskID.uuidString).setValue(task.jsonFormat)
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("Tasks").child(task.taskID.uuidString).setValue(["taskDetails" : task.jsonFormat])
    }
    
    func saveUserInfo(userInfo : UserInfo) {
        //UserInfo : UserID -
            //  -> user Name
            //  -> user Display Name
            //  -> user email ID
            //  -> user Phone
        self.ref.child("Users").child((AuthHandler.shared.userInfo?.userID)!).child("UserInfo").child("UserDetails").setValue(["UserInfo" : userInfo.jsonFormat])
    }
    
    
    
}


extension Task{
    var jsonFormat : String {
        
        var tempDict = [String : Any?]()
        tempDict["taskID"] = taskID.uuidString
        tempDict["taskName"] = taskName
        tempDict["timer"] = "ERROR >>> WE NEED TO SAVE THE TIMER HERE"
        tempDict["taskType"] = taskStatus.rawValue
        tempDict["taskStatus"] = taskStatus.rawValue
        tempDict["isPerfectTask"] = false
        tempDict["pauseList"] = pauseList
        
        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal!
    }
}

extension Pause{
    
    var jsonFormat : String {
        var tempDict = [String : Any?]()
        tempDict["startTime"] = startTime
        tempDict["endTime"] = startTime
        tempDict["reason"] = reason
        
        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal!
    }
    
}

extension PauseCollection{
    
    var jsonFormat : String{
        
        var tempDict = [String : Any?]()
        
        var tempArray = [Any]()
        
        for eachPause in pauses{
            tempArray.append(eachPause)
        }
        
        tempDict["pauses"] = tempArray
        
        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal!
    }
}


extension UserInfo{
    var jsonFormat : String{
        
        var tempDict = [String : Any?]()
        
        tempDict["userID"] = userID
        tempDict["isAnonymous"] = isAnonymous
        tempDict["userName"] = userName
        tempDict["displayName"] = displayName
        tempDict["email"] = email
        tempDict["phone"] = phone
        
        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal!
    }
    
}


extension Timer{
    
}
