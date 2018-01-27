//
//  AudioHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/9/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

import AudioToolbox

//class Sound {
//
//    var soundEffect: SystemSoundID = 0
//
//    init(name: String, type: String) {
//        let path  = NSBundle.mainBundle().pathForResource(name, ofType: type)!
//        let pathURL = NSURL(fileURLWithPath: path)
//        AudioServicesCreateSystemSoundID(pathURL as CFURLRef, &soundEffect)
//    }
//
//    func play() {
//        AudioServicesPlaySystemSound(soundEffect)
//    }
//}

enum AudioFileMap: String {

    case Alert1 = "Alert Tune 1"
    case Alert2 = "Alert Tune 2"
    case Alert3 = "Alert Tune 3"

    var alertID: SystemSoundID {
        switch self {
        case .Alert1 : return 1013
        case .Alert2 : return 1008
        case .Alert3 : return 1014
        }
    }

    var alertCFURL: CFURL {
        switch self {
        case .Alert1 : return URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received5.caf") as CFURL // sms-received5.caf    1013
        case .Alert2 : return URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received2.caf") as CFURL  // sms-received2.caf    1008
        case .Alert3 : return URL(fileURLWithPath: "/System/Library/Audio/UISounds/sms-received6.caf") as CFURL  // sms-received6.caf    1014
        }
    }

}

class AudioHandler {
    static let shared: AudioHandler = AudioHandler()

    func playAudio(audioID: AudioFileMap) {

        var soundEffect: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(audioID.alertCFURL, &soundEffect)

//        if let audiosSess  = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord){
//            //let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/new-mail.caf")
//        }
        AudioServicesPlaySystemSound(soundEffect)
    }

    func playAudioForEvent(taskType: TaskType) {

        var prefToFetch = "taskCompletedSound"

        switch taskType {
        case .deepFocus: prefToFetch = "taskCompletedSound"
        case .shortBreak: prefToFetch = "shortBreakCompletedSound"
        case .longBreak: prefToFetch = "longBreakCompletedSound"
        }

        if let alertToPlay = OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Alerts, prefName: prefToFetch)?.currentValue as? String {
            if let alertID = AudioFileMap(rawValue: alertToPlay) {
                playAudio(audioID: alertID)
            }
        }
    }

    func vibrate() {
        if let isVibrateOn = OnlinePreferenceHandler.shared.fetchPreferenceFor(prefType: .Alerts, prefName: "isVibrateOn")?.currentValue as? Bool {
            if isVibrateOn {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
}
