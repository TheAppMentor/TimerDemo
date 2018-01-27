//
//  ViewController.swift
//  DonutChartViewer
//
//  Created by Moorthy, Prashanth on 3/31/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
import Charts

struct PizzaSale {
    var pizzaName: String
    var soldQuantity: Int

}

class PageListingVC: UIViewController {

    @IBOutlet weak var chartDisplayView: UIView!

 override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {

        //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dismissLegendBlurView), name: NSNotification.Name(rawValue: "legendSelected"), object: nil)

        self.showToolBar()

        self.navigationController?.navigationBar.tintColor = UIColor.white

        let theDonutComposer = DonutComposer(donutFrame: CGRect(x: 0, y: 0, width: chartDisplayView.frame.width, height: chartDisplayView.frame.height))
        let theDonutData = DonutData(dataPoints: [10, 100, 10, 29.5, 33, 33, 33])

        print("Chart Display View : Frame : \(chartDisplayView.frame)")

        //        let donutView = theDonutComposer.drawDonutUsingData(data: theDonutData)
        let donutView = theDonutComposer.drawDonutUsingData(data: theDonutData, center: CGPoint(x: 0, y:0), radius: 100)

        donutView.layer.shadowOffset = CGSize(width:10, height:10)
        donutView.layer.shadowColor = UIColor.black.cgColor

        chartDisplayView.addSubview(donutView)
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    //let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))

    @IBAction func showLegend(_ sender: UIButton) {

        self.hideToolBar()
        self.hideTitleBar()

        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear

            //let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            //let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            //Add Gesture to dismiss the View
            //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissLegendBlurView))
            //blurEffectView.addGestureRecognizer(tapGesture)

            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            self.performSegue(withIdentifier: "showLegendPanel", sender: self)
        } else {
            self.view.backgroundColor = UIColor.white
        }
    }

    func dismissLegendBlurView() {
        blurEffectView.removeFromSuperview()
        self.view.backgroundColor = UIColor.white
        showToolBar()
        showTitleBar()
    }

    func hideToolBar() {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    func showToolBar() {
        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    func hideTitleBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showTitleBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func shareIt(_ sender: UIBarButtonItem) {
        share(sharingText: "Donut Chart", sharingImage: nil, sharingURL: nil)
    }

    func share(sharingText: String?, sharingImage: UIImage?, sharingURL: URL?) {
        let sharingItems: [AnyObject?] = [
            sharingText as AnyObject,
            sharingImage as AnyObject,
            sharingURL as AnyObject
        ]
        let activityViewController = UIActivityViewController(activityItems: sharingItems.flatMap({$0}), applicationActivities: nil)

        if UIDevice.current.userInterfaceIdiom == .phone {
            activityViewController.popoverPresentationController?.sourceView = view
        }
        present(activityViewController, animated: true, completion: nil)
    }

}
