//
//  SettingsStruct.swift
//  Pes
//
//  Created by Alinser Shchurko on 8.03.22.
//

import Foundation

enum KeysUserDefaults {
    static var actualSettingsGame = "actualSettingsGame" ///Чтобы не запутаться с ключами, создан этот enum. Мы записали, что ключ "actualSettingsGame" = переменной actualSettingsGame в enum. Теперь когда необходимо обратиться к к значению по ключу, указываем название enum и через точку ставим переменную необходимого значения.
    static let enumRecordKey = "RecordGame"
}
struct SettingsStruct: Codable { //Структура для хранения настроек. Для того чтобы сохранить структуру в хранилище ( это нужно для того чтобы измененные настройки игры записались), ее нужно закодировать.
    var timerOn: Bool  //Включен или выключен таймер?
    var timeForGame: Int //Сколько времени выбрано на раунд
}
class SettingsClass {
    
    static var shared = SettingsClass() //Single ton
    
    private let defaultSettings = SettingsStruct(timerOn: true, timeForGame: 30)
    
    var currentSettings: SettingsStruct { //Внутри класса SettingsClass() нужно сохранять экземпляр структуры SettingsStruct в хранилище, чтобы информация настроек игры записывалась и хранилась.
        get {  //Геттер принимает изменненные настройки. Для того чтобы их принять, нужно провести декодинг.
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.actualSettingsGame) as? Data { // Если  UserDefaults.standard.object  Data не пустая...
                return try! PropertyListDecoder().decode(SettingsStruct.self, from: data) //Проводится раскадировка этих данных с помощью PropertyListDecoder
            } else {
                if ( try? PropertyListEncoder().encode(defaultSettings) ) != nil {
                    UserDefaults.standard.object(forKey: KeysUserDefaults.actualSettingsGame)
                }
                return defaultSettings //Возвращаем настройки по умолчанию.
            }
        }
        set { if let data = try? PropertyListEncoder().encode(newValue) {  // Метод PropertyListEncoder кодирует данные, что обязательно для обновления настройки.
            UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.actualSettingsGame) //Здесь мы сохраняем измененные настройки в хранилище UserDefaults.standard. по ключу enum
        }
        }
    }
    func defaultSettingsReset(){
        currentSettings = defaultSettings
    }
}


