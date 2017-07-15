//
//  LaunchScreenVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/30/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class LaunchScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        AuthHandler.shared.authenticateUser(completionHandler: { (isLoginSuccessful, theLoggedInUserInfo) in
            if isLoginSuccessful == true{
                // The login in can be Anonymous or With Valid credentials.
                
                OnlinePreferenceHandler.shared.populateAllPreferences {
                    UserInfoHandler.shared.populateUserInfo {
                        // Go to Main screen along with login
                        self.performSegue(withIdentifier: "launchReady", sender: self)
                    }
                }
            }else{
                // Login in both anoynymous and WIth Credentials has failed.
                assertionFailure("Login with both Credetinals and Anonymous has failed.")
            }
        })
    }
}
