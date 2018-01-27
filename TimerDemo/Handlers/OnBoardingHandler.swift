//
//  OnBoardingHandler.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 8/12/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import Foundation
import AlertOnboarding

class OnBoardingHandler: AlertOnboardingDelegate {

    var actionOnSkipOrComplete : () -> Void

    init(actionOnSkipOrComplete : @escaping ()->Void) {
        self.actionOnSkipOrComplete = actionOnSkipOrComplete
    }

    func showOnBoardingScreen() {
        let alertBoy = AlertOnboarding.init(arrayOfImage: ["Swamy", "Swamy", "Swamy"], arrayOfTitle: ["Focus Monk", "Gain Insights", "Get Started"],
                                            arrayOfDescription: ["Focus Monk helps you measure the time you spend on your most important tasks.",
                                                                 "Our data gives you insights on how you are spending your time.",
                                                                 "Its that easy. Next, Create a task you want to focus on, and get going."])
        customizeAlertView(onboardingView: alertBoy)

        alertBoy.delegate = self
        alertBoy.show()
    }

    func customizeAlertView(onboardingView: AlertOnboarding) {

//        //Modify background color of AlertOnboarding
//        self.alertView.colorForAlertViewBackground = UIColor(red: 173/255, green: 206/255, blue: 183/255, alpha: 1.0)
//
//        //Modify colors of AlertOnboarding's button
        onboardingView.colorButtonText = UIColor.white
        //onboardingView.colorButtonBottomBackground = UIColor(red: 65/255, green: 165/255, blue: 115/255, alpha: 1.0)
        onboardingView.colorButtonBottomBackground = Utilities.shared.lightRedColor

        //
//        //Modify colors of labels
//        self.alertView.colorTitleLabel = UIColor.whiteColor()
//        self.alertView.colorDescriptionLabel = UIColor.whiteColor()
//
        //Modify colors of page indicator
        onboardingView.colorPageIndicator = Utilities.shared.lightGrayColor
        onboardingView.colorCurrentPageIndicator = Utilities.shared.darkRedColor
//
//        //Modify size of alertview (Purcentage of screen height and width)
        onboardingView.percentageRatioHeight = 0.75
//        self.alertView.percentageRatioWidth = 0.5
//
//        //Modify labels
        onboardingView.titleSkipButton = "Skip"
        onboardingView.titleGotItButton = "Got it"
    }

    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        actionOnSkipOrComplete()
    }

    func alertOnboardingCompleted() {
        actionOnSkipOrComplete()
    }

    func alertOnboardingNext(_ nextStep: Int) {
    }

}
