//
//  SettingsTableTableViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 3.03.22.
//

import UIKit

class SettingsTableTableViewController: UITableViewController {

    @IBOutlet weak var SecondsChangeOut: UILabel!
    @IBOutlet weak var outlet2: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) { ///При загрузке дисплея каждый раз вызываем loadSettings()
        super.viewWillAppear(animated)
        loadSettings()
    }

    @IBAction func Action2(_ sender: UISwitch) {  ///Экшн для Свитча
        SettingsClass.shared.currentSettings.timerOn = sender.isOn ///Свитч включен если таймер тру
    }
    func loadSettings(){   ///Эта функция для загрузки настроек. Чтобы они отражались на дисплее.
        SecondsChangeOut.text = "\(SettingsClass.shared.currentSettings.timeForGame) sec" ///Для настройки времени используем оутлет для лэйбла 30сек. Указывается - что будет отражаться время выбранное в timeForGame
        outlet2.isOn = SettingsClass.shared.currentSettings.timerOn ///Указывается что положение свитча будет указываться исходя из того, false or true положение timerOn.
    }
    @IBAction func DefaultSetAction(_ sender: Any) {
        SettingsClass.shared.defaultSettingsReset() ///Обнуляем настройки по умолчанию.
        loadSettings() ///Дублируем загрузку настроек для обновления времени и переключателя. Без этой функции мы не увидим изменений на дисплее.
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { ///Задача-передать массив с числами, которые являются вариантами таймеров (все эти варианты выбора времени, будет массив интеджеров) из VC settings в VC time settings. Для этого подходит метод prepare. Задаем для segue двух VC индификатор SegueTimeSelect
        switch segue.identifier{  /// Фильтр по индификатору перехода
        case "SegueTimeSelect":   /// Указываем нужный segue identifier (мы его сами задали в переходах между VC
            if let segueTimeSelectVC = segue.destination as? TimeSettingsViewController{  ///Создаем константу с методом destination для перехода segue и проверяем, что это переход на TimeSettingsViewController
                segueTimeSelectVC.dataTimersArray = [10,20,30,40,50,60,70,80,90,100,110,120] /// В TimeSettingsViewController создан пустой массив dataTimersArray. Здесь же мы добавляем в него массив чисел (секунды для таймера)
            }
        default:
            break
        }
    }
}
