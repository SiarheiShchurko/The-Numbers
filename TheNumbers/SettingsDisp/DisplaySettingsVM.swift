//
//  SetDispBaseVM.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 23.09.22.
//

import UIKit


protocol SettingsVMProtocol {
    var defaultSettings: SettingParametrs { get }
    var currentSettings: SettingParametrs { get set }
}

class SetDispBaseVM: SettingsVMProtocol {
    
    //MARK: Default set
    let defaultSettings = SettingParametrs(timerOn: true, timeForGame: 30, musicOn: false)
    
    //MARK: Current settings
    var currentSettings: SettingParametrs {
        
        get {
            if let data = UserDefaults.standard.object(forKey: KeysSettings.actualSettingsGame) as? Data {
                return try! PropertyListDecoder().decode(SettingParametrs.self, from: data)
                
            } else {
                
                if ( try? PropertyListEncoder().encode(defaultSettings) ) != nil {
                    UserDefaults.standard.object(forKey: KeysSettings.actualSettingsGame)
                }
                return defaultSettings }
        }
        set {
            DispatchQueue.main.async {
                if let data = try? PropertyListEncoder().encode(newValue) {
                    UserDefaults.standard.set(data, forKey: KeysSettings.actualSettingsGame)
                }
            }
        }
    }
}

