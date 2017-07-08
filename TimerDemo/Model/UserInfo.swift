//
//  UserInfo.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct UserInfo {
    let userID : String
    let isAnonymous : Bool
    let userName : String
    let displayName : String
    let email : String
    let phone : String
    var recentUsedTaskColl : [String]       //TaskCollection used most recently (Keep only top 3)
    let mostUsedTaskColl : [String]         //TaskCollection listed in the order of nubmer of sessions.
    
    func addTaskCollToRecent(taskCollName : String) -> UserInfo {
        var tempUserInfo = self
        
        if recentUsedTaskColl.contains(taskCollName){
            //Simply rearrage the items in recent Tasks.
            
            if let itemIndex = recentUsedTaskColl.index(of: taskCollName){
                tempUserInfo.recentUsedTaskColl.remove(at: itemIndex)
                tempUserInfo.recentUsedTaskColl.insert(taskCollName, at: 0)
                return tempUserInfo
            }
        }
        
        tempUserInfo.recentUsedTaskColl.insert(taskCollName, at: 0)
        return tempUserInfo
    }
    
    func fetchMostRecentUsedTaskColl(limit : Int = 3) -> [String] {
        if recentUsedTaskColl.isEmpty {return []}
        if recentUsedTaskColl.count <= limit {return recentUsedTaskColl}
        if recentUsedTaskColl.count > limit {return Array(recentUsedTaskColl.prefix(limit))}
        
        return []
    }
    
}


extension UserInfo{
    
    init?(firebaseDict : [String:Any?]) {
        guard let validUserID = firebaseDict["userID"] as? String else { return nil }
        guard let validIsAnonymous = firebaseDict["isAnonymous"] as? Bool else { return nil }
        guard let validUserName = firebaseDict["userName"] as? String else { return nil }
        guard let validDisplayName = firebaseDict["displayName"] as? String  else { return nil }
        guard let validEmail = firebaseDict["email"] as? String  else { return nil }
        guard let validPhone = firebaseDict["phone"] as? String  else { return nil }
        let validRecentUsedTaskColl = firebaseDict["recentUsedTaskColl"] as? [String] ?? []
        let validMostUsedTaskColl = firebaseDict["mostUsedTaskColl"] as? [String] ?? []
        
        userID = validUserID
        isAnonymous = validIsAnonymous
        userName = validUserName
        displayName = validDisplayName
        email = validEmail
        phone = validPhone
        recentUsedTaskColl = validRecentUsedTaskColl
        mostUsedTaskColl = validMostUsedTaskColl
        
    }
    
    
    var dictFormat : [String : Any?]{
        
        var tempDict = [String : Any?]()
        
        tempDict["userID"] = userID
        tempDict["isAnonymous"] = isAnonymous
        tempDict["userName"] = userName
        tempDict["displayName"] = displayName
        tempDict["email"] = email
        tempDict["phone"] = phone
        tempDict["recentUsedTaskColl"] = recentUsedTaskColl
        tempDict["mostUsedTaskColl"] = mostUsedTaskColl
        
        return tempDict
    }
    
    var jsonFormat : String{
        let tempDict = dictFormat
        
        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal!
    }
    
}
