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
struct SettingsStruct:Codable { //Структура создается для хранения настроек. //Для того чтобы сохранить структуру в хранилище ( это нужно для того чтобы измененные настройки игры записались), ее нужно закодировать. Для того чтобы структуру можно было закодировать и раскодировать нам нужны два протокола: Decodable и Encodable. Но есть общий протокол который включает в себя их обоих. Он называется: Codable. Его мы и прописываем.
    var timerOn:Bool  //Включен или выключен таймер?
    var timeForGame:Int //Сколько времени выбрано на раунд
}
class SettingsClass {  //
    static var shared = SettingsClass() //Это статичный экземпляр класса single ton. Он не будет уничтожен пока программа работатет. То есть если мы выбрали время на раунд 50 сек. оно будет постоянно пока мы либо не поменяем его сами, либо не переустановим приложение. В случае переустановки, все настройки откатятся к дефолтным.
    private let defaultSettings = SettingsStruct(timerOn: true, timeForGame: 30) //Создаем экземпляр структуры со стандартными настройками.
    var currentSettings:SettingsStruct { //Внутри класса SettingsClass() нужно сохранять экземпляр структуры SettingsStruct в хранилище, чтобы информация настроек игры записывалась и хранилась.
        get {  //Геттер принимает изменненные настройки. Для того чтобы их принять, нужно провести декодинг.
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.actualSettingsGame) as? Data { // Если  UserDefaults.standard.object  Data не пустая...
                return try! PropertyListDecoder().decode(SettingsStruct.self, from: data) //Проводится раскадировка этих данных с помощью PropertyListDecoder
            }else{ //D другом случае...
                if (try? PropertyListEncoder().encode(defaultSettings)) != nil { //Мы кодируем настройки по умолчанию
                    UserDefaults.standard.object(forKey: KeysUserDefaults.actualSettingsGame)    //И сохраняем их в UserDefaults
        }
                return defaultSettings //Возвращаем настройки по умолчанию.
            }
            }
        set { //Когда меняются настройки игры - будет вызываться setter и в этот момент мы сохраняем экземпляр структуры currentSettings в хранилище. Для внесения изменений в настройки необходимо закодировать данные с помощью PropertyListEncoder
//            do{
//            let data = try PropertyListEncoder().encode(newValue) //Метод PropertyListEncoder имеет обработчик ошибок. Если есть необходимость обрабатывать ошибку которую возвращает этот метод, прописываем его через "do", а перед самим методом прописываем try.
//            }catch{  //Здесь ловится ошибка
//                print("error") //Распечатывается
//            }
            if let data = try? PropertyListEncoder().encode(newValue){  // Метод PropertyListEncoder кодирует данные, что обязательно для обновления настройки.
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.actualSettingsGame) //Здесь мы сохраняем измененные настройки в хранилище UserDefaults.standard. по ключу enum
            }
    }
}
    func defaultSettingsReset(){
        currentSettings = defaultSettings
    }
}


