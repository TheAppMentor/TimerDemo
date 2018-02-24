//
//  InfoAlertView.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/16/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import SCLAlertView

protocol InfoAlertEventHandler {
    func userOptedToTakeShortBreak()
    func userOptedToTakeLongBreak()
    func userOptedToContinueWorking()

    func userOptedToAbandonTask()
    func userDoesNotWantToAbandonCurrentTask()
}

class InfoAlertView: SCLAlertView {

    var delegateActionHandler: InfoAlertEventHandler?

    convenience init(actionDelegate: InfoAlertEventHandler? = nil) {
        self.init()
        delegateActionHandler = actionDelegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init() {
        super.init()
    }

    func showAlertForTaskComplete(durationString: String = "") {

        var appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Utilities.shared.fontWithRegularSize,
            kTextFont: Utilities.shared.fontWithLargeSize,
            kButtonFont: Utilities.shared.fontWithRegularSize,
            showCloseButton: true
        )

        appearance.kWindowWidth = 300.0
        appearance.kWindowHeight = 800.0

        let alertView = SCLAlertView(appearance: appearance)

//        alertView.addButton("Short Break", target:self, selector:Selector("firstButton"))
        alertView.addButton("Short Break") {
            self.delegateActionHandler?.userOptedToTakeShortBreak()
        }

        alertView.addButton("Continue Focus") {
            self.delegateActionHandler?.userOptedToContinueWorking()
        }
        alertView.showSuccess("Task Complete", subTitle: durationString)
    }

    func showAlertForTaskPausedAbandoned(durationString: String = "") {

        var appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Utilities.shared.fontWithRegularSize,
            kTextFont: Utilities.shared.fontWithLargeSize,
            kButtonFont: Utilities.shared.fontWithRegularSize,
            showCloseButton: false
        )

        appearance.kWindowWidth = 300.0
        appearance.kWindowHeight = 800.0

        let alertView = SCLAlertView(appearance: appearance)

        //        alertView.addButton("Short Break", target:self, selector:Selector("firstButton"))

        alertView.addButton("Resume Task") {
            self.delegateActionHandler?.userDoesNotWantToAbandonCurrentTask()
        }

        alertView.addButton("Abandon Task") {
            self.delegateActionHandler?.userOptedToAbandonTask()
        }

        alertView.showWarning("Task Paused", subTitle: durationString)
    }

    func showAlertForTaskPaused() {

        var appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Utilities.shared.fontWithRegularSize,
            kTextFont: Utilities.shared.fontWithLargeSize,
            kButtonFont: Utilities.shared.fontWithRegularSize,
            showCloseButton: true
        )

        appearance.kWindowWidth = 300.0
        appearance.kWindowHeight = 800.0

        let alertView = SCLAlertView(appearance: appearance)

        //        alertView.addButton("Short Break", target:self, selector:Selector("firstButton"))
//        alertView.addButton("Yes, Cancel it.") {
//            self.delegateActionHandler?.userOptedToAbandonTask()
//        }

        alertView.addButton("Resume Task") {
            self.delegateActionHandler?.userDoesNotWantToAbandonCurrentTask()
        }

        alertView.showWarning("Task Paused", subTitle: "25:00")
    }

    func showAlertForLongBreakComplete() {

        var appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Utilities.shared.fontWithRegularSize,
            kTextFont: Utilities.shared.fontWithLargeSize,
            kButtonFont: Utilities.shared.fontWithRegularSize,
            showCloseButton: true
        )

        appearance.kWindowWidth = 300.0
        appearance.kWindowHeight = 800.0

        let alertView = SCLAlertView(appearance: appearance)

        alertView.addButton("Continue Focus") {
            self.delegateActionHandler?.userOptedToContinueWorking()
        }
        alertView.showSuccess("Task Complete", subTitle: "25:00")
    }

    func showAlertForShortBreakComplete() {

        var appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Utilities.shared.fontWithRegularSize,
            kTextFont: Utilities.shared.fontWithLargeSize,
            kButtonFont: Utilities.shared.fontWithRegularSize,
            showCloseButton: true
        )

        appearance.kWindowWidth = 300.0
        appearance.kWindowHeight = 800.0

        let alertView = SCLAlertView(appearance: appearance)

        alertView.addButton("Continue Focus") {
            self.delegateActionHandler?.userOptedToContinueWorking()
        }
        //alertView.showSuccess("Task Complete", subTitle: "25:00")
        alertView.showCustom("Short Break Done", subTitle: "It's Time To Focus", color:Utilities.shared.lightBlueColor, icon: #imageLiteral(resourceName: "Coffee Mug White"))
    }

    func setupAlertAppearance() {
        // SCLAlertView.SCLAppearanc has more than 15 different properties to customize. See below.

//        let appearance = SCLAlertView.SCLAppearance(kDefaultShadowOpacity: <#T##CGFloat#>, kCircleTopPosition: <#T##CGFloat#>, kCircleBackgroundTopPosition: <#T##CGFloat#>, kCircleHeight: <#T##CGFloat#>, kCircleIconHeight: <#T##CGFloat#>, kTitleTop: <#T##CGFloat#>, kTitleHeight: <#T##CGFloat#>, kWindowWidth: <#T##CGFloat#>, kWindowHeight: <#T##CGFloat#>, kTextHeight: <#T##CGFloat#>, kTextFieldHeight: <#T##CGFloat#>, kTextViewdHeight: <#T##CGFloat#>, kButtonHeight: <#T##CGFloat#>, kTitleFont: <#T##UIFont#>, kTextFont: <#T##UIFont#>, kButtonFont: <#T##UIFont#>, showCloseButton: <#T##Bool#>, showCircularIcon: <#T##Bool#>, shouldAutoDismiss: <#T##Bool#>, contentViewCornerRadius: <#T##CGFloat#>, fieldCornerRadius: <#T##CGFloat#>, buttonCornerRadius: <#T##CGFloat#>, hideWhenBackgroundViewIsTapped: <#T##Bool#>, contentViewColor: <#T##UIColor#>, contentViewBorderColor: <#T##UIColor#>, titleColor: <#T##UIColor#>)

    }

    func firstButton() {
        print("first button tapped")
    }

}
