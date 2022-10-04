//
//  GameViewController.swift
//  Pes
//
//  Created by Alinser Shchurko on 7.12.21.
//

import UIKit



class GameViewController: UIViewController {
    
    //MARK: Labels
    @IBOutlet private weak var NextDigit: UILabel!
    @IBOutlet private weak var StatusLabel: UILabel!
    @IBOutlet private weak var TimerLabel: UILabel!
    
    //MARK: Buttons
    @IBOutlet var buttons: [UIButton]! {
        didSet { buttons.forEach({ button in
            cornerRadius(button)
        })}
    }
    @IBOutlet private weak var NewGameOutlet: UIButton!
  
    //MARK: VM var
     lazy private var game = Game(countItems: buttons.count) { [ weak self ] ( status, seconds ) in
        guard let self = self else { return }
         if seconds <= 10 {
             self.TimerLabel.textColor = .systemRed
             self.TimerLabel.text = seconds.newFormatTime() ///Настройка отображения времени в лейбле
             self.globalStatus(status: status)
         } else {
             self.TimerLabel.textColor = .white
             self.TimerLabel.text = seconds.newFormatTime() ///Настройка отображения времени в лейбле
             self.globalStatus(status: status)  ///Закидываю статус из функции globalStatus (в ней выполняю чек свитчем)
         }
     }
    
    //MARK: - LIFECYCLE
    override func viewWillDisappear(_ animated: Bool) {
        game.stopGame()
        game.audioPlayer?.audioPlayerService.queuePlayer.pause()
    }

    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        game.newGame()
        setUpScreen()
        
    }
    
              
  // MARK: Press button func
    @IBAction private func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        game.check(index: buttonIndex) ///Сверка индекса
        updateUI()
    }
    

    //MARK: SetUP screen func
    private func setUpScreen() {
        if SetDispBase.shared.settingsVM.currentSettings.timerOn != true {
            TimerLabel.isHidden = true
        }
            for index in game.itemArray.indices {
                buttons[index].setTitle(game.itemArray[index].title, for: .normal) 
                buttons[index].alpha = 1
                buttons[index].isEnabled = true
            }
            NextDigit.text = game.nextDigits?.title 
        }
    
    //MARK: Func update UI when user press true button
    private func updateUI() {
        
    for indexUI in game.itemArray.indices { // Заносим все индексы массива itemArray в index
    buttons[indexUI].alpha = game.itemArray[indexUI].isFound ? 0 : 1
        buttons[indexUI].isEnabled = !game.itemArray[indexUI].isFound

        if game.itemArray[indexUI].isError { ///Eсли нажата неверная кнопка (индекс кнопки имеет свойство isError)
            UIView.animate(withDuration: 0.2) { [ weak self ] in
                self?.buttons[indexUI].backgroundColor = .red
            } completion: { [ weak self ] (_) in
                self?.buttons[indexUI].backgroundColor = .white
                self?.game.itemArray[indexUI].isError = false
            }
        }
    }
        NextDigit.text = game.nextDigits?.title ///После ошибки даю новое значение
        globalStatus(status: game.statusGame) ///Статус игры обновляется
            }
    
    //MARK: Check StatusGame
    private func globalStatus(status: StatusGame) {
        
        switch status {
        case .start:
            StatusLabel.isHidden = true
            
        case .win:
            StatusLabel.text = "You win"
            StatusLabel.textColor = .green
            StatusLabel.isHidden = false
            
            if RecordPlaces.isNewRecord {
                recordAlert()
            }
            if RecordPlaces.isSecondPlace {
                secondPlaceAlert()
            }
            if RecordPlaces.isThirdPlace {
                thirdPlaceAlert()
            }
            showAlertActionSheet()
            
        case .lose:
            StatusLabel.text = "You lose"
            StatusLabel.textColor = .red
            StatusLabel.isHidden = false
            showAlertActionSheet()
      }
    }
    
  
    
    //MARK: Func for new record
    private func recordAlert() {
        
        let alert = UIAlertController(title: "Congratilate", message: "It is NEW RECORD", preferredStyle: .alert)
        let alertButtonOk = UIAlertAction(title: "Ok", style: .default) { _ in
            self.showAlertActionSheet()
        }
        alert.addAction(alertButtonOk)
        present(alert, animated: true, completion: nil)
    }
    
    //SecondPlace
    private func secondPlaceAlert() {
        let alert = UIAlertController(title: "Congratilate", message: "It is 2 PLACE", preferredStyle: .alert)
        let alertButtonOk = UIAlertAction(title: "Ok", style: .default) { _ in
            self.showAlertActionSheet()
        }
        alert.addAction(alertButtonOk)
        present(alert, animated: true, completion: nil)
    }
    
    //ThirdPlace
   private func thirdPlaceAlert() {
        let alert = UIAlertController(title: "Congratilate", message: "It is 3 PLACE", preferredStyle: .alert)
        let alertButtonOk = UIAlertAction(title: "Ok", style: .default) { _ in
            self.showAlertActionSheet()
        }
        alert.addAction(alertButtonOk)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Alert for when game is over
   private func showAlertActionSheet() {
        let alert = UIAlertController(title: "What you want do?", message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "Start New Game", style: .default) { [ weak self ] (_) in
            self?.game.newGame()
            self?.setUpScreen()
        }
        
        let showRecord = UIAlertAction(title: "Looked Record", style: .default) { [ weak self ] (_) in
            self?.performSegue(withIdentifier: "AlertRecordSeague", sender: nil)
            }
 
        let returnMenu = UIAlertAction(title: "Back to Menu", style: .destructive) { [ weak self ] (_) in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(returnMenu)
        alert.addAction(cancel)
        if let popover = alert.popoverPresentationController { ///Для планшетов
           popover.sourceView = self.view ///sourceView - это вью к которой привязывается поповер
          popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0) ///По умолчанию, при привязке поповера у него есть стрелочка. Отключаю ее.
        }
        present(alert, animated: true, completion: nil)
    }
}



