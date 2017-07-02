//
//  Preferences.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/28/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

enum PreferenceType : String{
    case Alerts
    case Goals
    case Duration
    case Intervals
}

func == (lhs : PreferenceCategory, rhs : PreferenceCategory) -> Bool{
    return lhs.category == rhs.category
}

struct PreferenceCategory : Equatable {
    var category : PreferenceType
    var allPerferences : [Preference]
    
    init(categoryName : PreferenceType, preferences : [Preference]) {
        category = categoryName
        allPerferences = []
        for eachPrefDetails in preferences.enumerated(){
            
//         let tempPref =  Preference(name: eachPrefDetails.element.key,
//                                    displayName: (eachPrefDetails.element as! [String:AnyObject])["displayName"] as! String,
//                       listOfValues: (eachPrefDetails.element.value as! [String:AnyObject])["listOfValues"] as! [AnyObject],
//                       currentValue: (eachPrefDetails.element.value as! [String:AnyObject])["currentValue"] as AnyObject,
//                       unitName: (eachPrefDetails.element.value as! [String:AnyObject])["unitName"] as! String)
            //allPerferences.append(eachPrefDetails.element.value as! Preference)
            allPerferences = preferences
        }
    }
    
    init() {
        category = .Alerts
        allPerferences = []
    }
    
    var dictFormat : [String : Any?]{
        
        var tempDict = [String : Any?]()
        
        tempDict["category"] = category.rawValue
        
        var perferencesString = ""
        for eachPref in allPerferences{
            perferencesString += eachPref.jsonFormat
        }
        
        tempDict["perferences"] = perferencesString
        
        return tempDict
    }
    
    var jsonFormat : String{
        let tempDictData = try! JSONSerialization.data(withJSONObject: dictFormat, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal ?? ""
    }
    
}

struct Preference {
    var name : String
    var displayName : String
    var listOfValues : [AnyObject]
    var currentValue : AnyObject
    var unitName : String
    
    
    var dictFormat : [String : Any] {
        var tempDict = [String : Any]()
        
        tempDict["name"] = name
        tempDict["displayName"] = displayName
        tempDict["listOfValues"] = listOfValues
        tempDict["currentValue"] = currentValue
        tempDict["unitName"] = unitName
        
        return tempDict
    }
    
    var jsonFormat : String{
        let tempDictData = try! JSONSerialization.data(withJSONObject: dictFormat, options: .prettyPrinted)
        let stringVal = String(data: tempDictData, encoding: .utf8)
        
        return stringVal ?? ""
    }
}
