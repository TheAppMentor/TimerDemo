//
//  LegendTableView.swift
//  DonutChartViewer
//
//  Created by Moorthy, Prashanth on 4/1/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

@IBDesignable

class LegendTableView: UITableView {

    @IBInspectable var cornerRadius: CGFloat = 10.0

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.cornerRadius = cornerRadius

    }
}
