//
//  SettingsStruct.swift
//  Pes
//
//  Created by Alinser Shchurko on 8.03.22.
//

import Foundation

enum KeysUserDefaults {
    static var actualSettingsGame = "actualSettingsGame" ///Ключи по которым храненятся актуальные настройки
    static let enumRecordKey = "RecordGame"
}
struct SettingsStruct: Codable { ///Структура свойств по которым юзер выбирает нужные параметры
    var timerOn: Bool  ///Включен или выключен таймер?
    var timeForGame: Int ///Сколько времени выбрано на раунд
}
class SettingsClass {
    
    static var shared = SettingsClass() //Singleton
    
    //MARK: Default settings
    private let defaultSettings = SettingsStruct(timerOn: true, timeForGame: 30)
    
    
    var currentSettings: SettingsStruct {
        get {
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.actualSettingsGame) as? Data { /// Если  UserDefaults.standard.object  Data не пустая...
                return try! PropertyListDecoder().decode(SettingsStruct.self, from: data) ///Получаю настройки
            } else {
                if ( try? PropertyListEncoder().encode(defaultSettings) ) != nil {
                    UserDefaults.standard.object(forKey: KeysUserDefaults.actualSettingsGame)
                }
                return defaultSettings ///Если в дате ничего нет, беру дефолтные параметры
            }
        }
        set { if let data = try? PropertyListEncoder().encode(newValue) {  /// Если пришло новое значение
            UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.actualSettingsGame) ///сохраняю измененные настройки в хранилище UserDefaults.standard. по ключу enum
            
        }
        }
    }
    
    func defaultSettingsReset() {
        currentSettings = defaultSettings
    }
}


