//
//  VizListingTableViewCell.swift
//  DonutChartViewer
//
//  Created by Moorthy, Prashanth on 4/1/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

class VizListingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

        override var frame: CGRect {
            get {
                return super.frame
            }
            set (newFrame) {
                var frame = newFrame
                frame.origin.x += 10
                frame.size.width -= 20
                super.frame = frame
            }
        }
}
