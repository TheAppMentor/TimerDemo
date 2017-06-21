//
//  TestViewVC.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/13/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class TestViewVC: UIViewController {
    
    
    @IBOutlet weak var progressView: ArcProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progressView.animateProgressBarForwards()
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
