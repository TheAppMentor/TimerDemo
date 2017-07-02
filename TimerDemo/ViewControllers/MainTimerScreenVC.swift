//
//  ViewController.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import RSPlayPauseButton
import SCLAlertView

class MainTimerScreenVC: UIViewController, TaskHandlerDelegate,InfoAlertEventHandler {
    
    //MARK: GLobal Variables
    let taskBoy = TaskHandler.shared
    
    //MARK: Oulets Story Board
    @IBOutlet weak var timerDisplayView: TimerView!
    @IBOutlet weak var timerControlButton: RoundedButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var timerContainerView: TimerContainerView!
    
    //MARK: Computed Properties
    //TODO: Find a better place to store this.
    var lastUsedTaskCollection : TaskCollection? {
        return UserDefaults.standard.object(forKey: "lastUsedTaskCollection") as? TaskCollection ?? nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        makeNavBarTransparent()
        hideBackButton()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
         navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : Utilities.shared.largeFontSize, NSForegroundColorAttributeName : UIColor.white]
        // navigationController?.navigationBar.setTitleVerticalPositionAdjustment(15.0, for: .default)
        
        createADeepWorkTask()
        setupUIForTaskBegin()
    }
    
    func makeNavBarTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func hideBackButton() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func createADeepWorkTask(){
        if let lastUsedTaskColl = lastUsedTaskCollection{
            taskBoy.createTask(name: lastUsedTaskColl.taskName, type: .deepFocus)
        }else{
            taskBoy.createTask(name: "Default", type: .deepFocus)
        }
    }
    
    func setupUIForTaskBegin() {
        taskBoy.delegate = self
        
        // Setup Cancel Button
        cancelButton.isEnabled = false
        cancelButton.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        // Setup Cancel
        
        cancelButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        cancelButton.layer.masksToBounds = false
        cancelButton.layer.shadowRadius = 2.0
        cancelButton.layer.shadowOpacity = 0.5
        
        timerDisplayView.theArcProgressView.timerDuration = (taskBoy.currentTask?.taskDuration)!
        
        //Set Background color of the timer container view.
        timerContainerView.timerMode = (taskBoy.currentTask?.taskType)!
        
        timerControlButton.setPaused(true, animated: false)
    }
    
    
    
    func showCancelButton() {
        
        let showCancelAnim = CABasicAnimation(keyPath: "transform.scale")
        showCancelAnim.fromValue = 0.0
        showCancelAnim.toValue = 1.0
        showCancelAnim.duration = 0.5
        showCancelAnim.autoreverses = false
        showCancelAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        cancelButton.layer.add(showCancelAnim, forKey: "showCanelButton")
    }

    
    
    //MARK: StoryBoard Actions
    
    @IBAction func timerContolPressed(_ sender: RoundedButton) {
        
        switch taskBoy.currentTask!.taskStatus {
            
        case .notStarted: startCurrentTask()
        case .running   : pauseCurrentTask()
        case .paused    : resumeCurrentTask()
        default         : print("Task Status Unknown.")
        }
    }
    
    
    
    
    //MARK: User Interactions
    
    @IBAction func cancelButton(_ sender: UIButton) {
        pauseCurrentTask()
    }
    
    @IBAction func userWantsToLogin(_ sender: UIBarButtonItem) {
        // Here we either take him to the login screen or user profile screen. (If he has already logged in).
        performSegue(withIdentifier: "showSignInScreen", sender: self)
    }
    
    func startCurrentTask() {
        taskBoy.startCurrentTask()
        showCancelButton()
        timerDisplayView.theArcProgressView.animateProgressBar()
        view.setNeedsDisplay()
        timerControlButton.setPaused(false, animated: true)
        cancelButton.isEnabled = true
    }
    
    func pauseCurrentTask() {
        taskBoy.pauseCurrentTask()
        timerControlButton.setPaused(true, animated: true)
    }
    
    func resumeCurrentTask() {
        taskBoy.resumeCurrentTask()
        timerControlButton.setPaused(false, animated: true)
    }
    
    func abandonCurrentTask() {
        taskBoy.abandonCurrentTask()
    }
    
    
    
    //MARK: Info Pop Up Window Event Handler Delegate.
    
    func userOptedToTakeShortBreak(){
        
       taskBoy.createTask(name: "shortBreak", type: .shortBreak)
        timerContainerView.timerMode = .shortBreak
        // Setup View for a Short break.
        setupUIForTaskBegin()
    }
    
    func userOptedToTakeLongBreak() {
        print("Setting UP a long break")
        taskBoy.createTask(name: "longBreak", type: .longBreak)
        timerContainerView.timerMode = .longBreak
        // Setup View for a Short break.
        setupUIForTaskBegin()
    }
    
    func userOptedToContinueWorking(){
        createADeepWorkTask()
        setupUIForTaskBegin()
    }
    
    func userOptedToAbandonTask(){
//        createADeepWorkTask()
//        setupUIForTaskBegin()
        abandonCurrentTask()
        
//        taskBoy.abandonCurrentTask()
//
//        taskBoy.createTask(name: "shortBreak", type: .shortBreak)
//        timerContainerView.timerMode = .shortBreak
//        // Setup View for a Short break.
//        setupUIForTaskBegin()
        
        
//        taskBoy.abandonCurrentTask()
        
    }
    
    func userDoesNotWantToAbandonCurrentTask(){
        resumeCurrentTask()
    }
    
    
    
    
    
    
    
    
    
    //MARK : Current Task Delegate Methods
    
    func timerDidChangeValue(seconds: CFTimeInterval) {
        if seconds > 0 {
            timerDisplayView.theArcProgressView.timerLabel.text = Utilities.shared.convertTimeIntervalToDisplayFormat(seconds: seconds)
        }else{
            timerDisplayView.theArcProgressView.timerLabel.text = "Done"
        }
    }
    
    func currentDidPause() {
        timerDisplayView.theArcProgressView.pauseAnimation()
        timerControlButton.setPaused(true, animated: false)
        InfoAlertView(actionDelegate: self).showAlertForTaskAbandoned()
    }
    
    func currentTaskDidResume(){
        timerDisplayView.theArcProgressView.resumeAnimation()
    }
    
    func currentTaskDidAbandon() {
        // Short Break seems to work..
        timerDisplayView.theArcProgressView.resetLayerToFullPosition()
        
        createADeepWorkTask()
        setupUIForTaskBegin()
    }
    
    func currentTaskDidComplete() {
        print("Got Notificaiton .. current task completed.")
        timerDisplayView.theArcProgressView.timerLabel.text = "DONE"
        
        // Set screen again with same type as the task just complete. This is to handle the case, if he cancels from the Pop up.
        createADeepWorkTask()
        setupUIForTaskBegin()
        
        // Change Task to Break
        // Show Pop up, asking if he wants a break or wants to continue.
        // Pop up should also show summary or progress.
        //SCLAlertView().showInfo("Important info", subTitle: "You are great")
        
        switch (taskBoy.currentTask?.taskType)! {
        case .deepFocus:    InfoAlertView(actionDelegate: self).showAlertForTaskComplete()
        case .shortBreak:   InfoAlertView(actionDelegate: self).showAlertForShortBreakComplete()
        case .longBreak:    InfoAlertView(actionDelegate: self).showAlertForLongBreakComplete()
        }
        
        timerControlButton.setPaused(false, animated: true)
        
        // Vibrate the Phone.
        //if SettingsHandler.shared.isVibrateOn.currentValue == "ON"{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//            AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
//            AudioServicesPlaySystemSound(1520) // Actuate `Pop` feedback (strong boom)
//            AudioServicesPlaySystemSound(1521) // Actuate `Nope` feedback (series of three weak booms)
            
        //}
        
        //Find the alert tone and play it
       // if SettingsHandler.shared.taskDidCompleteSound == "someSOund"{
            AudioServicesPlaySystemSound(1054);
       // }
        
    }
    
    @IBAction func showTaskList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showTaskList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let theDestVC = segue.destination as? TaskPickerTVC{
            //theDestVC.allTasks = ["Task Name"]
        }
    }
    
    
    
}


