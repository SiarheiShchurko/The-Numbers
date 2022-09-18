//
//  Game.swift
//  Pes
//
//  Created by Alinser Shchurko on 9.12.21.
//

import Foundation

enum StatusGame {  ///StatusGame отражает статус игры
    case start
    case win
    case lose
}

class Game {
    
    struct Item {   ///Структура Item  отвечает за кнопки в  игре.
        var title: String     ///Тайтл кнопки
        var isFound: Bool = false  ///Найдена ?
        var isError: Bool = false ///Нажата не та кнопка
    }
    
    private let data = Array(1...99) ///Массив который хранит весь объем возможных чисел
    var itemArray: [Item] = [] ///Массив в который закидываю отобранные числа из массива data.

    private var countItems: Int ///Кол-во кнопок
    
    var nextDigits: Item? ///Оptional т.к. вконце игры чисел не будет и код не должен возвращать какое-то число для поска/ Должен вернуться nil.
    var isTimerOff = false
    var isNewRecord = false
    var statusGame: StatusGame = .start {
        didSet { if statusGame != .start {
            if statusGame == .win {
                let newRecord = timeForGame - roundTimeForGame
                let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.enumRecordKey ) /// Сохраняем рекорд в юзер дефаултс. Подтягиваем его также по стасичному ключу
                if record == 0 || newRecord < record {   ///Если в рекорд нет сохраненных рекордов (играем в первый раз в игру) или новый рекорд меньше записанного рекорда
                    UserDefaults.standard.setValue(newRecord, forKey: KeysUserDefaults.enumRecordKey)///Записываем результат timeForGame-roundTimeForGame в Record
                    isNewRecord = true ///Если новый рекорд записан в юзер дефаултс, меняем статус переменной isNewRecord на тру.
                }
            }
            stopGame() ///Останавливаем таймер
        }
        }
    }
    
    var timeForGame: Int                   ///Свойство timeForGame - статично. Содержит в себе полный объем времени который выбран для прохождения раунда в настройках
    private var roundTimeForGame: Int {    ///Вычисляемое свойство
        didSet { if roundTimeForGame == 0 {     /// Если timeForGame = 0
            statusGame = .lose   /// Проигрыш
        }
            updateTimer(statusGame, roundTimeForGame) ///Статус игры и время на раунд обнулятся
        }
    }
    
    private var timer: Timer?
    
    private var updateTimer:(( StatusGame, Int ) -> Void) /// свойства модели
    
    init( countItems: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int ) -> Void) { ///Через эскейпинг обновляется UI на VC
        self.countItems = countItems
        self.roundTimeForGame = SettingsClass.shared.currentSettings.timeForGame
        self.timeForGame = self.roundTimeForGame
        self.updateTimer = updateTimer
        setupGame() ///Чтобы создались кнопки, прописываем в инит функцию setupGame
    }
    
    func setupGame() {  ///Для того чтобы начать создавать items прописываем функцию. Задача этой функции создать неповторяющиеся items в количестве которое будет = countitems
        isNewRecord = false
        itemArray.removeAll()
        var digits = data.shuffled()
        while itemArray.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            itemArray.append(item) }
        updateTimer(statusGame,roundTimeForGame) ///Прописал обновление таймера до момента создания таймера, чтобы отсчет начинался не так: "0,30,29,28...", а вот так: "30,29,28,27..."
        
        if SettingsClass.shared.currentSettings.timerOn {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [ weak self ] (_) in
                self?.roundTimeForGame -= 1})
        }
        nextDigits = itemArray.shuffled().first
    }
    
    //MARK: Func CheckStatusGame
    func check(index: Int) {
        guard statusGame == .start else { return }
        if itemArray[index].title == nextDigits?.title { ///Если тайтлы совпадают
            itemArray[index].isFound = true ///статус кнопки - найдена
        } else {
            itemArray[index].isError = true ///В обратном случае ошибка
        }
        nextDigits = itemArray.shuffled().first(where: { ( itemNext ) -> Bool in
            itemNext.isFound == false /// Следующее число == первому числу перемешанного массива, с условием того, что оно проверяется с найденными числами. Если .isFound == false - этот item еще не уавствовал в игре и будет предложен к поиску
        }
        )
        if nextDigits == nil {
            statusGame = .win
        }
    }
    
    //MARK: Func stopGame if timer out.
    func stopGame() {
        timer?.invalidate()
    }
    
    //MARK: Func newGame
    func newGame() {
        statusGame = .start
        self.roundTimeForGame = self.timeForGame
        setupGame()
    }
}

//MARK: Update time formet
extension Int {
    
    func newFormatTime() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%d:%02d", minutes, seconds) 
    }
}
