//
//  AuthHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/19/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import FirebaseAuth
import KeychainSwift

class AuthHandler {
    
    var isLoggedIn = false
    var userInfo: UserInfo?
    
    static let shared = AuthHandler()
    private init() {}
    
    func authenticateUser(completionHandler : @escaping ((_ success: Bool, _ userInfo: UserInfo?)->Void)) {
        
        let theKeyChain = KeychainSwift()
        
        if let theLoggedInUser = theKeyChain.get("userCredentials") {
            loginUserWithCredentials(userName: theLoggedInUser, password: theLoggedInUser)
            print("We dont have a logged in user \(theLoggedInUser)")
            
        } else { // User has not logged in before this.
            print("user is now logged in anonymously")
            loginUserAnonymously(completionHandler: completionHandler)
        }
        
        // Fetched Saved User Name and password from keychain.
        //TODO: Prashanth, this where the code to login with facebook google etc goes.....
        
    }
    
    
    func loginUserWithGoogleSignIn() {
        //Auth.auth().signIn(with: <#T##AuthCredential#>, completion: <#T##AuthResultCallback?##AuthResultCallback?##(User?, Error?) -> Void#>)
    }
    
    
    private func loginUserWithCredentials(userName: String, password: String) {
        Auth.auth().signIn(withEmail: userName, password: password) { (user, error) in
            if error != nil {
                print("We failed to login the user with credentials")
            }
            
            if user != nil {
                print("We Were able to loign")
            }
        }
    }
    
    private func loginUserAnonymously(completionHandler : @escaping ((_ success: Bool, _ userInfo: UserInfo?)->Void)) {
        // If Not found, Login the user anonymously.
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil {
                completionHandler(false, nil)
                print("We Have an error trying to login the user anonlymously... Aborting.")
                assertionFailure("We need to handle this error Gracefully Prashanth : Use the local database... soemthing... ")
            }
            
            if user != nil {
                self.isLoggedIn = true
                self.userInfo = UserInfo(userID: user!.uid, isAnonymous: true, userName: "", displayName: "", email: "", phone: "", recentUsedTaskColl: [], mostUsedTaskColl: [])
                self.isLoggedIn = true
                completionHandler(true, self.userInfo)
            }
        }
        
    }
    
    func loginUserGoogleSignin(credential : AuthCredential, completionHandler : @escaping ((_ success: Bool, _ userInfo: UserInfo?)->Void)){
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            completionHandler(true, self.userInfo)
        }
    }
}


