//
//  SettingsPickerViewData.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/8/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct SettingsPickerViewDataProvider: SettingsPickerViewData {
    var pickerViewIndexOfSelectedItem: Int
    let pickerViewItems: [String]
    let pickerViewTitle: String
    let isAlert: Bool
}
