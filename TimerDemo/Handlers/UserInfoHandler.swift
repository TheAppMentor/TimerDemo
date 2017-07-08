//
//  UserInfoHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

class UserInfoHandler {
    static let shared = UserInfoHandler()
    
    private var _currentUserInfo : UserInfo?
    
    private init() {
    }
    
    func populateUserInfo(completionHanlder : @escaping ()->()) {
        PersistenceHandler.shared.fetchUserInfo(completionHandler: { (theUserInfo) in
            self._currentUserInfo = theUserInfo
            completionHanlder()
        })
    }
    
    var currentUserInfo : UserInfo{
        return _currentUserInfo!
    }
    
    func addTaskCollToRecent(taskCollName : String) {
        _currentUserInfo = _currentUserInfo?.addTaskCollToRecent(taskCollName: taskCollName)
        PersistenceHandler.shared.saveUserInfo(userInfo: _currentUserInfo!)
    }
    
    func fetchMostRecentUsedTaskColl(limit : Int = 3) -> [String] {
        return _currentUserInfo?.fetchMostRecentUsedTaskColl(limit: limit) ?? []
    }
    
}
