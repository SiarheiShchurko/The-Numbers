//
//  TimeSettingsViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 3.03.22.
//

import UIKit

class SettingVC: UIViewController {
    var dataTimersArray:[Int] = [] //Массив dataTimersArray - это масив с вариантами доступных таймеров для игры.
    @IBOutlet weak var TimeSet: UITableView!{
        didSet{    //Для того чтобы динамический VC начал заполняться самостоятельно строчками, VC TimeSettingsViewController должен использовать протокол dataSource. У данного протокола есть несколько обязательных методов.
            TimeSet?.dataSource = self // С помощью методов протокола dataSource будет передаваться кол-во строк и секций в таблице, а также их вид и свойства. Этот код говорит, что VC TimeSettingsViewController является dataSource для таблички TimeSet(оутлет которой мы прописали здесь)
            TimeSet?.delegate = self // delegate позволяет взаимодействовать со строками таблички. Отслеживать действия, например выбор ячейки.
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    }

extension SettingVC:UITableViewDataSource, UITableViewDelegate { //Добавляем протокол DataSource для VC TimeSettingsViewController через extension
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTimersArray.count  //Икс Код сам предлагает добавить два обязательных метода и первый из них: numberOfRowsInSection в который мы записываем кол-во строк которые будут созданы в таблице. Указано, что строк нам нужно столько, сколько есть элементов в массиве dataTimersArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  //В методе cellForRowAt мы должны указать какого рода ячейки это будут. Необходимо добавить Table view cell на экран настроек времени через "+" и указать его индификатор (мы указали "TimeCell")
        let cell = TimeSet.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) //Создаем константу и применяем метод dequeueReusableCell для оутлета TimeSet. Данный метод позволяет создавать ячейки либо переиспользовать созданные ячейки. За образец он будет брать ячейку, индефикатор на которую указан в withIdentifier. indexPath - это структура которая обозначает место каждой ячейки в таблице.
        cell.textLabel?.text = String(dataTimersArray[indexPath.row]) // Помещаем в строку cell строку c indexPath.row массива dataTimersArray. C помощью этого размещения мы будем видеть названия элементов массива.
        return cell
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //Метод didSelectRowAt (метод выбранной строки) поможет выделить строку с таймером, который мы хотим установить.
        print(dataTimersArray[indexPath.row])
        TimeSet.deselectRow(at: indexPath, animated: true) //Метод deselectRow снимает выделение со строки которую мы выбрали. Без этого метода, строка останется подсвечиваться серым цветом.
        //(Пример:UserDefaults.standard.set(dataTimersArray[indexPath.row], forKey: "ActualTimer") // Для хранения выбранного времени используется хранилище UserDefaults которое предназначено для данных небольшого объема такие как настройки. UserDefaults хранит данные по принципу Dictionary (value/key). standard здесь выступает глабальным экземпляром. Для того чтобы записать значение по ключу, используется метод set и его производные setValue и другие).
        //(Пример:UserDefaults.standard.integer(forKey: "ActualTimer") // Для того чтобы прочитать записанное значение в дальнейшем, используем тот же способ и UserDefaults.standard. а далее выбираем значение (Инт/Флоат/Дабл/Бул). Так как dataTimersArray содержит числа "инты" - указываем integer. Если мы бы незнали какого вида value привязан к данному ключу, используем вместо integer - objects но т.к. такое значение может быть не найдено, другими словами value может быть nil - делаем проверку через if).
        SettingsClass.shared.currentSettings.timeForGame = dataTimersArray[indexPath.row] //Записываем выбранное время на раунд
        navigationController?.popViewController(animated: true) //Возвращаемся на предыдущий вью контроллер.
    }
}

