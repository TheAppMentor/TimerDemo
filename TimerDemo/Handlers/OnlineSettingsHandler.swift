//
//  OnlineSettingsHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/29/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation

class OnlinePreferenceHandler {
    
    // Stored Properties
    static let shared = OnlinePreferenceHandler()
    var allPreferences : [PreferenceCategory]
    let prefOrderArray = [PreferenceType.Duration,.Intervals,.Goals,.Alerts]
    
    
    private init() {
        allPreferences = []
        //populateAllPreferences()
    }
    
    func populateAllPreferences(completionHandler : (()->())? = nil) {
        
        var prefCatArray = [PreferenceCategory]()
        
        PersistenceHandler.shared.fetchAllPreferences{ (fetchedPrefDict) in
            
                for eachPrefGroup in fetchedPrefDict.enumerated(){
                    var tempPerfArr = [Preference]()
                    
                    if let eachPrefCategoryDict = eachPrefGroup.element.value as? [String : AnyObject]{
                        for eachPref in eachPrefCategoryDict.enumerated(){
                            let tempPref = Preference(name: eachPref.element.key ,
                                                      displayName:eachPref.element.value["displayName"] as! String,
                                                      listOfValues: eachPref.element.value["listOfValues"] as! [AnyObject],
                                                      currentValue: eachPref.element.value["currentValue"]! as AnyObject,
                                                      unitName: eachPref.element.value["unitName"] as! String)
                            tempPerfArr.append(tempPref)
                        }
                    }
                    
                    prefCatArray.append(PreferenceCategory(categoryName: PreferenceType(rawValue: eachPrefGroup.element.key)!, preferences: tempPerfArr))
                    
                }
                self.allPreferences = prefCatArray
                completionHandler?()
        }
    }
    
//    func loadInitialPerferenceValues(completionHanlder : @escaping () -> ()) {
//
//        var prefCatArray = [PreferenceCategory]()
//
//        PersistenceHandler.shared.setInitialValueForPreferences {
//            PersistenceHandler.shared.fetchAllPreferences{ (fetchedPrefDict) in
//                for eachPrefGroup in fetchedPrefDict.enumerated(){
//                    var tempPerfArr = [Preference]()
//
//                    if let eachPrefCategoryDict = eachPrefGroup.element.value as? [String : AnyObject]{
//                        for eachPref in eachPrefCategoryDict.enumerated(){
//                            let tempPref = Preference(name: eachPref.element.key ,
//                                                      displayName:eachPref.element.value["displayName"] as! String,
//                                                      listOfValues: eachPref.element.value["listOfValues"] as! [AnyObject],
//                                                      currentValue: eachPref.element.value["currentValue"]! as AnyObject,
//                                                      unitName: eachPref.element.value["unitName"] as! String)
//                            tempPerfArr.append(tempPref)
//                        }
//                    }
//
//                    prefCatArray.append(PreferenceCategory(categoryName: PreferenceType(rawValue: eachPrefGroup.element.key)!, preferences: tempPerfArr))
//
//                }
//                self.allPreferences = prefCatArray
//                completionHanlder()
//            }
//
//        }
//    }
    
    
    func updatePreference(prefType : PreferenceType, updatedValue : Preference, completionHandler : @escaping ()->()) {
        
        var tempPrefCategory = PreferenceCategory(categoryName: prefType, preferences: [])
        
        for eachCategory in allPreferences.filter({$0.category == prefType}){
            for eachPref in eachCategory.allPerferences{
                eachPref.name == updatedValue.name ? tempPrefCategory.allPerferences.append(updatedValue) : tempPrefCategory.allPerferences.append(eachPref)
            }
        }
        PersistenceHandler.shared.updatePreferenceCategory(preferenceType: prefType, withPreference: tempPrefCategory)
        
        populateAllPreferences {
            completionHandler()
        }
    }
    
    
    
    func numberOfSections() -> Int{
        return prefOrderArray.count
    }
    
    func numberOfRowsForSection(section: Int) -> Int{
        let prefType = prefOrderArray[section]
        
        if let prefCategory = allPreferences.filter({$0.category == prefType}).first{
            return prefCategory.allPerferences.count
        }
        
        return 0
    }
//    func fetchSettingForIndex(section: Int, row: Int) -> Preference? {
    func fetchPreferenceForIndex(section : Int, row : Int) -> Preference?{
        
        let prefType = prefOrderArray[section]
        
        if let prefCategory = allPreferences.filter({$0.category == prefType}).first{
            return prefCategory.allPerferences[row]
        }
        
        return nil
    }
    
    
    func cellTypeForPerferenceAtIndexPathIndexPath(section : Int, row : Int) -> String {
        //        cellWithRightLabel
        //        plainCell
        //        cellWithButton
        
        let thePref = fetchPreferenceForIndex(section: section, row: row)
        return thePref!.name == "isVibrateOn" ? "cellWithButton" : "cellWithRightLabel"
    }
    
    func titleForPerferenceAtIndexPath(section : Int, row : Int) -> String {
        let thePref = fetchPreferenceForIndex(section: section, row: row)
        return thePref?.displayName ?? ""
    }
    
    func detailLabelForPerferenceAtIndexPath(section : Int, row : Int) -> String {
        let thePref = fetchPreferenceForIndex(section: section, row: row)
        return (String(describing: thePref?.currentValue ?? "" as AnyObject)) + " " + (thePref?.unitName  ?? "")
    }
    
    func fetchPrefereceAtIndexPath(section : Int, row : Int) -> Preference {
        let prefCategory = allPreferences[section]
        return prefCategory.allPerferences[row]
    }
    
    func fetchPreferenceTypeForSection(section : Int) -> PreferenceType {
        return prefOrderArray[section]
    }
    
    func fetchPreferenceFor(prefType : PreferenceType, prefName : String) -> Preference? {
        let prefCategory = allPreferences.filter({$0.category == prefType})
        
        guard prefCategory.count > 0 else {return nil}
        
        let matchingPrefs = prefCategory.first?.allPerferences.filter({$0.name == prefName})
        
        guard matchingPrefs != nil, matchingPrefs!.count > 0 else {return nil}
        return matchingPrefs?.first ?? nil
    }
    
    
}
