//
//  RecordVM.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 27.09.22.
//

import UIKit

enum RecordList {
    static var one = "one"
    static var two = "two"
    static var three = "three"
}

protocol RecordProtocolVM: AnyObject {
    var update: (() -> Void)? { get set }
    var recordObjects: [ RecordModel ] { get set }
    func loadInfo()
  
    
}

class RecordVM: RecordProtocolVM {
    
    var update: (() -> Void)?
    
    var recordObjects: [ RecordModel ] = [] {
        didSet {  update?() }
    }
     
    func loadInfo() {
        var firstRecord: RecordModel {
            if let data = UserDefaults.standard.object(forKey: RecordList.one) as? Data {
                return try! PropertyListDecoder().decode(RecordModel.self, from: data)
            } else {
                return .init(name: "No Name", time: 0, place: "#1")
            }
        }
        
        var secondRecord: RecordModel {
            if let data = UserDefaults.standard.object(forKey: RecordList.two) as? Data {
                return try! PropertyListDecoder().decode(RecordModel.self, from: data)
            }
            return .init(name: "No Name", time: 0, place: "#2")
        }
        
        var threeRecord: RecordModel {
            if let data = UserDefaults.standard.object(forKey: RecordList.three) as? Data {
                return try! PropertyListDecoder().decode(RecordModel.self, from: data)
            }
            return .init(name: "No Name", time: 0, place: "#3")
        }

        recordObjects.append(firstRecord)
        recordObjects.append(secondRecord)
        recordObjects.append(threeRecord)
        
    }
    
}
