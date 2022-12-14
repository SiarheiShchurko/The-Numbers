//
//  SetDispBase.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 20.09.22.
//

import UIKit
import Firebase



//MARK: Enum for stored actual settings
enum KeysSettings {
    
    static var actualSettingsGame = "actualSettingsGame" ///Ключи по которым храненятся актуальные настройки
    
}

final class SetDispBase: UIViewController {
    
    //MARK: Singleton
    static var shared = SetDispBase()
    
    //MARK: Model var for self class
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
    
    //MARK: UISwitch
    //timer
    @IBOutlet private weak var sWitch: UISwitch! {
        didSet { sWitch.isOn = settingsVM.currentSettings.timerOn }
    }
    @IBOutlet private weak var sWitchMusik: UISwitch! {
        didSet { sWitchMusik.isOn = settingsVM.currentSettings.musicOn  }
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
    
    @IBAction private func musicON(_ sender: UISwitch) {
        if sender.isOn {
            settingsVM.currentSettings.musicOn = true
        } else {
            settingsVM.currentSettings.musicOn = false
        }
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
        sWitch.isOn = settingsVM.defaultSettings.timerOn
        sWitchMusik.isOn = settingsVM.defaultSettings.musicOn
        timeButton.setTitle("\(settingsVM.defaultSettings.timeForGame) sec.", for: .normal)
        timeButton.isEnabled = settingsVM.defaultSettings.timerOn
    }
}

//MARK: For time delegate func
extension SetDispBase: DelegateTimeProtocol {
    
    func getTime(_ time: Int) {
        timeButton.setTitle("\(time) sec.", for: .normal)
    }
}

//MARK: Delegate for name and email user
extension SetDispBase: UserLabelDelegate {
    func getInf(_ inf: User) {
        guard let eMailUser = inf.email else { return }
        let defaults = UserDefaults.standard
        nameTF.text = defaults.string(forKey: eMailUser)
    }
}


