//
//  SettingsHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/6/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

public struct SettingsHandler {

    static var shared = SettingsHandler()

    private let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    private let settingsFileName = "/Settings.plist"

    private var settingsFilePath: String {
        let filePathString = documentsDir! + settingsFileName
        return filePathString
    }

    private var _settingsDict: [String: [String: Setting]]?

    private var settingsDict: [String: [String: Setting]]? {
        set {
            _settingsDict = newValue
            writeSettingsToFile()
        }

        get {
            return _settingsDict ?? nil
        }
    }

    private init() {
        copySettingsFileFromBundle()
        loadSettingsToMemory()
    }

    var taskDurationMinutes: Setting {
        set {
            updateValueForKey(section: "Duration", settingName: "taskDurationMinutes", newSetting: newValue)
        }
        get {
            return getSettingFor(section: "Duration", key: "taskDurationMinutes")!
        }
    }

    var shortBreakDurationMinutes: Setting {
        set {
            updateValueForKey(section: "Duration", settingName: "shortBreakDurationMinutes", newSetting: newValue)
        }
        get {
            return getSettingFor(section: "Duration", key: "shortBreakDurationMinutes")!
        }
    }

    var longBreakDurationMinutes: Setting {
        set {
            updateValueForKey(section: "Duration", settingName: "longBreakDurationMinutes", newSetting: newValue)
        }
        get {
            return getSettingFor(section: "Duration", key: "longBreakDurationMinutes")!
        }
    }

    var shortBreakInterval: Setting {

        set {
            updateValueForKey(section: "Intervals", settingName: "shortBreakInterval", newSetting: newValue)
        }

        get {
            return getSettingFor(section: "Intervals", key: "shortBreakInterval")!
        }
    }

    var longBreakInterval: Setting {
        set {
        updateValueForKey(section: "Intervals", settingName: "longBreakInterval", newSetting: newValue)
        }

        get {
        return getSettingFor(section: "Intervals", key: "longBreakInterval")!
        }
    }

    var dailyGoal: Setting {
        set {
            updateValueForKey(section: "Goals", settingName: "dailyGoal", newSetting: newValue)

        }

        get {
            return getSettingFor(section: "Goals", key: "dailyGoal")!

        }
    }

    var isVibrateOn: Setting {

        set {
            updateValueForKey(section: "Alerts", settingName: "isVibrateOn", newSetting: newValue)
        }

        get {
            return getSettingFor(section: "Alerts", key: "isVibrateOn")!

        }

    }

    var taskCompletedSound: Setting {

        set {
            updateValueForKey(section: "Alerts", settingName: "taskCompletedSound", newSetting: newValue)
        }

        get {
            return getSettingFor(section: "Alerts", key: "taskCompletedSound")!

        }

    }

    var shortBreakCompletedSound: Setting {

        set {
            updateValueForKey(section: "Alerts", settingName: "shortBreakCompletedSound", newSetting: newValue)
        }

        get {
            return getSettingFor(section: "Alerts", key: "shortBreakCompletedSound")!

        }

    }

    var longBreakCompletedSound: Setting {
        set {
            updateValueForKey(section: "Alerts", settingName: "longBreakCompletedSound", newSetting: newValue)

        }
        get {
            return getSettingFor(section: "Alerts", key: "longBreakCompletedSound")!

        }
    }

    private func getSettingFor(section: String, key: String) -> Setting? {
        return settingsDict?[section]?[key] ?? nil
    }

    private mutating func updateValueForKey(section: String, settingName: String, newSetting: Setting) {

        guard settingsDict != nil else {return}

        var tempSettingsDict = [String:[String:Setting]]()

        for eachSetting in settingsDict!.enumerated() {
            // Check if sections matches
            if eachSetting.element.key == section {

                var tempSettingSection = [String : Setting]()

                //if eachSetting.element.value[settingName] == settingName{
                    for (key, eachSettingSection) in eachSetting.element.value {
                        if key == settingName {
                            tempSettingSection[key] = newSetting
//                            tempSettingsDict[eachSetting.element.key] = [key:newSetting]
                            continue
                        }
                        tempSettingSection[key] = eachSettingSection
//                        tempSettingsDict[eachSetting.element.key] = [key:eachSetting.element.value[]]
                    }
                tempSettingsDict[eachSetting.element.key] = tempSettingSection
                continue
                //}
            }

            // Copy Entire Section into Settings As-Is
            tempSettingsDict[eachSetting.element.key] = eachSetting.element.value
        }

        settingsDict = tempSettingsDict
    }

    mutating func loadSettingsToMemory() -> Bool {

        if FileManager.default.fileExists(atPath: settingsFilePath) == true {
            if let settingsD = NSMutableDictionary(contentsOfFile: settingsFilePath) as? [String: [String: AnyObject?]] {
                var tempD = [String : [String : Setting]]()

                for (_, eachSettingD) in settingsD.enumerated() {
                    var tempInnerD = [String : Setting]()
                    for (_, eachSettingObj)  in eachSettingD.value.enumerated() {
                        if let actualSettingsD = eachSettingObj.value as? [String: AnyObject?] {
                            let tempSetting = Setting(displayName: actualSettingsD["displayName"] as! String, currentValue: actualSettingsD["currentValue"] as! String, listOfValues: actualSettingsD["listOfValues"] as? [String] ?? nil)
                            tempInnerD[eachSettingObj.key] = tempSetting
                        }
                    }
                    tempD[eachSettingD.key] = tempInnerD
                }
                _settingsDict = tempD
                return true
            }
        }
        return false
    }

    func writeSettingsToFile() {

        if FileManager.default.fileExists(atPath: settingsFilePath) == true {
            let setD = NSMutableDictionary(dictionary: _settingsDict!)
            setD.write(to:URL(fileURLWithPath: settingsFilePath), atomically:true)
        }
    }

    func copySettingsFileFromBundle() -> Bool {

        if FileManager.default.fileExists(atPath: settingsFilePath) == false {
            if let theBundleFile = Bundle.main.path(forResource: "Settings", ofType: "plist") {
                do {
                    if let _ = try? FileManager.default.copyItem(at: URL(fileURLWithPath: theBundleFile), to: URL(fileURLWithPath: settingsFilePath)) {
                        return true
                    }
                }
            }
        }
        return false
    }

    // Settings Data Provider

    func numberOfSections() -> Int {
        return settingsDict?.keys.count ?? 0
    }

    func numberOfRowsForSection(section: Int) -> Int {
        if let secName = sectionNameForIndex(section: section) {
            return settingsDict?[secName]?.keys.count ?? 0
        }

        return 0
    }

    let sectionRowMap = (("Duration", ["taskDurationMinutes", "shortBreakDurationMinutes", "longBreakDurationMinutes"]),
                         ("Intervals", ["shortBreakInterval", "longBreakInterval"]),
                         ("Goals", ["dailyGoal"]),
                         ("Alerts", ["taskCompletedSound", "shortBreakCompletedSound", "longBreakCompletedSound", "isVibrateOn"])
                        )

    func sectionNameForIndex(section: Int) -> String? {
       return fetchSectionDetails(section: section)?.0 ?? nil
    }

    func fetchSettingForIndex(section: Int, row: Int) -> Setting? {

        if let rowName = fetchSectionDetails(section: section)?.1[row] {
            switch rowName {
            case "taskDurationMinutes" : return taskDurationMinutes
            case "shortBreakDurationMinutes" : return shortBreakDurationMinutes
            case "longBreakDurationMinutes" : return longBreakDurationMinutes
            case "shortBreakInterval" : return shortBreakInterval
            case "longBreakInterval" : return longBreakInterval
            case "dailyGoal" : return dailyGoal
            case "taskCompletedSound" : return taskCompletedSound
            case "shortBreakCompletedSound" : return shortBreakCompletedSound
            case "longBreakCompletedSound" : return longBreakCompletedSound
            case "isVibrateOn" : return isVibrateOn

            default : return nil
            }
        }

        return nil
        //return fetchSectionDetails(section: section)?.1[row] ?? nil
    }

    mutating func updateSettingForIndex(section: Int, row: Int, newSetting: Setting) {

        if let rowName = fetchSectionDetails(section: section)?.1[row] {
            switch rowName {
            case "taskDurationMinutes" :  taskDurationMinutes = newSetting
            case "shortBreakDurationMinutes" : shortBreakDurationMinutes  = newSetting
            case "longBreakDurationMinutes" : longBreakDurationMinutes = newSetting
            case "shortBreakInterval" : shortBreakInterval = newSetting
            case "longBreakInterval" : longBreakInterval = newSetting
            case "dailyGoal" : dailyGoal = newSetting
            case "taskCompletedSound" : taskCompletedSound = newSetting
            case "shortBreakCompletedSound" : shortBreakCompletedSound = newSetting
            case "longBreakCompletedSound" : longBreakCompletedSound = newSetting
            case "isVibrateOn" : isVibrateOn = newSetting

            default : break
            }
        }
    }

    func rowNameForIndex(section: Int, row: Int) -> String? {

        if let theSetting = fetchSettingForIndex(section: section, row: row) {
            return theSetting.displayName
        }

        return nil
    }

    func detailLabelForIndex(section: Int, row: Int) -> String? {

        if let theSetting = fetchSettingForIndex(section: section, row: row) {
            return theSetting.currentValue
        }
        return nil
    }

    func fetchSectionDetails(section: Int) -> (String, [String])? {
        switch section {
        case 0: return sectionRowMap.0
        case 1: return sectionRowMap.1
        case 2: return sectionRowMap.2
        case 3: return sectionRowMap.3

        default:
            assertionFailure("We have mismatch in the number of sections ... Check it.")
            return nil
        }
    }

    func cellTypeForIndexPath(section: Int, row: Int) -> String {
//        cellWithRightLabel
//        plainCell
//        cellWithButton

        if section == 3 && row == 3 {return "cellWithButton"} // isVibrate On Cell
        return "cellWithRightLabel"
    }
}
