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
import AKPickerView_Swift
import GoogleMobileAds

class MainTimerScreenVC: UIViewController, TaskHandlerDelegate, InfoAlertEventHandler, TaskPickerTVCEventHandlerDelegate, GADBannerViewDelegate, PreferenceEventHandlerDelegate {
    
    var logr : LoggingHandler{
        return LoggingHandler.shared
    }
    
    @IBAction func showSettings(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSettingsScreen", sender: self)
        logr.logAnalyticsEvent(analyticsEvent: .navigatedToSettingsScreen)
    }
    
    @IBAction func showAnalyzeScreen(_sender : UIBarButtonItem){
        performSegue(withIdentifier: "showAnalyzeScreen", sender: self)
        logr.logAnalyticsEvent(analyticsEvent: .navigatedToAnalyzeScreen)
    }
    
    func userChangePerference(newPreference: Preference) {
        if newPreference.name == "taskDurationMinutes"{
            createADeepWorkTask()
            setupUIForTaskBegin()
            setupTaskPickerView()
        }
    }
    
    @IBAction func runTestTask(_ sender: UIBarButtonItem) {
        TestTaskGenerator.shared.saveTestTask()
    }
    
    @IBAction func addTaskButtonPressedFromToolBar(_ sender: UIBarButtonItem) {
        self.addNewTaskClicked()
    }
    
    @IBOutlet weak var adBannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    
    // MARK: GLobal Variables
    let taskBoy = TaskManager.shared
    
    var taskPickerView: AKPickerView!
    var taskPickerScrollView: TaskPickerScrollView = TaskPickerScrollView()
    
    @IBOutlet weak var miniVizContainerView: UIView!
    var miniVizContainerVC: VizDetailsPageVC?
    
    var allTaskColl = [TaskCollection]()
    
    // MARK: Oulets Story Board
    @IBOutlet weak var timerDisplayView: TimerView!
    @IBOutlet weak var timerControlButton: RoundedButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var timerContainerView: TimerContainerView!
    
    // MARK: Computed Properties
    //TODO: Find a better place to store this.
    var userSelectedTaskColl: String? {
        return UserDefaults.standard.object(forKey: "userSelectedTaskColl") as? String ?? nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //makeNavBarTransparent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        hideBackButton()
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : Utilities.shared.fontWithLargeSize, NSAttributedStringKey.foregroundColor : UIColor.white]
        
        //Setup Ad Banner.
        bannerView.adUnitID = "ca-app-pub-5666511173297473/2835254941"  //Prashanths Real ID
        GADRequest().testDevices = ["2c8b33977e2ef1dc288ec90df9f4f197"]
        bannerView.rootViewController = self
        
        //bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.delegate = self
        adBannerHeightConstraint.constant = 0
        
        createADeepWorkTask()
        setupUIForTaskBegin()
        setupTaskPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.bringSubview(toFront: taskPickerView)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            performSegue(withIdentifier: "addNewTask", sender: self)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: parashat we need to remove this, we cannot reload all the task coll each tiem the view appears.
        // WE should only reload when a new task is added.. set up a delegate and do this.
        populateAllTaskCollNames()

    }
    
    
    func setupTimerForNewTaskPicked(taskName: String) {
        
        if taskName == "Break"{
            createAShortBreakTask()
        } else {
            UserDefaults.standard.set(taskName, forKey: "userSelectedTaskColl")
            
            if UserDefaults.standard.synchronize() {
                createADeepWorkTask()
            }
        }
        
        setupUIForTaskBegin()
    }
    
    // eventHandlerDelegate
    
    func userPickedATaskWithName(name: String) {
        setupTimerForNewTaskPicked(taskName: name)
        
        if let selectedIndex = findIndexForTaskName(taskName: name) {
            taskPickerView.selectItem(selectedIndex, animated: true)
        }
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return allTaskColl.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return allTaskColl[item].taskName
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
    
    func createADeepWorkTask() {
        if let lastUsedTaskColl = userSelectedTaskColl {
            taskBoy.createTask(name: lastUsedTaskColl, type: .deepFocus)
        } else {
            let taskName = UserInfoHandler.shared.fetchMostRecentUsedTaskColl(limit: 1).first ?? ""
            taskBoy.createTask(name: taskName, type: .deepFocus)
            UserDefaults.standard.set(taskName, forKey: "userSelectedTaskColl")
        }
    }
    
    func createAShortBreakTask() {
        taskBoy.createTask(name: "Break", type: .shortBreak)
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
    
    //: Fetch all Task Coll Names
    func populateAllTaskCollNames() {
        
        PersistenceHandler.shared.fetchAllTaskCollections { (taskCollArr) in
            self.allTaskColl = taskCollArr
            
            self.taskPickerView.delegate = self
            self.taskPickerView.dataSource = self
            
            self.taskPickerView.reloadData()
            
            if !self.allTaskColl.isEmpty {
                if let taskToSelect = UserDefaults.standard.object(forKey: "userSelectedTaskColl") as? String {

                    if let taskIndex = self.findIndexForTaskName(taskName: taskToSelect) {
                        self.taskPickerView.selectItem(taskIndex, animated: true)
                    }
                }
            }
        }
    }
    
    func findIndexForTaskName(taskName: String) -> Int? {
        for eachTask in self.allTaskColl.enumerated() {
            if (eachTask.element.taskName == taskName) {
                return eachTask.offset
            }
        }
        return nil
    }
    
    // MARK: StoryBoard Actions
    
    @IBAction func timerContolPressed(_ sender: RoundedButton) {
        
        switch taskBoy.currentTask!.taskStatus {
            
        case .notStarted: startCurrentTask()
        case .running   : pauseCurrentTask()
        case .paused    : resumeCurrentTask()
        default         : print("Task Status Unknown.")
        }
    }
    
    // MARK: User Interactions
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        pauseCurrentTask()
    }
    
    @IBAction func userWantsToLogin(_ sender: UIBarButtonItem) {
        // Here we either take him to the login screen or user profile screen. (If he has already logged in).
        performSegue(withIdentifier: "showSignInScreen", sender: self)
    }
    
    func userWantsToViewMoretasks() {
        performSegue(withIdentifier: "showTaskList", sender: self)
    }
    
    func startCurrentTask() {
        showADBanner()
        bannerView.load(GADRequest())
        
        taskBoy.startCurrentTask()
        showCancelButton()
        //timerDisplayView.theArcProgressView.animateProgressBar()
        timerDisplayView.theArcProgressView.resumeAnimationFromStart()
        view.setNeedsDisplay()
        timerControlButton.setPaused(false, animated: true)
        cancelButton.isEnabled = true
    }
    
    func pauseCurrentTask() {
        hideADBanner()
        taskBoy.pauseCurrentTask()
        timerControlButton.setPaused(true, animated: true)
    }
    
    func resumeCurrentTask() {
        showADBanner()
        taskBoy.resumeCurrentTask()
        timerControlButton.setPaused(false, animated: true)
    }
    
    func abandonCurrentTask() {
        hideADBanner()
        taskBoy.abandonCurrentTask()
    }
    
    // MARK: Info Pop Up Window Event Handler Delegate.
    
    func userOptedToTakeShortBreak() {
        createAShortBreakTask()
        //        taskBoy.createTask(name: "Break", type: .shortBreak)
        //        //timerContainerView.timerMode = .shortBreak
        
        if let selectedIndex = findIndexForTaskName(taskName: "Break") {
            taskPickerView.selectItem(selectedIndex, animated: true)
        }
        
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
    
    func userOptedToContinueWorking() {
        createADeepWorkTask()
        setupUIForTaskBegin()
    }
    
    func userOptedToAbandonTask() {
        abandonCurrentTask()
    }
    
    func userDoesNotWantToAbandonCurrentTask() {
        resumeCurrentTask()
    }
    
    //MARK : Current Task Delegate Methods
    
    func timerDidChangeValue(seconds: CFTimeInterval) {
        if seconds > 0 {
            timerDisplayView.theArcProgressView.timerLabel.text = Utilities.shared.convertTimeIntervalToDisplayFormat(seconds: seconds)
        } else {
            timerDisplayView.theArcProgressView.timerLabel.text = "Done"
        }
    }
    
    func currentDidPause() {
        timerDisplayView.theArcProgressView.pauseAnimation()
        timerControlButton.setPaused(true, animated: false)
        //InfoAlertView(actionDelegate: self).showAlertForTaskPaused()
        let timerDurationString = Utilities.shared.convertTimeIntervalToDisplayFormat(seconds: taskBoy.currentTask?.timeRemaining ?? 0)
        InfoAlertView(actionDelegate: self).showAlertForTaskPausedAbandoned(durationString: timerDurationString)
    }
    
    func currentTaskDidUnFreeze(timeRemaining: TimeInterval) {
        timerDisplayView.theArcProgressView.resumeAnimationWithTimeRemaining(timeRemaining: timeRemaining)
    }
    
    func currentTaskDidFreeze() {
        timerDisplayView.theArcProgressView.pauseAnimation()
    }
    
    func currentTaskDidResume() {
        timerDisplayView.theArcProgressView.resumeAnimation()
    }
    
    func currentTaskDidAbandon() {
        // Short Break seems to work..
        timerDisplayView.theArcProgressView.resetLayerToFullPosition()
        //timerDisplayView.theArcProgressView.resumeAnimationFromStart()
        
        createADeepWorkTask()
        setupUIForTaskBegin()
    }
    
    func currentTaskDidComplete() {
        timerControlButton.setPaused(true, animated: false)  // Hack to make the timer button set properly. Need to research why it behaves this way.
        timerControlButton.setPaused(false, animated: false)
        //Update the mini task list vc
        self.miniVizContainerVC?.reloadAllViews()
        switch (taskBoy.currentTask?.taskType)! {
        case .deepFocus:
            let timerDurationString = Utilities.shared.convertTimeIntervalToDisplayFormat(seconds: taskBoy.taskDuration)
            InfoAlertView(actionDelegate: self).showAlertForTaskComplete(durationString: timerDurationString)
        case .shortBreak:   InfoAlertView(actionDelegate: self).showAlertForShortBreakComplete()
        case .longBreak:    InfoAlertView(actionDelegate: self).showAlertForLongBreakComplete()
        }
        
        // Set screen again with same type as the task just complete. This is to handle the case, if he cancels from the Pop up.
        createADeepWorkTask()
        setupUIForTaskBegin()
        
        // Vibrate the Phone. If User requested
        AudioHandler.shared.vibrate()
        
        // Play Sound
        AudioHandler.shared.playAudioForEvent(taskType: (taskBoy.currentTask?.taskType)!)
        
        hideADBanner()
    }
    
    @IBAction func showTaskList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showTaskList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier ?? "" {
        case "addNewTask":
            if let theDestNavVC = segue.destination as? UINavigationController {
                if let theDestVC = theDestNavVC.viewControllers.first as? AddTaskVC{
                    theDestVC.taskAddVCEventHandlerDelegate = self
                    if !UserDefaults.standard.bool(forKey: "launchedBefore") {
                        theDestVC.hideCancelButton = true
                    }
                }
            }
            
        case "showTaskList":
            if let theDestVC = segue.destination as? UINavigationController {
                if let theTaskVC = theDestVC.viewControllers.first as? TaskPickerTVC {
                    theTaskVC.eventHandlerDelegate = self
                }
            }
            
        case "showMiniVC" :
            if let theDestVC = segue.destination as? VizDetailsPageVC {
                theDestVC.myContainerVC = self
                self.miniVizContainerVC = theDestVC
            }
            
        case "showSettingsScreen" :
            if let theDestVC = segue.destination as? UINavigationController {
                if let theSettingsVC = theDestVC.viewControllers.first as? SettingsTVC {
                    theSettingsVC.preferenceChangeEventHandler = self
                }
            }
            
        case "showAnalyzeScreen" :
            break
            
        default:
            break
        }
    }
}

// ========================================================= //
// MARK: Google Ads Processing.
// ========================================================= //

extension MainTimerScreenVC {
    
    func showADBanner() {
        adBannerHeightConstraint.constant = 50
        bannerView.layoutIfNeeded()
    }
    
    func hideADBanner() {
        adBannerHeightConstraint.constant = 0
        bannerView.layoutIfNeeded()
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        hideADBanner()
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
        taskBoy.currentTask?.pause()
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
        showADBanner()
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
        hideADBanner()
    }
}

// ========================================================= //
// MARK: New Task Add Processing.
// ========================================================= //

extension MainTimerScreenVC: TaskAddEventHandlerDelegate {
    
    func addNewTaskClicked() {
        performSegue(withIdentifier: "addNewTask", sender: self)
    }
    
    // Delegate Call Back.
    func newTaskAddedWithName(taskName: String) {
        UserDefaults.standard.set(taskName, forKey: "userSelectedTaskColl")
        //        if UserDefaults.standard.synchronize() == true{
        //            userPickedATaskWithName(name: taskName)
        //        }
    }
}
