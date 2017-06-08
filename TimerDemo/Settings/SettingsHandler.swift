//
//  SettingsHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/6/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

public struct SettingsHandler {
    
    static let shared = SettingsHandler()
    
    private let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    private let settingsFileName = "/Settings.plist"
    
    private var settingsFilePath : String{
        let filePathString = documentsDir! + settingsFileName
        return filePathString
    }
    
    private var _settingsDict : [String:AnyObject?]? = nil
    
    private var settingsDict : [String:AnyObject?]?{
        set{
            _settingsDict = newValue
            writeSettingsToFile()
        }
        
        get{
            return _settingsDict ?? nil
        }
    }
    
    private init() {
        copySettingsFileFromBundle()
        loadSettingsToMemory()
    }
    
    var taskDurationMinutes : Double{
        set{
            updateValueForKey(key: "taskDurationMinutes", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "taskDurationMinutes") as? Double ?? 25.0
        }
    }
    
    var shortBreakDurationMinutes : Double{
        set{
            updateValueForKey(key: "shortBreakDurationMinutes", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "shortBreakDurationMinutes") as? Double ?? 5.0
        }
    }
    
    var longBreakDurationMinutes : Double{
        set{
            updateValueForKey(key: "longBreakDurationMinutes", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "longBreakDurationMinutes") as? Double ?? 25.0
        }
    }
    
    var shortBreakInterval : Int{

        set{
            updateValueForKey(key: "shortBreakInterval", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "shortBreakInterval") as? Int ?? 1
        }
    }
    
    var longBreakInterval : Int{
        set{
            updateValueForKey(key: "longBreakInterval", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "longBreakInterval") as? Int ?? 4
        }
    }
    
    var dailyGoal : Int{
        set{
            updateValueForKey(key: "dailyGoal", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "dailyGoal") as? Int ?? 4
        }
    }
    
    var taskCompletedSound : String{
        set{
            updateValueForKey(key: "taskCompletedSound", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "taskCompletedSound") as? String ?? "default"
        }

    }
    
    var shortBreakCompletedSound : String{
        set{
            updateValueForKey(key: "shortBreakCompletedSound", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "shortBreakCompletedSound") as? String ?? "default"
        }
    }
    
    var longBreakCompletedSound : String{
        set{
            updateValueForKey(key: "longBreakCompletedSound", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "longBreakCompletedSound") as? String ?? "default"
        }

    }
    
    var isVibrateOn : Bool{
        
        set{
            updateValueForKey(key: "isVibrateOn", value: (newValue as AnyObject))
        }
        
        get{
            return checkValueForKey(key : "isVibrateOn") as? Bool ?? false
        }

    }
    

    
    
    
    

    
    
    private func checkValueForKey(key : String) -> AnyObject? {
        return settingsDict?[key] ?? nil
    }


    private mutating func updateValueForKey(key : String, value : AnyObject?) {
        
        if var tempSettingsD = settingsDict{
            if tempSettingsD[key] != nil{
                tempSettingsD[key] = value
                settingsDict = tempSettingsD
            }
        }
    }

    
    
    mutating func loadSettingsToMemory() -> Bool {
        
        if FileManager.default.fileExists(atPath: settingsFilePath) == true{
            if let settingsD = NSMutableDictionary(contentsOfFile: settingsFilePath) as? [String:AnyObject?]{
                _settingsDict = settingsD
                return true
            }
        }
        return false
    }
    
    func writeSettingsToFile(){
        
        if FileManager.default.fileExists(atPath: settingsFilePath) == true{
            let setD = NSMutableDictionary(dictionary: _settingsDict!)
            setD.write(to: URL(fileURLWithPath: settingsFilePath) , atomically: true)
        }
    }
    
    func copySettingsFileFromBundle() -> Bool{
    
        if FileManager.default.fileExists(atPath: settingsFilePath) == false{
            if let theBundleFile = Bundle.main.path(forResource: "Settings", ofType: "plist"){
                do{
                    if let _ = try? FileManager.default.copyItem(at: URL(fileURLWithPath: theBundleFile)  , to: URL(fileURLWithPath: settingsFilePath)){
                        return true
                    }
                }
            }
        }
        return false
    }
}
