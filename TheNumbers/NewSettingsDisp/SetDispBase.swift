//
//  SetDispBase.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 20.09.22.
//

import UIKit
import Firebase

//MARK: Settings format
struct SettingParametrs: Codable { ///Структура свойств по которым юзер выбирает нужные параметры
    var timerOn: Bool  ///Включен или выключен таймер?
    var timeForGame: Int ///Сколько времени выбрано на раунд
}

//MARK: Enum for stored actual settings
enum KeysSettings {
    static var actualSettingsGame = "actualSettingsGame" ///Ключи по которым храненятся актуальные настройки
    static let enumRecordKey = "RecordGame"
}

class SetDispBase: UIViewController {
    
    //MARK: Singleton
    static var shared = SetDispBase()
    
    //MARK: Default settings
    private let defaultSettings = SettingParametrs(timerOn: true, timeForGame: 30)
    
    weak var delegate: UserLabelDelegate?
    
    
    //MARK: Current settings
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
    @IBOutlet private weak var nameTF: UITextField! {
        didSet {  let defaults = UserDefaults.standard
            guard let emailUser = Auth.auth().currentUser?.email else { return }
            nameTF.text = defaults.string(forKey: emailUser) }
    }
    
    //MARK: UISwitch timer
    @IBOutlet private weak var sWitch: UISwitch! {
        didSet { sWitch.isOn = SetDispBase.shared.currentSettings.timerOn }
    }
    
    //MARK: timeButton
    @IBOutlet private weak var timeButton: UIButton! {
        didSet { timeButton.setTitle("\(currentSettings.timeForGame) sec.", for: .normal)
            timeButton.isEnabled = SetDispBase.shared.currentSettings.timerOn
        }
            }
    
    @IBOutlet private weak var saveName: UIButton!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing( true )
    }
    
    
    //MARK: Tf action
    @IBAction private func nameTfAction(_ sender: UITextField) {
        let isEmpty = sender.text?.isEmpty ?? true
        saveName.isEnabled = !isEmpty
        nameTF.text = sender.text
    }
    
    //MARK: Save name
    @IBAction private func changeName() {
        guard let emailUser = Auth.auth().currentUser?.email else { return }
        let nameUser = nameTF.text
        UserDefaults.standard.set(nameUser, forKey: emailUser)
        delegate?.getInf(User(email: emailUser, name: nameUser))
        saveName.isEnabled = false
        nameTF.resignFirstResponder()
    }
    
    @IBAction private func sWitchIs(_ sender: UISwitch) {
        if sender.isOn {
            timeButton.isEnabled = true
            SetDispBase.shared.currentSettings.timerOn = true
        } else {
            timeButton.isEnabled = false
            SetDispBase.shared.currentSettings.timerOn = false }
    }
    
    @IBAction private func changeTime() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(NewSettings.self)") as? NewSettings else { return }
        nextVC.delegate = self
        present(nextVC, animated: true)
    }
    
    @IBAction private func defaultSettingsReset() {
        currentSettings = defaultSettings
        sWitch.isOn = SetDispBase.shared.currentSettings.timerOn
        timeButton.setTitle("\(currentSettings.timeForGame) sec.", for: .normal)
        timeButton.isEnabled = SetDispBase.shared.currentSettings.timerOn
    }
}

extension SetDispBase: DelegateTimeProtocol {
    func getTime(_ time: Int) {
        timeButton.setTitle("\(time) sec.", for: .normal)
        
    }
}


