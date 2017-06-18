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
        
        //makeNavBarTransparent()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : Utilities.shared.largeFontSize, NSForegroundColorAttributeName : UIColor.green]
        
        //self.navigationController?.navigationBar.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:80.0)
        
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(15.0, for: .default)
        
        createADeepWorkTask()
        setupUIForTaskBegin()
    }
    
    func makeNavBarTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func createADeepWorkTask(){
        if let lastUsedTaskColl = lastUsedTaskCollection{
            taskBoy.createTask(name: lastUsedTaskColl.taskCollectionName, type: .deepFocus)
        }else{
            taskBoy.createTask(name: "Default", type: .deepFocus)
        }
    }
    
    func setupUIForTaskBegin() {
        taskBoy.delegate = self
        
        cancelButton.isEnabled = false
        cancelButton.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        timerDisplayView.theArcProgressView.timerDuration = (taskBoy.currentTask?.taskDuration)!
        
        //Set Background color of the timer container view.
        timerContainerView.timerMode = (taskBoy.currentTask?.taskType)!
        
        timerControlButton.setPaused(true, animated: false)
    }
    
    
    
    func showCancelButton() {
        let showCancelAnim = CABasicAnimation(keyPath: "bounds")
        showCancelAnim.fromValue = CGRect(x: 0, y: 0, width: 0, height: 0)
        showCancelAnim.toValue = CGRect(x: 0, y: 0, width: 30, height: 30)
        showCancelAnim.duration = 1.0
        showCancelAnim.autoreverses = false
        showCancelAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        cancelButton.layer.add(showCancelAnim, forKey: "showCanelButton")
    }

    
    
    //MARK: StoryBoard Actions
    
    @IBAction func timerContolPressed(_ sender: RoundedButton) {
        
        switch taskBoy.currentTask!.taskStatus {
            
        case .notStarted:
            taskBoy.startCurrentTask()
            showCancelButton()
            timerDisplayView.theArcProgressView.animateProgressBar()
            timerControlButton.setPaused(false, animated: true)
            cancelButton.isEnabled = true
            
        case .running   :
            taskBoy.pauseCurrentTask()
            timerControlButton.setPaused(true, animated: true)
            
        case .paused    :
            taskBoy.resumeCurrentTask()
            timerControlButton.setPaused(false, animated: true)
            
        default         :    print("Task Status Unknown.")
        }
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        print("Cancel Pressed")
        InfoAlertView(actionDelegate: self).showAlertForTaskCancelled()

    }
    
    
    
    // Info Pop Up Window Event Handler Delegate.
    
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
    
    
    
    
    //MARK : Current Task Delegate Methods
    
    func timerValueChanged(seconds: CFTimeInterval) {
        if seconds > 0 {
            timerDisplayView.theArcProgressView.timerLabel.text = Utilities.shared.convertTimeIntervalToDisplayFormat(seconds: seconds)
        }else{
            timerDisplayView.theArcProgressView.timerLabel.text = "Done"
        }
    }
    
    func currentTaskPaused() {
        timerDisplayView.theArcProgressView.pauseAnimation()
        timerControlButton.setPaused(true, animated: false)
    }
    
    func currentTaskResumed(){
        timerDisplayView.theArcProgressView.resumeAnimation()
    }
    
    func currentTaskAbandoned() {
        print("CurentTask has been abandoned")
    }
    
    func currentTaskCompleted() {
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
        case .deepFocus:
            InfoAlertView(actionDelegate: self).showAlertForTaskComplete()
        case .shortBreak:
            InfoAlertView(actionDelegate: self).showAlertForShortBreakComplete()
        case .longBreak:
            InfoAlertView(actionDelegate: self).showAlertForLongBreakComplete()
        }
        
        InfoAlertView(actionDelegate: self).showAlertForTaskComplete()
        
        
        timerControlButton.setPaused(false, animated: true)
        
        // Vibrate the Phone.
        //if SettingsHandler.shared.isVibrateOn.currentValue == "ON"{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//            AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
//            AudioServicesPlaySystemSound(1520) // Actuate `Pop` feedback (strong boom)
//            AudioServicesPlaySystemSound(1521) // Actuate `Nope` feedback (series of three weak booms)
            
        //}
        
        //Find the alert tone and play it
       // if SettingsHandler.shared.taskCompletedSound == "someSOund"{
            AudioServicesPlaySystemSound(1054);
        
       // }
        
    }
}

class CustomNavigationBar: UINavigationBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize :CGSize = CGSize(width: self.frame.size.width, height: 88)
        return newSize
    }
}

