//
//  AuthHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/19/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import FirebaseAuth


struct UserInfo {
    let userID : String
    let isAnonymous : Bool
    let userName : String
    let displayName : String
    let email : String
    let phone : String
}

class AuthHandler {
    
    var isLoggedIn = false
    var userInfo : UserInfo?
    
    
    static let shared = AuthHandler()
    private init() {}
    
    func authenticateUser(completionHandler : @escaping ((_ success : Bool, _ userInfo : UserInfo?)->())){
        
        // Fetched Saved User Name and password from keychain.
        //TODO: Prashanth, this where the code to login with facebook google etc goes.....
        
        // If Not found, Login the user anonymously.
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil{
                completionHandler(false, nil)
                print("We Have an error trying to login the user anonlymously... Aborting.")
                assertionFailure("We need to handle this error Gracefully Prashanth : Use the local database... soemthing... ")
            }
            
            if user != nil{
                self.isLoggedIn = true
                self.userInfo = UserInfo(userID: user!.uid, isAnonymous : true, userName: "", displayName: "", email: "", phone: "")
                self.isLoggedIn = true
                completionHandler(true, self.userInfo)

            }
            
            
        }
    }
    
    
}
