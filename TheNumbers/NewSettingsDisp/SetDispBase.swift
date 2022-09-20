//
//  SetDispBase.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 20.09.22.
//

import UIKit

enum KeysUserDefaults {
    static var actualSettingsGame = "actualSettingsGame" ///Ключи по которым храненятся актуальные настройки
    static let enumRecordKey = "RecordGame"
}

class SetDispBase: UIViewController {
    
    struct SettingsStruct: Codable { ///Структура свойств по которым юзер выбирает нужные параметры
        var timerOn: Bool  ///Включен или выключен таймер?
        var timeForGame: Int ///Сколько времени выбрано на раунд
    }
    
    private let defaultSettings = SettingsStruct(timerOn: true, timeForGame: 30)
    
    //MARK: TF nameSet
    @IBOutlet private weak var nameTF: UITextField!
    
    //MARK: UISwitch timer
    @IBOutlet private weak var sWitch: UISwitch!
    
    //MARK: timeButton
    @IBOutlet private weak var timeButton: UIButton! {
        didSet {
            if !KeysUserDefaults.actualSettingsGame.isEmpty {


                let time = defaultSettings.timeForGame
                timeButton.setTitle("\(time) sec", for: .normal)
                
                            } 
//                                let time = KeysUserDefaults.actualSettingsGame.
//                                timeButton.setTitle("\()", for: .normal)
//                            }
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func sWitchIs(_ sender: UISwitch) {
        if sender.isOn {
            timeButton.isEnabled = true
        } else {
            timeButton.isEnabled = false
        }
    }
    @IBAction private func changeTime() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(NewSettings.self)") as? NewSettings else { return }
        present(nextVC, animated: true)
    }
    
    

}
