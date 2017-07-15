//
//  AddTaskVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/11/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

protocol TaskAddEventHandlerDelegate {
    func newTaskAddedWithName(taskName : String)
}

class AddTaskVC: UIViewController {
    
    var taskAddVCEventHandlerDelegate : TaskAddEventHandlerDelegate?
    
    @IBOutlet weak var addTaskPopUpContainerView: UIView!
    @IBOutlet weak var addTaskDoneButton: UIButton!
    @IBOutlet weak var headerBanner: UIView!
    @IBOutlet weak var taskTitleInputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        taskTitleInputTextField.becomeFirstResponder()
        
        addTaskPopUpContainerView.layer.cornerRadius = 10.0
        addTaskPopUpContainerView.clipsToBounds = true
        
        headerBanner.layer.shadowOffset = CGSize(width: 0, height: 1)
        headerBanner.layer.masksToBounds = false
        headerBanner.layer.shadowRadius = 1.0
        headerBanner.layer.shadowOpacity = 0.5
        
        addTaskDoneButton.layer.cornerRadius = 5.0
        addTaskDoneButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addTaskDoneButton.layer.masksToBounds = false
        addTaskDoneButton.layer.shadowRadius = 2.0
        addTaskDoneButton.layer.shadowOpacity = 0.5
    }

    
    @IBAction func doneTaskComplete(_ sender: UIButton) {
        
        //TODO : Check for duplicate task name here... 
        let valueEntered = taskTitleInputTextField.text
        guard valueEntered?.isEmpty != true else {assertionFailure("Handle Emtpy Task Name Condition"); return}
        let taskCollection = TaskCollection.init(taskName: valueEntered!)
        //let newTaskColl = taskCollection.addTaskID(taskID: "Some Task 1")
        PersistenceHandler.shared.saveTaskCollection(taskColl: taskCollection)
        taskAddVCEventHandlerDelegate?.newTaskAddedWithName(taskName: valueEntered!)
        dismissScreen()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismissScreen()
    }
        
    func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
    

}
