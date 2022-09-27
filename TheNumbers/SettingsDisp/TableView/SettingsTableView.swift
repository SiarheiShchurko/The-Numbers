//
//  NewSettings.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 20.09.22.
//

import UIKit

protocol DelegateTimeProtocol: AnyObject {
    func getTime(_ time: Int)
}

class NewSettings: UIViewController {
    
    private var settingsVM: SettingsVMProtocol = SetDispBaseVM()
    
    weak var delegate: DelegateTimeProtocol?
    
    var changeTimeArray: [Int] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
    
    @IBOutlet private weak var tableViewOut: UITableView! {
        didSet { tableViewOut.delegate = self
                 tableViewOut.dataSource = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension NewSettings: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        changeTimeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimeTableVCell.self)", for: indexPath) as? TimeTableVCell
        cell?.setFunc(changeTimeArray[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settingsVM.currentSettings.timeForGame = changeTimeArray[indexPath.row]
        delegate?.getTime(changeTimeArray[indexPath.row])
        dismiss(animated: true)
        
    }
    
    
    
    
    
}
