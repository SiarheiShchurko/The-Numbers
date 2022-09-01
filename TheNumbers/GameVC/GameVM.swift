//
//  Game.swift
//  Pes
//
//  Created by Alinser Shchurko on 9.12.21.
//

import Foundation

enum StatusGame{  ///Энумы созданы для отражения статуса игры
    case start  ///Начало игры
    case win     /// Победа
    case lose    /// Поражение
}
class Game{
    
    struct Item {   ///Вложенная в класс структура. С ней сможет работать исключительно класс "гейм". Эта структура будет отвечать за кнопки в нашей игре.
        var title: String     ///Создаем свойство тайтл (у нас это номер кнопки)
        var isFound: Bool = false  ///Также создаем свойство которое спрашивает "Найдена ли кнопка?". По умолчанию данное свойство будет = false
        var isError: Bool = false ///Это свойство используем для для того, чтобы подсвечивать цветом неправильно нажатую кнопку. Менять данное свойство на true будем в функции сheck
    }
    
    private let data = Array(1...99) ///Создаем массив чисел от 0 до 99. Этот массив будет служить базой данных для чисел из которого мы и будем брать те самые числа (Непонятно почему он в круглых скобках)
    var itemArray: [Item] = [] ///Создаем пустой массив в который будут попадать 16 рандомных чисел из массива data.

    private var countItems:Int /// Для того чтобы игра понимала кол-во нужных кнопок, создаем свойство countItems. При создании экземпляра класса, введенное кол-во будет передоваться в игру и она будет понимать кол-во кнопок которое нужно разместить на экране
    var nextDigits:Item? ///Создаем свойство nextDigits типа Item. Используем optional т.к. вконце игры чисел не будет и код не должен возвращать какое-то число для поска/ Должен вернуться nil.
    var isTimerOff = false
    var isNewRecord = false
    var statusGame: StatusGame = .start { /// Создаем переменную для того чтобы отображать статусы игры. По умолчанию статус игры = старт
        didSet {
            if statusGame != .start { ///Если статус игры не равен статусу start...
                if statusGame == .win {
                    let newRecord = timeForGame - roundTimeForGame ///Для подсчета затраченного времени на прохождения раунда, для рекорда, от времени раунда отнимаем время которое осталось на момент завершения игры
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
    
    var timeForGame: Int                   ///Свойство timeForGame - статично. Мы его берем, чтобы игра, перед новым раундом давала кол-во секунд которое дано на раунд. Это настройка которая не изменяется. Записываем ее в функцию newGame
    private var roundTimeForGame: Int {    ///Добавляем свойство для времени раунда
        didSet{                      /// Прописываем didset для того чтобы понимать когда заканчивается время и определять статус игры
            if roundTimeForGame == 0{     /// Если timeForGame = 0
                statusGame = .lose   /// Мы проиграли
            }
            updateTimer(statusGame, roundTimeForGame) ///Статус игры и время на раунд обнулятся
        }
    }
    private var timer:Timer?   ///Создаем переменную таймер с типом данных опшинал
    private var updateTimer:(( StatusGame, Int )->Void) /// Создаем свойство для обновления времени на дисплее. Тип - функция. На нее прописываем инит. Поскольку апдейт таймер будет вызываться не в ините, а после проверки в дидсете, икс код предлагает ставить @escaping - cоглашаемся.
    
    init( countItems: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int ) -> Void) { ///Прописали иниты и для того чтобы мы могли выводить отсчет времени на экран, добавляем клоуджер updateTimer. В него мы закидываем статус игры, кол-во секунд. Этот клоуджер не возвращае ничего.
        self.countItems = countItems
        self.roundTimeForGame = SettingsClass.shared.currentSettings.timeForGame
        self.timeForGame = self.roundTimeForGame
        self.updateTimer = updateTimer
        setupGame() ///Чтобы создались кнопки, прописываем в инит функцию setupGame
    }
    
     func setupGame() {  ///Для того чтобы начать создавать items прописываем функцию. Задача этой функции создать неповторяющиеся items в количестве которое будет = countitems
         isNewRecord = false ///Перед началом игры сбрасываем значение нового рекорда
         itemArray.removeAll() ///Этот код очищает все элементы которые остались из предыдущей игры.
         var digits = data.shuffled()///Для каждой игры необходимо создавать временный массив (в нашем случае Digits). Метод shuffled перемешивает массив data для того чтобы каждую новую игру, цифры в игре отличались.
        while itemArray.count < countItems { /// Пока кол-во items в массиве itemArray менше чем мы ввели в сountItems при создании экземпляра структуры...
            let item = Item(title: String(digits.removeFirst())) ///...Cоздаем новый item который является экземпляром структуры Item. Новый Item мы берем из переменной digits методом removeFirst. Так как свойство title в структуре прописано "str", а наш код возвращает "int", преобразовываем "str" в "int"
            itemArray.append(item) /// C помощью данного кода мы добавляем созданный "item" в массив itemArray
        }
        updateTimer(statusGame,roundTimeForGame) ///Прописываем обновление таймера до момента создания таймера, чтобы отсчет начинался не так: "0,30,29,28...", а вот так: "30,29,28,27..."
         
         
        if SettingsClass.shared.currentSettings.timerOn{ ///Если timerOn - true - включаем таймер. Если нет, таймер не включится.
            
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                self?.roundTimeForGame -= 1}) ///Прописываем настройки для таймера. Устанавливаем отсчет посекундно:withTimeInterval: 1, повторяем repeats: true (если установить false - таймер отсчитает только одну секунду и остановится). В блоке прописываем [weak self] - это делается, чтобы не было утечек памяти когда мы используем self  в коде как здесь. Далее оставлляем пустые скобки т.к. Timer нам не нужен в блоке кода. После этого self становится optional и мы должны отметить это в коде знаком вопроса. В самом коде мы пишем то, что нам нужно обновлять. Обновлять нам нужно время. Добавляется свойство timeForGame-=1. То есть каждую секунду отнимаем от него 1 секунду.
            print("timer")
        }
        

        nextDigits = itemArray.shuffled().first ///Свойство nextDigits будет перемешивать каждый раз весь массив itemArray и брать из него первое число)
          ///После того как число найдено, снова перемешиваем массив и выбираем новый nextDigits
                }
    
    //MARK: Func CheckStatusGame
    func check(index: Int) { ///Создаем функцию которая проверяет число которое нужно найти и число которое мы нажали
        guard statusGame == .start else { return } /// Если статус игры не .start - игра становится неактивной. Без этого кода, после того как ты проиграл, можно продолжать жать разные кнопки.
        if itemArray[index].title == nextDigits?.title{ ///Если название индекса числа из массива будет равно тайтлу числа на которое идет нажатие
            itemArray[index].isFound = true /// Тогда мы меняем свойство isFound структуры Item на true. Если isFound = true - кнопка исчезает
        } else { /// В остальных случаях
            itemArray[index].isError = true ///Меняем свойство isError на true. Это означает, что нажата неверная кнопка.
        }
        nextDigits = itemArray.shuffled().first(where: { ( itemNext ) -> Bool in
            itemNext.isFound == false /// Следующее число == первому числу перемешанного массива, с условием того, что оно проверяется с найденными числами. Если .isFound == false - этот item еще не уавствовал в игре и будет предложен к поиску
        }
        )
        if nextDigits == nil { ///Если в nextDigits не осталось чисел
            statusGame = .win ///Печатаем статус "Победа"
        }
    }
    
    //MARK: Func stopGame if timer out.
    func stopGame() { ///Для того чтобы программа понимала условия при которой нужно останавливать игру, мы прописываем данную функцию
        timer?.invalidate() ///Данная функция останавливает таймер
        
    }
    
    //MARK: Func newGame
    func newGame() {          ///Эта функция для того, чтобы после окончания игры, мы могли запустить новую игру.
        statusGame = .start  ///При вызове этой функции, сразу же поменяется статус игры
        self.roundTimeForGame = self.timeForGame ///Восстанавливаем время на раунд. После завершения раунда в roundTimeForGame остается 0 секунд. Мы указываем, что roundTimeForGame = timeForGame который содержит в себе стандартыне 30 секунд.
        setupGame()          ///Затем, с помощью функции сетапгейм, произойдет ее настройка
    }
}

extension Int {  ///Для того, чтобы время выглядело в формате времени "минуты/секунды" создаем функцию с помощью расширения
    
    func newFormatTime() -> String { /// Функция ничего не принимает, а возвращает строку
        let minutes = self / 60 ///Введенное в расширение число делим на 60 чтобы понять кол-во минут
        let seconds = self % 60 ///Все что менее 60 идет в секунды
        return String(format: "%d:%02d", minutes, seconds) /// формат отображения минут и секунд.
    }
}
