//
//  PickerVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/10/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

protocol PickerSelectionDelegate {
    func userSelectedValue(index: Int)
}

class PickerVC: UIViewController, SettingsPickerViewDelegate {

    var pickerViewData: SettingsPickerViewData?
    var pickerSelectionDelegate: PickerSelectionDelegate?

    @IBOutlet weak var thePickerView: SettingsPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        thePickerView.pickerViewData = pickerViewData
        thePickerView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        thePickerView.scrollToSelectedRow()
    }

    func settingsPickerViewCancelPressed() {
        dismiss(animated: true, completion: nil)
    }

    func settingsPickerViewDonePressed(index: Int) {
        // Ask Setting Handler to update data and refresh the table view.
        pickerSelectionDelegate?.userSelectedValue(index: index)
        dismiss(animated: true, completion: nil)
    }

}
