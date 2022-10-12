//
//  RecordTableCell.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 27.09.22.
//

import UIKit

class RecordTableCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet private weak var nameOut: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var numberPlace: UILabel!
    
    private var recordVC: RecordViewController?
    
    //MARK: Set cell func
    func setRecordCell(_ record: RecordModel) {
        
        numberPlace.text = record.place
        
        nameOut.text = record.name
        
        time.text = ("\(record.time) sec.")
        
      
    }
}
