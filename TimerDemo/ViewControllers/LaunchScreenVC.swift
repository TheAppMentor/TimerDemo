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
                print("Launching this screen .... ")
                OnlinePreferenceHandler.shared.populateAllPreferences {
                    print("Going to Segue TO Main Screen....")
                    // Go to Main screen along with login
                    self.performSegue(withIdentifier: "launchReady", sender: self)
                }
            }else{
                // Login in both anoynymous and WIth Credentials has failed.
                assertionFailure("Login with both Credetinals and Anonymous has failed.")
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("Now I am preparing for the segue.")
    }
    
}
