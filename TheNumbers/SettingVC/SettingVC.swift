//
//  TimeSettingsViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 3.03.22.
//

//import UIKit
//
//class SettingVC: UIViewController {
//    var dataTimersArray: [Int] = [] //Массив dataTimersArray - храним таймеры для раунда
//    @IBOutlet weak var TimeSet: UITableView! {
//        didSet { TimeSet?.dataSource = self
//                 TimeSet?.delegate = self }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
//
//extension SettingVC: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataTimersArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = TimeSet.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath)
//        cell.textLabel?.text = String(dataTimersArray[indexPath.row])
//        return cell
//}
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(dataTimersArray[indexPath.row])
//        TimeSet.deselectRow(at: indexPath, animated: true)
//        SettingsClass.shared.currentSettings.timeForGame = dataTimersArray[indexPath.row] //Записываем выбранное время на раунд
//        navigationController?.popViewController(animated: true)
//    }
//}

