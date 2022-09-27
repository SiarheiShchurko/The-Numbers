//
//  TimeTableVCell.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 20.09.22.
//

import UIKit

class TimeTableVCell: UITableViewCell {
    
    @IBOutlet private weak var timeLabel: UILabel!
    
    func setFunc(_ time: Int) {
        timeLabel.text = " \(time) sec."
    }
}
