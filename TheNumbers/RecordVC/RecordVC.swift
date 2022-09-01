//
//  RecordViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 14.03.22.
//

import UIKit

class RecordViewController: UIViewController {
    @IBOutlet weak var RecordLabelOut: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.enumRecordKey)  /// Вносим в рекорд записанный рекорд в UserDefaults
        if record != 0{  ///Если рекорд не равен 0
            RecordLabelOut.text = "Your record - \(record) seconds" ///Показываем рекорд на рекорд лейбле.
        }else{ ///Если рекорд ничего не взял из UserDefaults (рекорд не установлен)
            RecordLabelOut.text = "No record now" ///Говорим, что рекорда нет.
        }
    }
    
    @IBAction func CancelButtonAct(_ sender: Any) {
        dismiss(animated: true) ///Для того чтобы скрыть модальный VC используется метод dismiss
    }
    
}