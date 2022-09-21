//
//  SetDispBase.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 20.09.22.
//

import UIKit

struct SettingParametrs: Codable { ///Структура свойств по которым юзер выбирает нужные параметры
    var timerOn: Bool  ///Включен или выключен таймер?
    var timeForGame: Int ///Сколько времени выбрано на раунд
}

enum KeysSettings {
    static var actualSettingsGame = "actualSettingsGame" ///Ключи по которым храненятся актуальные настройки
    static let enumRecordKey = "RecordGame"
}

class SetDispBase: UIViewController {

    static var shared = SetDispBase()
    
    private let defaultSettings = SettingParametrs(timerOn: true, timeForGame: 30)
    
    var currentSettings: SettingParametrs {
        
        get {
            if let data = UserDefaults.standard.object(forKey: KeysSettings.actualSettingsGame) as? Data {
                return try! PropertyListDecoder().decode(SettingParametrs.self, from: data)
            } else {
                if ( try? PropertyListEncoder().encode(defaultSettings) ) != nil {
                    UserDefaults.standard.object(forKey: KeysSettings.actualSettingsGame)
                }
                return defaultSettings
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: KeysSettings.actualSettingsGame)
            }
        }
    }
    
    //MARK: TF nameSet
    @IBOutlet private weak var nameTF: UITextField!
    
    //MARK: UISwitch timer
    @IBOutlet private weak var sWitch: UISwitch! {
        didSet { sWitch.isOn = SetDispBase.shared.currentSettings.timerOn }
    }
    
    //MARK: timeButton
    @IBOutlet private weak var timeButton: UIButton! {
        didSet { timeButton.setTitle("\(currentSettings.timeForGame)", for: .normal)
            timeButton.isEnabled = SetDispBase.shared.currentSettings.timerOn
        }
            }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func defaultSettingsFunc() {
        currentSettings = defaultSettings
    }
    
    @IBAction private func sWitchIs(_ sender: UISwitch) {
        if sender.isOn {
            timeButton.isEnabled = true
            SetDispBase.shared.currentSettings.timerOn = true
        } else {
            timeButton.isEnabled = false
            SetDispBase.shared.currentSettings.timerOn = false
        }
    }
    
    @IBAction private func changeTime() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(NewSettings.self)") as? NewSettings else { return }
        nextVC.delegate = self
        present(nextVC, animated: true)
    }
}

extension SetDispBase: DelegateTimeProtocol {
    func getTime(_ time: Int) {
        timeButton.setTitle("\(time) sec.", for: .normal)
    }
}
