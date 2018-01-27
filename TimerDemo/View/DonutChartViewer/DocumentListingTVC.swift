//
//  DocumentListingTVC.swift
//  DonutChartViewer
//
//  Created by Moorthy, Prashanth on 4/1/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class DocumentListingTVC: UITableViewController {

    let dataSet = ["BookMarked" : ["Sales by Region", "Discount vs Region"], "All Reports" : ["Cricket Scores", "Yet Another Report", "Report Boy", "Final Boy"]]

    let sampleImages = [#imageLiteral(resourceName: "AreaChart"), #imageLiteral(resourceName: "BarChart"), #imageLiteral(resourceName: "PieChart"), #imageLiteral(resourceName: "DonutChart")]

    var numberOfSections: Int {
        let numberBookMarked = (dataSet["BookMarked"]?.count)!
        let totalNumberOfSections = numberBookMarked + 1
        return totalNumberOfSections  // 1 for the All reports section.
    }

    func isLastSection(section: Int) -> Bool {
        return section == numberOfSections - 1
    }

    func  isEndOfVizSection(section: Int) -> Bool {
        return section == (dataSet["BookMarked"]?.count)! - 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setToolbarHidden(true, animated: false)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isLastSection(section: section) {
           return (dataSet["All Reports"]?.count)!
        }

        return 1 // Each Bookmarked item is in its own section.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = isLastSection(section: indexPath.section) ? "RegularDocListingCell" : "vizListingCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...

        // Modify appearance of the Viz listing cell

        if cellIdentifier == "vizListingCell"{
            cell.layer.cornerRadius = 10

            cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowRadius = 5
            cell.layer.shadowOpacity = 0.25
            cell.layer.masksToBounds = false

            // Populate Cell contents
            if let reportTitleLabel = cell.viewWithTag(1) as? UILabel {
                reportTitleLabel.text = dataSet["BookMarked"]?[indexPath.section]
            }

            if indexPath.section == 1 {

                if let chartImageView = cell.viewWithTag(10) as? UIImageView {
                    chartImageView.image = #imageLiteral(resourceName: "pieChart-1")
                }

                if let legendImageView = cell.viewWithTag(11) as? UIImageView {
                    legendImageView.image = #imageLiteral(resourceName: "pieChartLegend")

                }
            }
        }

        if cellIdentifier == "RegularDocListingCell"{

            if let theThumbImageV = cell.viewWithTag(1) as? UIImageView {
                theThumbImageV.image = sampleImages[indexPath.row]
            }

            if let theTitleLabel = cell.viewWithTag(2) as? UILabel {
                theTitleLabel.text = dataSet["All Reports"]?[indexPath.row]
            }

        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isLastSection(section: indexPath.section) ? 75.0 : 225.0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isLastSection(section: section) ? "All Reports" : nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isLastSection(section: section) ? 40.0 : 10.0
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isEndOfVizSection(section: section) ? 10.0 : 1.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLastSection(section: section) {
            let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40.0))
            sectionHeaderView.backgroundColor = UIColor.white

            let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: tableView.frame.width, height: 20))
            titleLabel.text = "All Reports"
            titleLabel.textColor = UIColor.gray

            sectionHeaderView.addSubview(titleLabel)

            return sectionHeaderView
        }
        return nil
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
