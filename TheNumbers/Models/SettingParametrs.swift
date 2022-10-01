//
//  SettingParametrs.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.10.22.
//

import Foundation

//MARK: Settings format
struct SettingParametrs: Codable { ///Структура свойств по которым юзер выбирает нужные параметры
    var timerOn: Bool  ///Включен или выключен таймер?
    var timeForGame: Int ///Сколько времени выбрано на раунд
}
