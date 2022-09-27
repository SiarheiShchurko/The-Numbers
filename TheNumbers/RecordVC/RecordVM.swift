//
//  RecordVM.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 27.09.22.
//

import UIKit

protocol RecordProtocolVM: AnyObject {
    
    var recordObjects: [RecordModel] { get set }
    
}

class RecordVM: RecordProtocolVM {
    
    var recordObjects: [RecordModel] = []
    

    
}
