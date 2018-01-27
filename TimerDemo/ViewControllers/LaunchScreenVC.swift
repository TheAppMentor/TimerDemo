//
//  LaunchScreenVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/30/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
import UserNotifications

class LaunchScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showMainAppScreen), name: NSNotification.Name(rawValue: "showNewTaskAddScreen"), object: self)
    }

    override func viewDidAppear(_ animated: Bool) {

        // Override point for customization.. after application launch.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Ok... We have authorization man...")
            }

            //Wait for the user to respond to the alert notificaiton and then proceed.
            self.startAuthenticationProcess()
            // Enable or disable features based on authorization.
        }
    }

    func startAuthenticationProcess() {
        AuthHandler.shared.authenticateUser(completionHandler: { (isLoginSuccessful, theLoggedInUserInfo) in
            if isLoginSuccessful == true {
                // The login in can be Anonymous or With Valid credentials.

                OnlinePreferenceHandler.shared.populateAllPreferences {
                    UserInfoHandler.shared.populateUserInfo {
                        // For Very first launch, show the onboarding screen
                        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                        if launchedBefore {
                            // User has already launched the app Go Directly to Home Screen.
                            // Go to Main screen along with login
                            self.showMainAppScreen()

                        } else {
                            //                            print("First launch, setting UserDefault.")
                            //                            UserDefaults.standard.set(true, forKey: "launchedBefore")
                            OnBoardingHandler(actionOnSkipOrComplete: {
                                self.showMainAppScreen()
                            }).showOnBoardingScreen()
                        }
                    }
                }
            } else {
                // Login in both anoynymous and WIth Credentials has failed.
                assertionFailure("Login with both Credetinals and Anonymous has failed.")
            }
        })

    }

    @objc func showMainAppScreen() {
        print("Login VC : Onboarding Complete : Will now show")
        self.performSegue(withIdentifier: "launchReady", sender: self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
