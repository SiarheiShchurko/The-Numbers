//
//  NewSettings.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 20.09.22.
//

import UIKit

class NewSettings: UIViewController {
    
    @IBOutlet private weak var tableViewOut: UITableView! {
        didSet { tableViewOut.delegate = self
                 tableViewOut.dataSource = self }
    }
    
    var changeTimeArray: [Int] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]

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
    
    
    
    
    
}
