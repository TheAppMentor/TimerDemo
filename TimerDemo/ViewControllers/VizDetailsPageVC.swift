 //
 //  VizDetailsPageVC.swift
 //
 //
 //  Created by Moorthy, Prashanth on 7/5/17.
 //
 
 import UIKit
 
 class VizDetailsPageVC: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
//    var miniVizToDisplay : [TypeOfViz] = [.tableTaskList,.recent,.chartToday,.chartAlltime,.chartAlltime] // The Ideal Goal
    var miniVizToDisplay : [TypeOfViz] = [.tableTaskList,.recent]
    
    var myContainerVC : MainTimerScreenVC!
    
    var allViewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateVCs()
        delegate = self
        dataSource = self
    }
    
    func populateVCs() {
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
            }
        }
        
        self.setViewControllers([allViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    
    func reloadAllViews() {
        //TODO: Since we have only two VC this is ok, the curretn way is to keep track of index of current displayed vc and then reloading only that.
        //https://stackoverflow.com/questions/8400870/uipageviewcontroller-return-the-current-visible-view
        
        for eachVC in allViewControllers{
            if let currDispVC = eachVC as? MiniTaskListTVC{
                currDispVC.fetchInfoForTableAndReload()
            }
            
        }
        
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
 }
