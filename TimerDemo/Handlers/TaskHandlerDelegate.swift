//
//  TaskEventHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 8/24/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

protocol TaskHandlerDelegate {
    func timerDidChangeValue(seconds: CFTimeInterval)
    func currentDidPause()
    func currentTaskDidFreeze()
    func currentTaskDidUnFreeze(timeRemaining: TimeInterval)
    func currentTaskDidResume()
    func currentTaskDidAbandon()
    func currentTaskDidComplete()
}
