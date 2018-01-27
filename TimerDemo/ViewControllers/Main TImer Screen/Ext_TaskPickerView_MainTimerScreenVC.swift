//
//  Ext_TaskPickerView_MainTimerScreenVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/5/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import UIKit
import AKPickerView_Swift

extension MainTimerScreenVC: AKPickerViewDelegate, AKPickerViewDataSource, TaskPickerScrollViewDelegate {

    internal func setupTaskPickerView() {
        self.taskPickerScrollView.frame = CGRect(x: 0, y: 20.0, width: self.view.bounds.width, height: 85.0)
        self.taskPickerScrollView.delegate = self
        self.view.addSubview(self.taskPickerScrollView)

        self.taskPickerView = self.taskPickerScrollView.thePickerView
        //taskPickerView.frame = CGRect(x: 0, y: 20.0, width: view.bounds.width * 0.7, height: 100)
        self.taskPickerView.center = CGPoint(x: self.view.center.x, y: self.taskPickerView.center.y)
        self.taskPickerView.backgroundColor = UIColor.clear

        // Setup the Horizontal Scroll Task Picker View
        self.taskPickerView.textColor = UIColor.lightGray
        self.taskPickerView.font = Utilities.shared.veryLargeFontSize
        self.taskPickerView.pickerViewStyle = .wheel
        self.taskPickerView.interitemSpacing = self.taskPickerView.frame.width/6.0
        self.taskPickerView.highlightedTextColor = UIColor.white
        self.taskPickerView.highlightedFont = Utilities.shared.veryLargeFontSize
    }

    // MARK: TaskPickerScrollViewDelegate
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        if !self.allTaskColl.isEmpty {
            setupTimerForNewTaskPicked(taskName: self.allTaskColl[item].taskName)
        }
    }

    func taskPicked(index: Int) {
        print("OK.. Some Task got picked \(index)")
    }
}
