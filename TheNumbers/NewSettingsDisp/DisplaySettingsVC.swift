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
    
    var settingsVM: SettingsVMProtocol = SetDispBaseVM()
    
    //MARK: Default settings
    
    weak var delegate: UserLabelDelegate?
    
    //MARK: TF nameSet
    @IBOutlet private weak var nameTF: UITextField! {
        didSet {
            guard let eMailUser = Auth.auth().currentUser?.email else { return }
            let defaults = UserDefaults.standard
            nameTF.text = defaults.string(forKey: eMailUser)
             }
    }
    
    //MARK: UISwitch timer
    @IBOutlet private weak var sWitch: UISwitch! {
        didSet { sWitch.isOn = settingsVM.currentSettings.timerOn }
    }
    
    //MARK: timeButton
    @IBOutlet private weak var timeButton: UIButton! {
        didSet { timeButton.setTitle("\(settingsVM.currentSettings.timeForGame) sec.", for: .normal)
            timeButton.isEnabled = settingsVM.currentSettings.timerOn
        }
            }
    
    //MARK: Save name buton
    @IBOutlet private weak var saveName: UIButton!
    
    
    //MARK: Hide keyboard
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
    
    //MARK: Switch on/off
    @IBAction private func sWitchIs(_ sender: UISwitch) {
        if sender.isOn {
            timeButton.isEnabled = true
            settingsVM.currentSettings.timerOn = true
        } else {
            timeButton.isEnabled = false
            settingsVM.currentSettings.timerOn = false }
    }
    
    //MARK: Change time func
    @IBAction private func changeTime() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "\(NewSettings.self)") as? NewSettings else { return }
        nextVC.delegate = self
        present(nextVC, animated: true)
    }
    
    //MARK: Default set reset
    @IBAction private func defaultSettingsReset() {
        settingsVM.currentSettings = settingsVM.defaultSettings
        sWitch.isOn = settingsVM.currentSettings.timerOn
        timeButton.setTitle("\(settingsVM.currentSettings.timeForGame) sec.", for: .normal)
        timeButton.isEnabled = settingsVM.currentSettings.timerOn
    }
}

//MARK: For delegate func
extension SetDispBase: DelegateTimeProtocol {
    
    func getTime(_ time: Int) {
        timeButton.setTitle("\(time) sec.", for: .normal)
        
    }
}
extension SetDispBase: UserLabelDelegate {
    func getInf(_ inf: User) {
        guard let eMailUser = inf.email else { return }
        let defaults = UserDefaults.standard
        nameTF.text = defaults.string(forKey: eMailUser)
    }
}


