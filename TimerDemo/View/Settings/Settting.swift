//
//  Settting.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/9/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

func ==(lhs: Setting, rhs: Setting) -> Bool {
    return lhs.displayName == rhs.displayName && lhs.currentValue == rhs.currentValue
}

struct Setting: Equatable {
    let displayName: String
    let currentValue: String
    let listOfValues: [String]?
}
