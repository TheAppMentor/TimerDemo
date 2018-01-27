//
 //  VizDetailsPageVC.swift
 //
 //
 //  Created by Moorthy, Prashanth on 7/5/17.
 //

 import UIKit

 class VizDetailsPageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

//    var miniVizToDisplay : [TypeOfViz] = [.tableTaskList,.recent,.chartToday,.chartAlltime,.chartAlltime] // The Ideal Goal
    var listOfVizToDisplay: [TypeOfViz] = [.tableTaskList, .recent]

    var myContainerVC: MainTimerScreenVC!
    var shouldDisplayChartTitle: Bool = true

    var allViewControllers: [UIViewController] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        populateVCs()
    }

    func populateVCs() {
        for eachVizType in listOfVizToDisplay {
            switch eachVizType {
            case .tableTaskList:
                if let tempTableVC = storyboard?.instantiateViewController(withIdentifier: "miniTaskList") as? MiniTaskListTVC {
                    tempTableVC.eventHandlerDelegate = myContainerVC
                    allViewControllers.append(tempTableVC)
                }

            case .chartToday, .chartThisWeek, .chartAlltime, .recent, .chartThisMonth:
                if let tempChartVC = storyboard?.instantiateViewController(withIdentifier: "VizDisplayVC") as? VizDisplayVC {
                    tempChartVC.view.frame = view.bounds
                    tempChartVC.typeOfViz = eachVizType
                    tempChartVC.shouldDisplayChartTitle = self.shouldDisplayChartTitle
                    allViewControllers.append(tempChartVC)
                }
            }
        }

        self.setViewControllers([allViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }

    func reloadAllViews() {
        //TODO: Since we have only two VC this is ok, the curretn way is to keep track of index of current displayed vc and then reloading only that.
        //https://stackoverflow.com/questions/8400870/uipageviewcontroller-return-the-current-visible-view

        for eachVC in allViewControllers {
            if let currDispVC = eachVC as? MiniTaskListTVC {
                currDispVC.fetchInfoForTableAndReload()
            }
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if let currentIndex = allViewControllers.index(of: viewController) {

            if currentIndex == 0 {return nil}   // Prevent pages from looping around the end.

            let previousIndex = abs((currentIndex - 1) % allViewControllers.count)
            return allViewControllers[previousIndex]
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = allViewControllers.index(of: viewController) {

            if currentIndex == allViewControllers.count - 1 {return nil}  // Prevent pages from looping around the end.

            let nextIndex = abs((currentIndex + 1) % allViewControllers.count)
            return allViewControllers[nextIndex]
        }

        return nil
    }

    // The number of items reflected in the page indicator.
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return listOfVizToDisplay.count
    }
    // The selected item reflected in the page indicator.
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
 }
