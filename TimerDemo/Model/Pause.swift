//
//  Pause.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/14/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

struct Pause {
    var startTime: Date
    var endTime: Date?

    var duration: CFTimeInterval? {
        return endTime?.timeIntervalSince(startTime)
    }

    var reason: String?
}

extension Pause {

    init?(firebaseDict: [String: Any?]) {
        guard let validStartTime = firebaseDict["startTime"] as? TimeInterval else {return nil}
        guard let validendTime = firebaseDict["endTime"] as? TimeInterval else {return nil}
        guard let validReason = firebaseDict["reason"] as? String else {return nil}

        startTime = Date(timeIntervalSince1970: validStartTime)
        endTime = Date(timeIntervalSince1970: validendTime)
        reason = validReason
    }

    var dictFormat: [String: Any?] {
        var tempDict = [String: Any?]()
        tempDict["startTime"] = startTime.timeIntervalSince1970
        tempDict["endTime"] = endTime?.timeIntervalSince1970
        tempDict["reason"] = reason
        return tempDict
    }

    var jsonFormat: String {
        let tempDictData = try! JSONSerialization.data(withJSONObject: dictFormat, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        return stringVal!
    }
}

extension PauseCollection {

    var jsonFormat: String {

        var tempDict = [String: Any?]()
        var tempArray = [Any]()

        for eachPause in pauses {
            tempArray.append(eachPause)
        }

        tempDict["pauses"] = tempArray

        let tempDictData = try! JSONSerialization.data(withJSONObject: tempDict, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)

        return stringVal!
    }
}
