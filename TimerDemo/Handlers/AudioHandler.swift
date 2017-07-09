//
//  AudioHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/9/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import AudioToolbox

enum AudioFileMap : String{
    
    case Alert1 = "Alert Tune 1"
    case Alert2 = "Alert Tune 2"
    case Alert3 = "Alert Tune 3"
    
    var alertID : SystemSoundID{
        switch self {
        case .Alert1 : return 1013
        case .Alert2 : return 1008
        case .Alert3 : return 1014
        }
    }
}

class AudioHandler {
    static let shared : AudioHandler = AudioHandler()
    
    func playAudio(audioID : AudioFileMap) {
        AudioServicesPlaySystemSound(audioID.alertID)
    }
    
    func playAudioForEvent(taskType : TaskType) {
        
        var prefToFetch = "taskCompletedSound"
        
        switch taskType {
        case .deepFocus: prefToFetch = "taskCompletedSound"
        case .shortBreak: prefToFetch = "shortBreakCompletedSound"
        case .longBreak: prefToFetch = "longBreakCompletedSound"
        }
        
        if let alertToPlay = OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Alerts, prefName: prefToFetch)?.currentValue as? String{
            if let alertID = AudioFileMap(rawValue: alertToPlay){
                playAudio(audioID: alertID)
            }
        }
    }
    
    func vibrate() {
        if SettingsHandler.shared.isVibrateOn.currentValue == "ON"{
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
}
