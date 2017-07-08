//
//  VizDetailsPageVC.swift
//  
//
//  Created by Moorthy, Prashanth on 7/5/17.
//

import UIKit

class VizDetailsPageVC: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    var myContainerVC : MainTimerScreenVC!
    
    var allViewControllers : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "VizDisplayVC"){
            firstVC.view.backgroundColor = UIColor.gray
            allViewControllers.append(firstVC)
        }
        
        if let secVC = storyboard?.instantiateViewController(withIdentifier: "miniTaskList") as? MiniTaskListTVC{
            secVC.view.backgroundColor = UIColor.blue
            secVC.eventHandlerDelegate = myContainerVC
            allViewControllers.append(secVC)
        }
        
        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "VizDisplayVC"){
            thirdVC.view.backgroundColor = UIColor.green
            allViewControllers.append(thirdVC)
        }
        
        self.setViewControllers([allViewControllers.first!], direction: .forward, animated: true, completion: nil)
        delegate = self
        dataSource = self
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController.view.backgroundColor == UIColor.blue) {return allViewControllers[0]}
        if (viewController.view.backgroundColor == UIColor.green) {return allViewControllers[1]}
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController.view.backgroundColor == UIColor.gray) {return allViewControllers[1]}
        if (viewController.view.backgroundColor == UIColor.blue) {return allViewControllers[2]}
        return nil
    }
    
    // The number of items reflected in the page indicator.
    func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return 3
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
