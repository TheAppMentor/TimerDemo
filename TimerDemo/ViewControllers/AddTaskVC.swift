//
//  AddTaskVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/11/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class AddTaskVC: UIViewController {
    
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTaskComplete(_ sender: UIButton) {
        dismissScreen()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismissScreen()
    }
    
    func dismissScreen() {
        dismiss(animated: true, completion: nil)
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
