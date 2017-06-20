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
    
    var selectedSetting : Setting?
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
        return SettingsHandler.shared.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SettingsHandler.shared.numberOfRowsForSection(section: section)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected Setting
        selectedSetting = SettingsHandler.shared.fetchSettingForIndex(section: indexPath.section, row: indexPath.row)
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
        let cellIdentifier = SettingsHandler.shared.cellTypeForIndexPath(section: indexPath.section, row: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...
        if let titleLabel = cell.viewWithTag(11) as? UILabel{
            titleLabel.text = SettingsHandler.shared.rowNameForIndex(section: indexPath.section, row: indexPath.row)
        }
        
        if let titleLabel = cell.viewWithTag(22) as? UILabel{
            titleLabel.text = SettingsHandler.shared.detailLabelForIndex(section: indexPath.section, row: indexPath.row)
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    func userSelectedValue(index: Int) {
        
        guard let _ = selectedSetting else { return }
        guard let _ = selectedIndexPath else { return }
        
        let updatedSetting = Setting(displayName: selectedSetting!.displayName, currentValue: selectedSetting!.listOfValues![index], listOfValues: selectedSetting!.listOfValues)
        SettingsHandler.shared.updateSettingForIndex(section: selectedIndexPath!.section, row: selectedIndexPath!.row, newSetting: updatedSetting)
        tableView.reloadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let thePickerVC = segue.destination as? PickerVC{
            
            let currentValue = selectedSetting?.currentValue ?? ""
            let displayName = selectedSetting?.displayName ?? ""
            let listOfValueInPicker = selectedSetting?.listOfValues ?? []
            let indexOfCurrentSelectedValue = selectedSetting?.listOfValues?.index(of: currentValue) ?? 0
            
            thePickerVC.pickerViewData = SettingsPickerViewDataProvider(pickerViewIndexOfSelectedItem: indexOfCurrentSelectedValue,
                                                                        pickerViewItems: listOfValueInPicker,
                                                                        pickerViewTitle: displayName)
            
            thePickerVC.pickerSelectionDelegate = self
        }
        
    }
    
}
