//
//  LoginVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/19/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginVC: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            AuthHandler.shared.loginUserGoogleSignin(credential: credential, completionHandler: { (isLoginSuccessful, userInfo) in
                if isLoginSuccessful == true {
                    // The login in can be Anonymous or With Valid credentials.
                    OnlinePreferenceHandler.shared.populateAllPreferences {
                        UserInfoHandler.shared.populateUserInfo {
                            // For Very first launch, show the onboarding screen
                            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                            if launchedBefore {
                                // User has already launched the app Go Directly to Home Screen.
                                // Go to Main screen along with login
                                self.dismiss(animated: true, completion: nil)
                                
                            } else {
                                //                            print("First launch, setting UserDefault.")
                                //                            UserDefaults.standard.set(true, forKey: "launchedBefore")
                                OnBoardingHandler(actionOnSkipOrComplete: {
                                    self.dismiss(animated: true, completion: nil)
                                }).showOnBoardingScreen()
                            }
                        }
                    }
                } else {
                    // Login in both anoynymous and WIth Credentials has failed.
                    assertionFailure("Login with both Credetinals and Anonymous has failed.")
                }
            })
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Uncomment to automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        //GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
        
        

        // Do any additional setup after loading the view.

//        AuthHandler.shared.authenticateUser { (success, userInfo) in
//            if success == true{
//                // Present the first screen
//                print("\n\n the User infor is ... \(userInfo) \n\n\n")
//                self.performSegue(withIdentifier: "loginSuccess", sender: self)
//            }
//
//            if success == false{
//                print("We Could not login the user, get him to login again....")
//            }
//        }

    }
    
    var googleSignInButton : GIDSignInButton!
    
    override func viewWillAppear(_ animated: Bool) {
        googleSignInButton = GIDSignInButton.init(frame: CGRect(x: 150, y: 150, width: 250, height: 100))
        view.addSubview(googleSignInButton)
    }

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
