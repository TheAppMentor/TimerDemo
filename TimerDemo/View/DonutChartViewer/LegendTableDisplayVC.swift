//
//  LegendTableDisplayVC.swift
//  DonutChartViewer
//
//  Created by Moorthy, Prashanth on 4/1/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class LegendTableDisplayVC: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var legendData = ["Australia","Argentina","Brazil","India","Japan","Malaysia","Nigeria","United States"]

    let col1 = UIColor(red: (26.0/255.0), green: (188.0/255.0), blue: (156.0/255.0), alpha: 1.0)
    let col2 = UIColor(red: (149.0/255.0), green: (165.0/255.0), blue: (166.0/255.0), alpha: 1.0)
    let col3 = UIColor(red: (44.0/255.0), green: (62.0/255.0), blue: (80.0/255.0), alpha: 1.0)
    let col4 = UIColor(red: (155.0/255.0), green: (89.0/255.0), blue: (182.0/255.0), alpha: 1.0)
    let col5 = UIColor(red: (41.0/255.0), green: (128.0/255.0), blue: (185.0/255.0), alpha: 1.0)
    let col6 = UIColor(red: (39.0/255.0), green: (174.0/255.0), blue: (96.0/255.0), alpha: 1.0)
    let col7 = UIColor(red: (241.0/255.0), green: (196.0/255.0), blue: (15.0/255.0), alpha: 1.0)
    let col8 = UIColor(red: (77.0/255.0), green: (208.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    let col9 = UIColor(red: (229.0/255.0), green: (115.0/255.0), blue: (115.0/255.0), alpha: 1.0)

    var colorPalette = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        colorPalette = [col1,col2,col3,col4,col5,col6,col7,col8,col9]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        legendHolderView.layer.cornerRadius = 10.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBOutlet weak var legendHolderView: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "legendCell")
        
        //Customize the Swatch tag == 1
        
        if let theColorSwatch = cell?.viewWithTag(1){
            theColorSwatch.layer.cornerRadius = 5.0
            theColorSwatch.backgroundColor = colorPalette[indexPath.row]
        }
        
        //Customize the label tag == 2
        if let theLabel = cell?.viewWithTag(2) as? UILabel{
            theLabel.text = legendData[indexPath.row]
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Not a good way to do this, we need make the blur view part of the legend view itself.
        dismissLegenPaneView()

    }
    
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        dismissLegenPaneView()
    }
    
    func dismissLegenPaneView() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "legendSelected"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

    
    
    

}
