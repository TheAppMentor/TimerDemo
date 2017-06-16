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

class MainTimerScreenVC: UIViewController, TaskHandlerDelegate {
    
    //MARK: GLobal Variables
    let taskBoy = TaskHandler.shared
    
    //MARK: Oulets Story Board
    @IBOutlet weak var timerDisplayView: TimerView!
    @IBOutlet weak var timerControlButton: RoundedButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Computed Properties
    //TODO: Find a better place to store this.
    var lastUsedTaskCollection : TaskCollection? {
        return UserDefaults.standard.object(forKey: "lastUsedTaskCollection") as? TaskCollection ?? nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lastUsedTaskColl = lastUsedTaskCollection{
            taskBoy.createTask(name: lastUsedTaskColl.taskCollectionName, type: .deepFocus)
        }else{
            taskBoy.createTask(name: "Default", type: .deepFocus)
        }
        taskBoy.delegate = self
        
        //Show Play Pause Button
        timerControlButton.setPaused(false, animated: false)
        
        cancelButton.isEnabled = false
        cancelButton.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        timerDisplayView.theArcProgressView.timerDuration = (taskBoy.currentTask?.taskDuration)!
        
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

