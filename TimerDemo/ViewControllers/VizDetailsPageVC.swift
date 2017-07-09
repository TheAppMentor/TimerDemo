 //
//  VizDetailsPageVC.swift
//  
//
//  Created by Moorthy, Prashanth on 7/5/17.
//

import UIKit

class VizDetailsPageVC: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    var miniVizToDisplay : [TypeOfViz] = [.tableTaskList,.recent,.chartToday,.chartAlltime,.chartAlltime]
    
    var myContainerVC : MainTimerScreenVC!
    
    var allViewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for eachVizType in miniVizToDisplay{
            switch eachVizType{
            case .tableTaskList:
                if let tempTableVC = storyboard?.instantiateViewController(withIdentifier: "miniTaskList") as? MiniTaskListTVC{
                    tempTableVC.eventHandlerDelegate = myContainerVC
                    allViewControllers.append(tempTableVC)
                }
                
            case .chartToday,.chartThisWeek,.chartAlltime,.recent:
                if let tempChartVC = storyboard?.instantiateViewController(withIdentifier: "VizDisplayVC") as? VizDisplayVC{
                    tempChartVC.typeOfViz = eachVizType
                    allViewControllers.append(tempChartVC)
                }
                break
        }
        
//        // Do any additional setup after loading the view.
//        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "VizDisplayVC"){
//            firstVC.view.backgroundColor = UIColor.gray
//            allViewControllers.append(firstVC)
//        }
//
//        if let secVC = storyboard?.instantiateViewController(withIdentifier: "miniTaskList") as? MiniTaskListTVC{
//            secVC.view.backgroundColor = UIColor.blue
//            secVC.eventHandlerDelegate = myContainerVC
//            allViewControllers.append(secVC)
//        }
//
//        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "VizDisplayVC"){
//            thirdVC.view.backgroundColor = UIColor.green
//            allViewControllers.append(thirdVC)
        }
        
        self.setViewControllers([allViewControllers.first!], direction: .forward, animated: true, completion: nil)
        delegate = self
        dataSource = self
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentIndex = allViewControllers.index(of: viewController){
            let previousIndex = abs((currentIndex - 1) % allViewControllers.count)
            return allViewControllers[previousIndex]
        }
        
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = allViewControllers.index(of: viewController){
            let nextIndex = abs((currentIndex + 1) % allViewControllers.count)
            return allViewControllers[nextIndex]
        }
        
        return nil
    }
    
    // The number of items reflected in the page indicator.
    func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return miniVizToDisplay.count
    }
    // The selected item reflected in the page indicator.
    func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        return 0
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
