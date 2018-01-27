//
//  TaskPickerScrollView.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 7/3/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit
import AKPickerView_Swift

protocol TaskPickerScrollViewDelegate {
    func taskPicked(index: Int)
    func addNewTaskClicked()
}

@IBDesignable

class TaskPickerScrollView: UIView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBOutlet weak var thePickerView: AKPickerView!

    var delegate: TaskPickerScrollViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()

    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

    func setupView() {
        let bundle = Bundle.init(for: type(of: self))
        let ourNib = UINib(nibName: "TaskPickerScrollView", bundle: bundle)
        let theView = ourNib.instantiate(withOwner: self, options: nil).first as! UIView
        theView.frame = self.bounds
        self.addSubview(theView)
    }

    @IBAction func addTaskButtonClicked(_ sender: UIButton) {
        delegate?.addNewTaskClicked()
    }

}
