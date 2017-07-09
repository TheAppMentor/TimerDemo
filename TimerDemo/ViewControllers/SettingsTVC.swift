//
//  SettingsTVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/7/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController, PickerSelectionDelegate {
    
    var bluvaryer = CALayer()
    var settingsPickerView : SettingsPickerView?
    
    var selectedPref : Preference?
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: Utilities.shared.regularFontSize]
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at:selectedRow , animated: true)
        }
    }
    
    @IBAction func dismissSettingsScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return OnlinePreferenceHandler.shared.numberOfSections()
        //return SettingsHandler.shared.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return OnlinePreferenceHandler.shared.numberOfRowsForSection(section: section)
//        return SettingsHandler.shared.numberOfRowsForSection(section: section)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected Setting
        //selectedSetting = SettingsHandler.shared.fetchSettingForIndex(section: indexPath.section, row: indexPath.row)
        selectedPref = OnlinePreferenceHandler.shared.fetchPreferenceForIndex(section: indexPath.section, row: indexPath.row)
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showPickerView", sender: self)
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.shared.tableViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.shared.sectionHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = OnlinePreferenceHandler.shared.cellTypeForPerferenceAtIndexPathIndexPath(section: indexPath.section, row: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // Configure the cell...
        if let titleLabel = cell.viewWithTag(11) as? UILabel{
            titleLabel.text = OnlinePreferenceHandler.shared.titleForPerferenceAtIndexPath(section: indexPath.section, row: indexPath.row)
        }
        
        if let titleLabel = cell.viewWithTag(22) as? UILabel{
            //titleLabel.text = SettingsHandler.shared.detailLabelForIndex(section: indexPath.section, row: indexPath.row)
            titleLabel.text = OnlinePreferenceHandler.shared.detailLabelForPerferenceAtIndexPath(section: indexPath.section, row: indexPath.row)
        }
                
        return cell
    }
    
    func userSelectedValue(index: Int) {
        
        guard let selectedPref = selectedPref else { return }
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        let updatedCurrValue = selectedPref.listOfValues[index]
        
        let theUpdatedPref = Preference(name: selectedPref.name, displayName: selectedPref.displayName, listOfValues: selectedPref.listOfValues, currentValue: updatedCurrValue, unitName: selectedPref.unitName)
        
        // Update value of the cell in OnlinePerf Handler.
        OnlinePreferenceHandler.shared.updatePreference(prefType: OnlinePreferenceHandler.shared.fetchPreferenceTypeForSection(section: selectedIndexPath.section), updatedValue: theUpdatedPref){
            self.tableView.reloadData()
        }
        
//        let updatedSetting = Setting(displayName: selectedPref!.displayName, currentValue: selectedPref!.listOfValues[index] as! String, listOfValues: selectedPref!.listOfValues as! [String])
//        SettingsHandler.shared.updateSettingForIndex(section: selectedIndexPath!.section, row: selectedIndexPath!.row, newSetting: updatedSetting)
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let thePickerVC = segue.destination as? PickerVC{
            
            let currentValue = selectedPref?.currentValue ?? "" as AnyObject
            let displayName = selectedPref?.displayName ?? ""
            var isAlert = false
            
            //TODO: Ned to fix this, not a good way.
            if selectedPref?.name == "longBreakCompletedSound" || selectedPref?.name == "shortBreakCompletedSound" || selectedPref?.name == "taskCompletedSound"{
                    isAlert = true
            }
            
            let listOfValueInPicker =  selectedPref?.listOfValues.map({String(describing: $0)})
            
            let indexOfCurrentSelectedValue = listOfValueInPicker?.index(where: {$0 == String(describing: currentValue)})
            
            thePickerVC.pickerViewData = SettingsPickerViewDataProvider(pickerViewIndexOfSelectedItem: indexOfCurrentSelectedValue!,
                                                                        pickerViewItems: listOfValueInPicker ?? [],
                                                                        pickerViewTitle: displayName,
                                                                        isAlert: isAlert)
            
            thePickerVC.pickerSelectionDelegate = self
        }
    }
}
