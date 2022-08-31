//
//  GameViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 7.12.21.
//

import UIKit
//MARK: - PROPIRTIES
class GameViewController:UIViewController {
    @IBOutlet weak var NextDigit: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var NewGameOutlet: UIButton!
    
    //MARK: -
    lazy var game = Game(countItems: buttons.count) { [weak self] (status, seconds) in      /// Для того чтобы программа сама могла считать -во кнопок которое нужно выводить, создаем экзепляр класса игры и прописываем ему buttons.count (количество кнопок), timeForGame(время на раунд) + updateTime(обновление времени). Код будет сам брать кол-во buttons которое внесено в IBOutlet. Из-за того, что на момент написания кода IBOutlet уще не завершен, приходится ставить свойство Lazy для это экземпляра гейм т.к. икс код ргается на buttons)
        guard let self = self else {return} ///Используем "гард" для селф т.к. из-за weak self - self становится optional. Данная проверка избавляет от нужды ставить вопросы после self в коде ниже.
        self.TimerLabel.text = seconds.newFormatTime() ///Заносим отображение секунд в клоуджер. Формат отображения времени берем из расширения newFormatTime()
        self.globalStatus(status: status)  ///Заносим актуальный статус в параметр status клоуджера
    }
    //MARK: - LIFECYCLE
    override func viewWillDisappear(_ animated: Bool) {
        game.stopGame()  ///останавливаем таймер когда закрываем экран с игрой.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let x = 10
//        let y = 0
//       let summa = sum(x: x, y: y)
//        assert(summa != 10, "Sum is qualy 10")
//        print("LoG: \(summa)")
        setUpScreen()  ///Помещаем функцию которая регулирует настройки отображения во viewDidLoad. Помещаем в этот раздел т.к. здесь записываются данные, как должны выглядеть элементы которые не подвергались никаким действиям.
        
    }
              
  
//    @discardableResult func sum(x:Int,y:Int) -> Int{
//        return x + y
//    }
  // MARK: -
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return} ///Проверяем через guard индекс, который записали из buttons
        game.check(index: buttonIndex) ///Gосле того как мы получили через гуард buttonIndex - проверяем его через функцию чек в модели игры
        updateUI()
        
    }
    @IBAction func NewGameAction(_ sender: UIButton) {
        game.newGame() ///Привязывем к кнопке функцию newGame
        sender.isHidden = true ///Свойство кнопки по умолчанию: Скрытая
        setUpScreen() /// Вызываем эту функцию чтобы отобразить экран полностью готовый к игре.
    }
    private func setUpScreen() {  ///Это функция настройки экрана. Задача данной функции пройти по массиву itemArray из "Game" и присвоить каждому элементу свои свойства, а именно тайтл - то есть название каждой кнопки и второе - видимость.
        if SettingsClass.shared.currentSettings.timerOn != true {
            TimerLabel.isHidden = true  ///Если таймер выключен - скрываем его лейбл.
        }
            for index in game.itemArray.indices { ///Поскольку мы будем находить item по их индексам в array, добавляем .indices
                buttons[index].setTitle(game.itemArray[index].title, for: .normal) ///Внутри цикла берем индекс кнопки, и закрепляем за ней title, который найдется в массиве itemArray также по индексу + через точку добавляем .title чтобы title присвоился). Прописывем .normal для for
                buttons[index].alpha = 1 ///Мы прописали в updateUI, что тру у нас равно 0, 1 фолс. Если у кнопки фолс - она включена. Логично, что для первоначального отображения экрана игры - нам нужны все кнопки.
                buttons[index].isEnabled = true /// Активны ли все кнопки? Да это так.
       //buttons[index].isHidden = false ///Прописываем свойство isHidden = false, что означает, что все созданные индексы должны отображаться на экране
            }
            NextDigit.text = game.nextDigits?.title //Прописываем полученное число из nextDigits модели игры в NextDigit OUtlet который отображает число, которое нужно найти следующим.
        
        }
    func updateUI(){ //Пишем функцию которая будет обновлять дисплей когда мы будем находить кнопку
    for indexUI in game.itemArray.indices{ // Заносим все индексы массива itemArray в index
    buttons[indexUI].alpha = game.itemArray[indexUI].isFound ? 0 : 1 //Альфа - прозрачность, используется вместо свойства isHidden т.к. при верстке мы использовали stack view для адаптации размеров под любой дисплей. Из -за этого, при угадывании кнопки в игре, остающиеся на дисплее кнопки занимают пространство исчезнувшей. Чтобы это не происходило, мы используем прозрачность/Альфа.Если кнопка = найдена (true) - она равна 0(true). Если нет, она = 1 false.
        buttons[indexUI].isEnabled = !game.itemArray[indexUI].isFound//Также, альфа имеет свойство быть нажатой, даже в статусе прозрачности. Поэтому, чтобы в игре пользователь не мог на нее нажимать(на пустое место), необходимо ее отключить. То есть наша кнопка будет включена пока !game.itemArray[indexUI].isFound не равно тру.
    //buttons[indexUI].isHidden = game.itemArray[indexUI].isFound //Скрываем индекс buttons (цепляемся за индекс чтобы скрыть саму кнопку) когда этот индекс = индексу из массива itemArray
        if game.itemArray[indexUI].isError{ //А если нажата неверная кнопка (индекс кнопки имеет свойство isError)
            UIView.animate(withDuration: 0.3) { [weak self] in //Прописываем анимацию. withDuration - это время которое будет длиться анимация
                self?.buttons[indexUI].backgroundColor = .red //Далее, указывается, сама анимация. То есть мы берем саму кнопку "buttons[indexUI]" обращаясь к ней через self и указываем для нее красный цвет заднего плана.
            } completion: { [weak self] (_) in   //В completion мы указываем то, что происходит после завершения анимации.
                self?.buttons[indexUI].backgroundColor = .white //Возвращаем кнопке белый цвет
                self?.game.itemArray[indexUI].isError = false  //Убираем свойство isError
            }

        }
                }
                NextDigit.text = game.nextDigits?.title //Берем следующее значение
        globalStatus(status: game.statusGame) //Обновляем статус игры
            }
    
    func globalStatus(status: StatusGame){     //Пишем функцию для обновления статусов игры. Присваеваем для status значения StatusGame
        switch status {                        //Проверяем статус по следующим кейсам...
        case .start:                           //Если статус старт
            StatusLabel.text = "Игра началась" //Пишем "Игра началась"
            StatusLabel.textColor = .black     //Цвет надписи черный
            NewGameOutlet.isHidden = true      //При статусе игры "Старт" - кнопка скрыта
            
            
        case .win:                             //Если статус "Вин"
            StatusLabel.text = "Вы победили"   //Пишем "Вы победили"
            StatusLabel.textColor = .green     //Цвет надписи зеленый
            NewGameOutlet.isHidden = false     //При статусе игры "Победа" - кнопка отображена
            if game.isNewRecord{ 
                showAlert()
            }else{
                showAlertActionSheet()
            }
        case .lose:                            //Если статус "Луз"
            StatusLabel.text = "Вы проиграли"  //Пишем, что мы проиграли
            StatusLabel.textColor = .red       //Зеленым цветом
            NewGameOutlet.isHidden = false     //При статусе игры "Поражение" - кнопка отображена
            showAlertActionSheet()
            }
    }
    func showAlert(){  ///Для того чтобы прописать всплывающее окно в рекорде, прописываем функцию алерт.
        let alert = UIAlertController(title: "Congratilate", message: "It's New Record", preferredStyle: .alert) /// Помещаем в переменную alert UIAlertController с текстом который выводится в сплывающем сообщении. title - Заголовок. message - само сообщение. preferredStyle - стиль алерта (.alert или .actionTable)
        let alertButtonOk = UIAlertAction(title: "Ok", style: .default, handler: nil) ///В переменную alertButtonOk добавляем UIAlertAction который поможет отреагировать на всплывающее сообщение нажатием на кнопку.  title - это то что написано в кнопке. style - оформление кнопки (есть три вида: .default / .cancel / .distraction. handler - это фуекция которая выполняется при нажатии на кнопку ок. Поскольку дополнительных действий не требуется, оставляем nill.
        alert.addAction(alertButtonOk) ///Добавляем кнопку "ок" в алерт через addAction.
        present(alert, animated: true, completion: nil) ///Функция present отражает алерт
    }
    func showAlertActionSheet(){  /// Для примера прописываем функцию для алерта в стиле .actionSheet.
        let alert = UIAlertController(title: "What you want do?", message: nil, preferredStyle: .actionSheet) ///Также создаем алерт UIAlertController и прописываем ему настройки
        let newGameAction = UIAlertAction(title: "Start New Game", style: .default) { [weak self] (_) in
            self?.game.newGame() ///Привязывем к кнопке функцию newGame.
            self?.setUpScreen() /// Вызываем  функцию setUpScreen чтобы отобразить экран полностью готовый к игре.
        }
        let showRecord = UIAlertAction(title: "Looked Record", style: .default) { [weak self] (_) in
            self?.performSegue(withIdentifier: "AlertRecordSeague", sender: nil)
            }  ///Для перехода к модальному VC выполняется переход performSegue по Identifier
 
        let returnMenu = UIAlertAction(title: "Back to Menu", style: .destructive) { [weak self] (_) in  ///Функция возврата в главное меню
            self?.navigationController?.popToRootViewController(animated: true) ///Через navigationController, методом "pop" возвращаемся на главный контроллер - главное меню.
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)  ///Кнопка cancel которая оставляет пользователя на текущем экране.
        alert.addAction(newGameAction) ///Добавляем кнопку "Start New Game"
        alert.addAction(showRecord) ///Добавляем кнопку "Looked Record"
        alert.addAction(returnMenu) ///Добавляем кнопку "Back to Menu"
        alert.addAction(cancel) ///Добавляем кнопку "Cancel"
        if let popover = alert.popoverPresentationController{ ///Из-за того что iPad не отображают алерты стиля .actionSheet так как айфон. Из-за это нужно прописывать для iPad точку привязки popopver'a (popover - это и есть само окно). Создаем константу поповер и если alert.popoverPresentationController не nill, то мы перейдем в код ниже:
           popover.sourceView = self.view ///sourceView - это вью к которой привязывается поповер. В данном примере, мы привязываем поповер к основной вью self.view.
          popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) ///  Для того чтобы разместить поповер по центру используем метод sourceRect и указываем параметры CGRect "х" и "у" - middle x и middle y. Высота и ширина не важны.
          popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0) ///По умолчанию, при привязке поповера у него есть стрелочка. В случае если мы не привязывем поповер к какому то сообщению/лейблу итд, эта стрелочка выглядит неуместно. Ее можно отлючить подобным методом.
//            popover.sourceView = StatusLabel///Можно просто привязаться к какому-то вью на экране и не прописывать дополнительный код для размещения поповера на дисплее.
            
        
        }
        present(alert, animated: true, completion: nil) ///С помощью метода present - алерт выводится на дисплей.
    }
}



