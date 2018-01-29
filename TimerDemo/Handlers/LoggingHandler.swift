//
//  LoggingHandler.swift
//  TimerDemo
//
//  Created by Prashanth Moorthy on 28/01/18.
//  Copyright © 2018 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import Willow
import Firebase

class LoggingHandler  {
    
    static let shared = LoggingHandler()
    
    private let _logger : Logger
    private let _loggerAnalytics : Logger

    private init() {
        let consoleWriter = ConsoleWriter.init()
        let fireBaseWriter = FireBaseLogWriter.init()
        _logger = Logger.init(logLevels: .debug, writers: [consoleWriter])
        _loggerAnalytics = Logger.init(logLevels: .firebase, writers: [consoleWriter,fireBaseWriter])
    }
    
    func logAnalyticsEvent(analyticsEvent : AnalyticsEvent){
        _loggerAnalytics.firebaseMessage(analyticsEvent.getMessage())
    }
    
    func log(message : String, attributes : [String:Any?]){
        _logger.debugMessage(message)
    }
}


extension LogLevel {
    fileprivate static var firebase = LogLevel(rawValue: 0b00000000_00000000_00000001_00000000)
}

enum AnalyticsEvent{
    case app_launched(userID : String)
    case new_Task_Created(taskName : String)
    case task_Started(taskName : String)
    case task_Ended(taskName : String)
    case navigatedToSettingsScreen
    case navigatedToTaskListScreen
    case app_did_resignActive
    case app_did_becomeActive

    func getMessage() -> LogMessage{
        switch self {
        case .app_launched (let userID):
            return FireBaseMessage.init(name: "Application_Launched", attributes: ["userID" : userID])
        case .task_Started(let taskName):
            return FireBaseMessage.init(name: "Task_Started", attributes: ["taskName" : taskName])
        case .task_Ended(let taskName):
            return FireBaseMessage.init(name: "Task_Ended", attributes: ["taskName" : taskName])
        case .new_Task_Created(let taskName):
            return FireBaseMessage.init(name: "new_task_created", attributes: ["taskName" : taskName])
        case .navigatedToSettingsScreen:
            return FireBaseMessage.init(name: "navigated_to_settingScreen", attributes: [:])
        case .navigatedToTaskListScreen:
            return FireBaseMessage.init(name: "navigated_to_taskListScreen", attributes: [:])
        case .app_did_becomeActive:
            return FireBaseMessage.init(name: "app_did_becomeActive", attributes: [:])
        case .app_did_resignActive:
            return FireBaseMessage.init(name: "app_did_resignActive", attributes: [:])

        }
    }
}

struct FireBaseMessage : LogMessage {
    var name: String
    var attributes: [String : Any]
}

extension Logger {
    public func firebaseMessage(_ message: @autoclosure @escaping () -> String) {
        logMessage(message, with: .firebase)
    }
    
    public func firebaseMessage(_ message: @escaping () -> String) {
        logMessage(message, with: .firebase)
    }
    
    open func firebaseMessage(_ message: @autoclosure @escaping () -> LogMessage) {
        logMessage(message, with: LogLevel.firebase)
    }

    open func firebaseMessage(_ message: @escaping () -> LogMessage) {
        logMessage(message, with: LogLevel.firebase)
    }

}


class FireBaseLogWriter : LogWriter{
    func writeMessage(_ message: String, logLevel: LogLevel) {
        Analytics.logEvent(message, parameters: [:])
    }
    
    func writeMessage(_ message: LogMessage, logLevel: LogLevel) {
        Analytics.logEvent(message.name, parameters: message.attributes)
    }
}
